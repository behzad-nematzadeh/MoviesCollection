import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/core/enums/http_error.dart';
import 'package:moviescollection/core/error/exceptions.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/network/network_info.dart';
import 'package:moviescollection/src/data/datasources/remote/movie_remote_data_source.dart';
import 'package:moviescollection/src/data/models/movie_model.dart';
import 'package:moviescollection/src/data/models/pagination_model.dart';
import 'package:moviescollection/src/data/models/post_movie_model.dart';
import 'package:moviescollection/src/data/repositories/movie_remote_repository_impl.dart';
import 'package:moviescollection/src/domain/entities/movie.dart';
import 'package:moviescollection/src/domain/entities/pagination.dart';
import 'package:moviescollection/src/domain/entities/post_movie.dart';

import '../../../fixtures/fixture_reader.dart';
import 'movie_remote_repository_impl_test.mocks.dart';

@GenerateMocks([MovieRemoteDataSource, NetworkInfo])
void main() {
  late MovieRemoteRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = MovieRemoteRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  const tPageNumber = 1;
  final tPaginationModel =
      PaginationModel.fromJson(json.decode(fixture('pagination_movie.json')));
  final Pagination tPagination = tPaginationModel;

  group('get list of movies', () {
    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getMovies(any))
              .thenAnswer((_) async => tPaginationModel);
          // act
          final result = await repository.getMovies(tPageNumber);
          // assert
          expect(result, equals(Right(tPagination)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getMovies(tPageNumber)).thenThrow(
              ServerException(
                  code: HttpError.unavailable.value,
                  message: HttpError.unavailable.name));
          // act
          final result = await repository.getMovies(tPageNumber);
          // assert
          verify(mockRemoteDataSource.getMovies(tPageNumber));
          expect(
              result,
              equals(Left(
                ServerFailure(
                    HttpError.unavailable.value, HttpError.unavailable.name),
              )));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getMovies(tPageNumber))
              .thenThrow((_) async => tPaginationModel);
          // act
          final result = await repository.getMovies(tPageNumber);
          // assert
          expect(result, equals(Left(NoConnectionFailure())));
        },
      );
    });
  });

  const tMovieId = 1;
  final tMovieModel = MovieModel.fromJson(json.decode(fixture('movie.json')));
  final Movie tMovie = tMovieModel;

  group('get movie info', () {
    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getMovieInfo(any))
              .thenAnswer((_) async => tMovieModel);
          // act
          final result = await repository.getMovieInfo(tMovieId);
          // assert
          expect(result, equals(Right(tMovie)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getMovieInfo(any)).thenThrow(
              ServerException(
                  code: HttpError.unavailable.value,
                  message: HttpError.unavailable.name));
          // act
          final result = await repository.getMovieInfo(tMovieId);
          // assert
          verify(mockRemoteDataSource.getMovieInfo(tMovieId));
          expect(
              result,
              equals(Left(
                ServerFailure(
                    HttpError.unavailable.value, HttpError.unavailable.name),
              )));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getMovieInfo(any))
              .thenThrow((_) async => tMovieModel);
          // act
          final result = await repository.getMovieInfo(tMovieId);
          // assert
          expect(result, equals(Left(NoConnectionFailure())));
        },
      );
    });
  });

  final tPostMovieModel =
      PostMovieModel.fromJson(json.decode(fixture('post_movie.json')));
  final PostMovie tPostMovie = tPostMovieModel;

  group('add movie', () {
    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.addMovie(any))
              .thenAnswer((_) async => tPostMovieModel);
          // act
          final result = await repository.addMovie(tPostMovie);
          // assert
          expect(result, equals(Right(tPostMovie)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.addMovie(any)).thenThrow(ServerException(
              code: HttpError.unavailable.value,
              message: HttpError.unavailable.name));
          // act
          final result = await repository.addMovie(tPostMovie);
          // assert
          verify(mockRemoteDataSource.addMovie(tPostMovieModel));
          expect(
              result,
              equals(Left(
                ServerFailure(
                    HttpError.unavailable.value, HttpError.unavailable.name),
              )));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.addMovie(any))
              .thenThrow((_) async => tPostMovieModel);
          // act
          final result = await repository.addMovie(tPostMovie);
          // assert
          expect(result, equals(Left(NoConnectionFailure())));
        },
      );
    });
  });

  group('search in movies', () {
    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.searchMovie(any))
              .thenAnswer((_) async => tPaginationModel);
          // act
          final result = await repository.searchMovie('movieName', 1);
          // assert
          expect(result, equals(Right(tPagination)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.searchMovie(any)).thenThrow(ServerException(
              code: HttpError.unavailable.value,
              message: HttpError.unavailable.name));
          // act
          final result = await repository.searchMovie('movieName', 1);
          // assert
          verify(mockRemoteDataSource.searchMovie('movieName', 1));
          expect(
              result,
              equals(Left(
                ServerFailure(
                    HttpError.unavailable.value, HttpError.unavailable.name),
              )));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.searchMovie(any))
              .thenThrow((_) async => tPaginationModel);
          // act
          final result = await repository.searchMovie('movieName', 1);
          // assert
          expect(result, equals(Left(NoConnectionFailure())));
        },
      );
    });
  });

  group('get movies by genre id', () {
    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getMoviesByGenreId(any))
              .thenAnswer((_) async => tPaginationModel);
          // act
          final result = await repository.getMoviesByGenreId(1, 1);
          // assert
          expect(result, equals(Right(tPagination)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getMoviesByGenreId(any)).thenThrow(
            ServerException(
                code: HttpError.unavailable.value,
                message: HttpError.unavailable.name),
          );
          // act
          final result = await repository.getMoviesByGenreId(1, 1);
          // assert
          verify(mockRemoteDataSource.getMoviesByGenreId(1, 1));
          expect(
              result,
              equals(Left(
                ServerFailure(
                    HttpError.unavailable.value, HttpError.unavailable.name),
              )));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getMoviesByGenreId(any))
              .thenThrow((_) async => tPaginationModel);
          // act
          final result = await repository.getMoviesByGenreId(1, 1);
          // assert
          expect(result, equals(Left(NoConnectionFailure())));
        },
      );
    });
  });
}
