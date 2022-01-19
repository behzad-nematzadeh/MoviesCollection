import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/core/enums/http_error.dart';
import 'package:moviescollection/core/error/exceptions.dart';
import 'package:moviescollection/src/data/datasources/remote/api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:moviescollection/src/data/datasources/remote/movie_remote_data_source.dart';
import 'package:moviescollection/src/data/models/movie_model.dart';
import 'package:moviescollection/src/data/models/pagination_model.dart';
import 'package:moviescollection/src/data/models/post_movie_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'movie_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MovieRemoteDataSourceImpl dataSource;
  late MockClient mockClient;
  late ApiProvider apiProvider;

  setUp(() {
    mockClient = MockClient();
    apiProvider = ApiProvider(httpClient: mockClient);
    dataSource = MovieRemoteDataSourceImpl(apiProvider: apiProvider);
  });

  void setUpMockHttpClientGetSuccess200({required String jsonResult}) {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture(jsonResult), 200));
  }

  void setUpMockHttpClientPostSuccess200({
    required Object body,
    required String jsonResult,
  }) {
    when(mockClient.post(any,
            headers: anyNamed('headers'), body: utf8.encode(json.encode(body))))
        .thenAnswer((_) async => http.Response(fixture(jsonResult), 200));
  }

  void setUpMockHttpClientGetFailure404() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  void setUpMockHttpClientPostFailure404() {
    when(mockClient.post(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  void setUpMockHttpPostClientFailure(Object body, int errorCode) {
    when(mockClient.post(any,
            headers: anyNamed('headers'), body: utf8.encode(json.encode(body))))
        .thenAnswer(
            (_) async => http.Response('Something went wrong', errorCode));
  }

  final paginationMovies =
      PaginationModel.fromJson(json.decode(fixture('pagination_movie.json')));

  group('get list of movies', () {
    test(
        'should return PaginationModel when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientGetSuccess200(jsonResult: 'pagination_movie.json');
      // act
      final result = await dataSource.getMovies();

      // assert
      expect(result, equals(paginationMovies));
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientGetFailure404();
        // act
        final call = dataSource.getMovies;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('get movie info', () {
    final movie = MovieModel.fromJson(json.decode(fixture('movie.json')));
    test('should return MovieModel when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientGetSuccess200(jsonResult: 'movie.json');
      // act
      final result = await dataSource.getMovieInfo(1);

      // assert
      expect(result, equals(movie));
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientGetFailure404();
        // act
        final call = dataSource.getMovies;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('search in list of movies', () {
    test(
        'should return PaginationModel when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientGetSuccess200(jsonResult: 'pagination_movie.json');
      // act
      final result = await dataSource.searchMovie('movieName', 1);

      // assert
      expect(result, equals(paginationMovies));
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientGetFailure404();
        // act
        final call = dataSource.getMovies;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('get movies by genreId', () {
    test(
        'should return PaginationModel when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientGetSuccess200(jsonResult: 'pagination_movie.json');
      // act
      final result = await dataSource.getMoviesByGenreId(1, 1);

      // assert
      expect(result, equals(paginationMovies));
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientGetFailure404();
        // act
        final call = dataSource.getMovies;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('add movie', () {
    final postMovieModel =
        PostMovieModel.fromJson(json.decode(fixture('post_movie.json')));

    test('should return PostMovieModel when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientPostSuccess200(
        body: postMovieModel.toJson(),
        jsonResult: 'post_movie.json',
      );
      // act
      final result = await dataSource.addMovie(postMovieModel);

      // assert
      expect(result, equals(postMovieModel));
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpPostClientFailure(
          postMovieModel.toJson(),
          HttpError.forbidden.value,
        );
        // act
        final call = dataSource.addMovie;
        // assert
        expect(
          () => call(postMovieModel),
          throwsA(const TypeMatcher<ServerException>()),
        );
      },
    );
  });
}
