import 'package:dartz/dartz.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/src/domain/entities/movie.dart';
import 'package:moviescollection/src/domain/entities/pagination.dart';
import 'package:moviescollection/src/domain/entities/post_movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, Pagination>> getMovies(
      [int pageNumber = 1]);

  Future<Either<Failure, Movie>> getMovieInfo(int movieId);

  Future<Either<Failure, PostMovie>> addMovie(PostMovie postMovie);

  Future<Either<Failure, Pagination>> searchMovie(String movieName,
      [int pageNumber = 1]);

  Future<Either<Failure, Pagination>> getMoviesByGenreId(
      int genreId,
      [int pageNumber = 1]);
}
