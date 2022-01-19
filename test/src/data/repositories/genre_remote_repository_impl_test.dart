import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/core/enums/http_error.dart';
import 'package:moviescollection/core/error/exceptions.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/network/network_info.dart';
import 'package:moviescollection/src/data/datasources/remote/genre_remote_data_source.dart';
import 'package:moviescollection/src/data/models/genre_model.dart';
import 'package:moviescollection/src/data/repositories/genre_remote_repository_impl.dart';

import '../../../fixtures/fixture_reader.dart';
import 'genre_remote_repository_impl_test.mocks.dart';

@GenerateMocks([GenreRemoteDataSource, NetworkInfo])
void main() {
  late GenreRemoteRepositoryImpl repository;
  late MockGenreRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockGenreRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = GenreRemoteRepositoryImpl(
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

  final List<GenreModel> tGenreModelList = json
      .decode(fixture('genre_list.json'))
      .map<GenreModel>((data) => GenreModel.fromJson(data))
      .toList();
  final tGenreList = tGenreModelList;

  runTestsOnline(() {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        // arrange
        when(mockRemoteDataSource.getGenres())
            .thenAnswer((_) async => tGenreModelList);
        // act
        final result = await repository.getGenres();
        // assert
        verify(mockRemoteDataSource.getGenres());
        expect(result, equals(Right(tGenreList)));
      },
    );

    test(
      'should return server failure when the call to remote data source is unsuccessful',
      () async {
        // arrange
        when(mockRemoteDataSource.getGenres()).thenThrow(
          ServerException(
              code: HttpError.unavailable.value,
              message: HttpError.unavailable.name),
        );
        // act
        final result = await repository.getGenres();
        // assert
        verify(mockRemoteDataSource.getGenres());
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
        when(mockRemoteDataSource.getGenres())
            .thenThrow((_) async => tGenreModelList);
        // act
        final result = await repository.getGenres();
        // assert
        expect(result, equals(Left(NoConnectionFailure())));
      },
    );
  });
}
