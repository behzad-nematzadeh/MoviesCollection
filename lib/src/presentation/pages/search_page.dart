import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviescollection/core/enums/route_name.dart';
import 'package:moviescollection/src/domain/entities/movie.dart';
import 'package:moviescollection/src/domain/entities/pagination.dart';
import 'package:moviescollection/src/presentation/blocs/movie/movie_cubit.dart';
import 'package:moviescollection/src/presentation/widgets/base_adapter_pagination.dart';

import '../../../injection.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late MovieCubit _movieCubit;

  late final ScrollController _scrollController;
  late TextEditingController _controller;

  Pagination? _paginationMovieList;
  late List<Movie> _list;

  Timer? _debounce;

  static const int pageStart = 1;
  int _pageNumber = pageStart;

  bool _isLoading = false;
  bool _isLastPage = false;
  bool _isRetryingNextPage = false;

  @override
  void initState() {
    _list = [];
    _movieCubit = sl<MovieCubit>();

    _scrollController = ScrollController();
    _controller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _movieCubit.close();

    _scrollController.dispose();
    if (_debounce != null) _debounce!.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white10,
        body: Column(
          children: [_search(), const SizedBox(height: 8.0), _listOfMovies()],
        ),
      ),
    );
  }

  _search() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextField(
          controller: _controller,
          onChanged: onSearchTextChanged,
          autofocus: true,
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                _pageNumber = 1;
                _list = [];
                _controller.clear();
                _movieCubit.emit(MovieInitial());
              },
              icon: _controller.text.isNotEmpty
                  ? const Icon(
                      Icons.highlight_remove_outlined,
                      color: Colors.white,
                    )
                  : const SizedBox.shrink(),
            ),
            prefixIcon: IconButton(
              icon: const Icon(Icons.arrow_back, size: 24, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            hintText: 'Search Movies Collection',
            hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70),
          ),
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    setState(() {});
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _pageNumber = 1;
      _list = [];
      _movieCubit.searchMovieEvent(text);
    });
  }

  _listOfMovies() {
    return BlocBuilder<MovieCubit, MovieState>(
      bloc: _movieCubit,
      builder: (context, state) {
        if (state is MovieInitial) {
          return const SizedBox.shrink();
        } else if (state is MovieLoading) {
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
                _movieCubit.searchMovieEvent(_controller.text, _pageNumber);
              }
            },
            onBuildItem: (context, index) => _buildItem(index),
            onReloadItems: () {
              _pageNumber = 1;
              if (_list.isNotEmpty) {
                _list.removeRange(0, _list.length);
              }
              _movieCubit.searchMovieEvent(_controller.text);
            },
            onRetryLoadNextPage: (isRetryingNextPage) {
              _isRetryingNextPage = isRetryingNextPage;
              _movieCubit.searchMovieEvent(_controller.text, _pageNumber);
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
                    errorWidget: (context, url, error) => const Icon(Icons.error),
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
                              children:
                                  List.generate(_list[index].genres.length, (i) {
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
                style: TextStyle(color: Colors.white),
              ),
            ),
            const CircularProgressIndicator(color: Colors.red),
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
              _movieCubit.searchMovieEvent(_controller.text);
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
