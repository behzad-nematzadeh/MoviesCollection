// Mocks generated by Mockito 5.0.16 from annotations
// in moviescollection/test/src/domain/usecases/get_movies_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:moviescollection/core/error/failures.dart' as _i5;
import 'package:moviescollection/src/domain/entities/movie.dart' as _i7;
import 'package:moviescollection/src/domain/entities/pagination.dart' as _i6;
import 'package:moviescollection/src/domain/entities/post_movie.dart' as _i8;
import 'package:moviescollection/src/domain/repositories/movie_repository.dart'
    as _i3;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeEither_0<L, R> extends _i1.Fake implements _i2.Either<L, R> {}

/// A class which mocks [MovieRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockMovieRepository extends _i1.Mock implements _i3.MovieRepository {
  MockMovieRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Pagination>> getMovies(
          [int? pageNumber = 1]) =>
      (super.noSuchMethod(Invocation.method(#getMovies, [pageNumber]),
          returnValue: Future<_i2.Either<_i5.Failure, _i6.Pagination>>.value(
              _FakeEither_0<_i5.Failure, _i6.Pagination>())) as _i4
          .Future<_i2.Either<_i5.Failure, _i6.Pagination>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i7.Movie>> getMovieInfo(int? movieId) =>
      (super.noSuchMethod(Invocation.method(#getMovieInfo, [movieId]),
              returnValue: Future<_i2.Either<_i5.Failure, _i7.Movie>>.value(
                  _FakeEither_0<_i5.Failure, _i7.Movie>()))
          as _i4.Future<_i2.Either<_i5.Failure, _i7.Movie>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i8.PostMovie>> addMovie(
          _i8.PostMovie? postMovie) =>
      (super.noSuchMethod(Invocation.method(#addMovie, [postMovie]),
              returnValue: Future<_i2.Either<_i5.Failure, _i8.PostMovie>>.value(
                  _FakeEither_0<_i5.Failure, _i8.PostMovie>()))
          as _i4.Future<_i2.Either<_i5.Failure, _i8.PostMovie>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Pagination>> searchMovie(
          String? movieName,
          [int? pageNumber = 1]) =>
      (super.noSuchMethod(
          Invocation.method(#searchMovie, [movieName, pageNumber]),
          returnValue: Future<_i2.Either<_i5.Failure, _i6.Pagination>>.value(
              _FakeEither_0<_i5.Failure, _i6.Pagination>())) as _i4
          .Future<_i2.Either<_i5.Failure, _i6.Pagination>>);
  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.Pagination>> getMoviesByGenreId(
          int? genreId,
          [int? pageNumber = 1]) =>
      (super.noSuchMethod(
          Invocation.method(#getMoviesByGenreId, [genreId, pageNumber]),
          returnValue: Future<_i2.Either<_i5.Failure, _i6.Pagination>>.value(
              _FakeEither_0<_i5.Failure, _i6.Pagination>())) as _i4
          .Future<_i2.Either<_i5.Failure, _i6.Pagination>>);
  @override
  String toString() => super.toString();
}
