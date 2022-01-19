import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviescollection/core/enums/route_name.dart';
import 'package:moviescollection/src/domain/entities/genre.dart';
import 'package:moviescollection/src/domain/entities/movie.dart';
import 'package:moviescollection/src/domain/entities/pagination.dart';
import 'package:moviescollection/src/presentation/blocs/genre/genre_cubit.dart';
import 'package:moviescollection/src/presentation/blocs/movie/movie_cubit.dart';
import 'package:moviescollection/src/presentation/widgets/base_adapter_pagination.dart';

import '../../../injection.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GenreCubit _genreCubit;
  late MovieCubit _movieCubit;

  late final ScrollController _scrollController;
  late TextEditingController controller;

  Pagination? _paginationMovieList;
  late List<Movie> _list;

  late List<Genre> _genreList;
  int _genreIndex = 0;

  static const int pageStart = 1;
  int _pageNumber = pageStart;

  bool _isLoading = false;
  bool _isLastPage = false;
  bool _isRetryingNextPage = false;

  @override
  void initState() {
    _genreList = [];
    _list = [];

    _genreCubit = sl<GenreCubit>();
    _genreCubit.getGenreList();

    _movieCubit = sl<MovieCubit>();
    _movieCubit.getMoviesEvent();

    _scrollController = ScrollController();
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _genreCubit.close();
    _movieCubit.close();

    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white10,
        body: Column(
          children: [_search(), _genresChip(), _listOfMovies()],
        ),
      ),
    );
  }

  _search() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(RouteName.search.name);
          },
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.search, size: 24, color: Colors.white),
              ),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: const Text('Movies Collection',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _genresChip() {
    return BlocBuilder<GenreCubit, GenreState>(
      bloc: _genreCubit,
      builder: (context, state) {
        if (state is GenreLoaded) {
          _genreList = [];
          _genreList.add(const Genre(id: 0, name: 'all'));
          _genreList.addAll(state.genreList);
        }

        return Container(
          height: 50,
          margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: ListView.builder(
              itemCount: _genreList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ChoiceChip(
                    label: Container(
                      constraints: const BoxConstraints(minWidth: 40),
                      child: Text(_genreList[index].name,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: _genreIndex == index
                                        ? Colors.white
                                        : Colors.black87,
                                  )),
                    ),
                    selected: _genreIndex == index,
                    onSelected: (bool selected) {
                      if (_genreIndex == index) return;
                      if (_genreIndex != index) {
                        _list = [];
                        _pageNumber = 1;
                      }
                      _genreIndex = index;
                      setState(() {});
                      _reloadData(_pageNumber);
                    },
                  ),
                );
              }),
        );
      },
    );
  }

  _listOfMovies() {
    return BlocBuilder<MovieCubit, MovieState>(
      bloc: _movieCubit,
      builder: (context, state) {
        if (state is MovieLoading) {
          _isLoading = true;
          if (_pageNumber == 1) return _loadingFirstPageIndicator();
        } else if (state is MovieLoaded) {
          _isLoading = false;
          _isRetryingNextPage = false;
          _paginationMovieList = state.response;

          _isLastPage = int.parse(_paginationMovieList!.metadata.currentPage) ==
              _paginationMovieList!.metadata.pageCount;

          _list.addAll(_paginationMovieList!.data!);
          _pageNumber += 1;
        } else if (state is MovieError) {
          _isLoading = false;
          if (_list.isEmpty) {
            return _retrying(state.message);
          } else {
            _isRetryingNextPage = true;
          }
        } else if (state is MovieNoConnection) {
          _isLoading = false;
          if (_list.isEmpty) {
            return _retrying('Check Network Connection');
          } else {
            _isRetryingNextPage = true;
          }
        }

        return Expanded(
          child: BaseAdapterPagination(
            items: _list,
            isLastPage: _isLastPage,
            isLoading: _isLoading,
            isRetryingNextPage: () => _isRetryingNextPage,
            isNetworkConnected: true,
            onLoadNextPage: () {
              if (!_isLoading) {
                _reloadData(_pageNumber);
              }
            },
            onBuildItem: (context, index) => _buildItem(index),
            onReloadItems: () {
              _pageNumber = 1;
              if (_list.isNotEmpty) {
                _list.removeRange(0, _list.length);
              }

              _reloadData();
            },
            onRetryLoadNextPage: (isRetryingNextPage) {
              _isRetryingNextPage = isRetryingNextPage;
              _reloadData(_pageNumber);
            },
            key: GlobalKey(),
          ),
        );
      },
    );
  }

  _buildItem(int index) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        color: Colors.white10,
        elevation: 8.0,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            RouteName.details.name,
            arguments: _list[index].id,
          ),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      bottomLeft: Radius.circular(4.0)),
                  child: CachedNetworkImage(
                    imageUrl: _list[index].poster,
                    placeholder: (context, url) => const Icon(Icons.movie),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _list[index].title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Row(
                              children: List.generate(
                                  _list[index].genres.length, (i) {
                                String genre = _list[index].genres[i];
                                if (i != 0) genre = ' / ' + genre;
                                return Text(
                                  genre,
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.white),
                                );
                              }),
                            )
                          ])))
            ],
          ),
        ),
      ),
    );
  }

  _reloadData([int pageNumber = 1]) {
    if (_genreIndex == 0) {
      _movieCubit.getMoviesEvent(pageNumber);
    } else {
      _movieCubit.getMoviesByGenreIdEvent(
          _genreList[_genreIndex].id, pageNumber);
    }
  }

  Widget _loadingFirstPageIndicator() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Please Wait',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  _retrying(String errMessage) {
    return Expanded(
      child: Center(
        child: SizedBox(
          height: 60,
          child: InkWell(
            onTap: () {
              _reloadData();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(errMessage, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.refresh, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Retry',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
