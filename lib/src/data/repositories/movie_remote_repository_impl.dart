import 'package:dartz/dartz.dart';
import 'package:moviescollection/core/error/exceptions.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/network/network_info.dart';
import 'package:moviescollection/src/data/datasources/remote/movie_remote_data_source.dart';
import 'package:moviescollection/src/data/models/post_movie_model.dart';
import 'package:moviescollection/src/domain/entities/movie.dart';
import 'package:moviescollection/src/domain/entities/pagination.dart';
import 'package:moviescollection/src/domain/entities/post_movie.dart';
import 'package:moviescollection/src/domain/repositories/movie_repository.dart';

class MovieRemoteRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MovieRemoteRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PostMovie>> addMovie(PostMovie postMovie) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await remoteDataSource.addMovie(postMovie as PostMovieModel);
        return Right(response);
      } on ServerException catch (exp) {
        return Left(ServerFailure(exp.code, exp.message));
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieInfo(int movieId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getMovieInfo(movieId);
        return Right(response);
      } on ServerException catch (exp) {
        return Left(ServerFailure(exp.code, exp.message));
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Pagination>> getMovies(
      [int pageNumber = 1]) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getMovies(pageNumber);
        return Right(response);
      } on ServerException catch (exp) {
        return Left(ServerFailure(exp.code, exp.message));
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Pagination>> searchMovie(String movieName,
      [int pageNumber = 1]) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await remoteDataSource.searchMovie(movieName, pageNumber);
        return Right(response);
      } on ServerException catch (exp) {
        return Left(ServerFailure(exp.code, exp.message));
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Pagination>> getMoviesByGenreId(
      int genreId,
      [int pageNumber = 1]) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
        await remoteDataSource.getMoviesByGenreId(genreId, pageNumber);
        return Right(response);
      } on ServerException catch (exp) {
        return Left(ServerFailure(exp.code, exp.message));
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }
}
