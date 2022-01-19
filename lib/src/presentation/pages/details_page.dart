import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviescollection/src/domain/entities/movie.dart';
import 'package:moviescollection/src/presentation/blocs/movie/movie_cubit.dart';
import 'package:moviescollection/src/presentation/widgets/star_rating.dart';

import '../../../injection.dart';

class DetailsPage extends StatefulWidget {
  final int movieId;

  const DetailsPage({Key? key, required this.movieId}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late MovieCubit _movieCubit;
  late Movie _movie;

  int activePage = 0;

  @override
  void initState() {
    _movieCubit = sl<MovieCubit>();
    _movieCubit.getMovieInfoEvent(widget.movieId);

    super.initState();
  }

  @override
  void dispose() {
    _movieCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder(
            bloc: _movieCubit,
            builder: (context, state) {
              if (state is MovieInitial) {
                return const Center();
              } else if (state is MovieLoading) {
                return _loadingFirstPageIndicator();
              } else if (state is MovieLoaded) {
                _movie = state.response as Movie;
              } else if (state is MovieError) {
                return _retrying(state.message);
              } else if (state is MovieNoConnection) {
                return _retrying('Check Network Connection');
              }

              return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            pinned: true,
                            expandedHeight: 260.0,
                            backgroundColor: Colors.black87,
                            flexibleSpace: FlexibleSpaceBar(
                              title: Text(_movie.title, textScaleFactor: 1),
                              background: PageView.builder(
                                itemCount: _movie.images.length,
                                pageSnapping: true,
                                onPageChanged: (page) {
                                  setState(() {
                                    activePage = page;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  bool active = index == activePage;
                                  return slider(_movie.images, index, active);
                                },
                              ),
                              stretchModes: [StretchMode.zoomBackground],
                            ),
                          ),
                        ];
                      },
                  body: SingleChildScrollView(
                    child: Container(
                      color: Colors.black87,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: indicators(_movie.images.length, activePage),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    StarRating(
                                      rating: double.parse(_movie.imdbRating!) / 2,
                                      onRatingChanged: (rating) => setState(() => Text(
                                          rating.toString(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.white, fontSize: 16))),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('${_movie.imdbRating!.toString()} / 10',
                                        textAlign: TextAlign.start,
                                        style:
                                        TextStyle(color: Colors.white, fontSize: 16))
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(Icons.timer, color: Colors.white70),
                                    const SizedBox(height: 4),
                                    Text(
                                      _movie.runtime!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  children: [
                                    Icon(Icons.new_releases, color: Colors.white70),
                                    const SizedBox(height: 4),
                                    Text(
                                      _movie.year!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildMoreInfo(),
                        ],
                      ),
                    ),
                  ));
            }),
      ),
    );
  }

  _buildBody() {
    return Container(
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImages(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indicators(_movie.images.length, activePage),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_movie.title,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      Row(
                        children: [
                          StarRating(
                            rating: double.parse(_movie.imdbRating!) / 2,
                            onRatingChanged: (rating) => setState(() => Text(
                                rating.toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16))),
                          ),
                          Text(_movie.imdbRating!.toString(),
                              textAlign: TextAlign.start,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16))
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Icon(Icons.timer, color: Colors.white70),
                    const SizedBox(height: 4),
                    Text(
                      _movie.runtime!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    Icon(Icons.new_releases, color: Colors.white70),
                    const SizedBox(height: 4),
                    Text(
                      _movie.year!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildGenres(),
          const SizedBox(height: 16),
          _buildMoreInfo()
        ],
      ),
    );
  }

  _buildImages() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: (MediaQuery.of(context).size.width * 3) / 4,
      child: Stack(
        children: <Widget>[
          PageView.builder(
            itemCount: _movie.images.length,
            pageSnapping: true,
            onPageChanged: (page) {
              setState(() {
                activePage = page;
              });
            },
            itemBuilder: (context, index) {
              bool active = index == activePage;
              return slider(_movie.images, index, active);
            },
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child:
                  Icon(Icons.arrow_back_ios, color: Colors.white70, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(
      imagesLength,
      (index) {
        return Container(
          margin: const EdgeInsets.all(4),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
              color: currentIndex == index ? Colors.red : Colors.white38,
              shape: BoxShape.circle),
        );
      },
    );
  }

  AnimatedContainer slider(images, pagePosition, active) {
    double margin = active ? 0 : 16;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(margin),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        imageUrl: images[pagePosition],
        placeholder: (context, url) => const Icon(Icons.movie),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  _buildGenres() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
          itemCount: _movie.genres.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints: const BoxConstraints(minWidth: 40),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(32.0)),
                child: Text(
                  _movie.genres[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            );
          }),
    );
  }

  Widget _buildMoreInfo() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Storyline',
              textAlign: TextAlign.justify,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 8),
          Text(_movie.plot!,
              textAlign: TextAlign.justify,
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 32),
          Text('Director',
              textAlign: TextAlign.justify,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 8),
          Text(_movie.director!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 32),
          Text('Casts',
              textAlign: TextAlign.justify,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 8),
          Text(_movie.actors!,
              textAlign: TextAlign.justify,
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 32),
          Text('Writer',
              textAlign: TextAlign.justify,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 8),
          Text(_movie.writer!,
              textAlign: TextAlign.justify,
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 32),
          Text('Awards',
              textAlign: TextAlign.justify,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 8),
          Text(_movie.awards!,
              textAlign: TextAlign.justify,
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          SizedBox(height: 16)
        ],
      ),
    );
  }

  Widget _loadingFirstPageIndicator() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
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
    );
  }

  _retrying(String errMessage) {
    return Center(
      child: SizedBox(
        height: 60,
        child: InkWell(
          onTap: () => _movieCubit.getMovieInfoEvent(widget.movieId),
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
    );
  }
}
