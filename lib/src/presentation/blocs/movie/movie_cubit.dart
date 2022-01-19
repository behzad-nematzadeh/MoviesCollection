import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/src/domain/entities/post_movie.dart';
import 'package:moviescollection/src/domain/usecases/add_movie.dart';
import 'package:moviescollection/src/domain/usecases/get_movie_info.dart';
import 'package:moviescollection/src/domain/usecases/get_movies.dart';
import 'package:moviescollection/src/domain/usecases/get_movies_by_genre_id.dart';
import 'package:moviescollection/src/domain/usecases/search_movies.dart';

part 'movie_state.dart';

class MovieCubit extends Cubit<MovieState> {
  final GetMovieInfo getMovieInfo;
  final GetMovies getMovies;
  final GetMoviesByGenreId getMoviesByGenreId;
  final AddMovie addMovie;
  final SearchMovies searchMovies;

  MovieCubit({
    required this.getMovieInfo,
    required this.getMovies,
    required this.getMoviesByGenreId,
    required this.addMovie,
    required this.searchMovies,
  }) : super(MovieInitial());

  getMovieInfoEvent(int movieId) async {
    emit(MovieLoading());
    final request =
        await getMovieInfo.call(GetMovieInfoParams(movieId: movieId));
    emitFunction(request);
  }

  getMoviesEvent([int pageNumber = 1]) async {
    emit(MovieLoading());
    final request = await getMovies.call(GetMoviesParams(pageNumber));
    emitFunction(request);
  }

  getMoviesByGenreIdEvent(int genreId, [int pageNumber = 1]) async {
    emit(MovieLoading());
    final request = await getMoviesByGenreId.call(
        GetMoviesByGenreIdParams(genreId: genreId, pageNumber: pageNumber));
    emitFunction(request);
  }

  addMovieEvent(PostMovie postMovie) async {
    emit(MovieLoading());
    final request = await addMovie.call(AddMovieParams(postMovie: postMovie));
    emitFunction(request);
  }

  searchMovieEvent(String movieName, [int pageNumber = 1]) async {
    emit(MovieLoading());
    final request = await searchMovies.call(SearchMoviesParams(
      movieName: movieName,
      pageNumber: pageNumber,
    ));
    emitFunction(request);
  }

  void emitFunction(Either<Failure, dynamic> request) {
    request.fold((failure) {
      if (failure is NoConnectionFailure) {
        emit(MovieNoConnection());
      } else {
        ServerFailure err = failure as ServerFailure;
        emit(MovieError(message: err.message!));
      }
    }, (response) => emit(MovieLoaded(response: response)));
  }
}
