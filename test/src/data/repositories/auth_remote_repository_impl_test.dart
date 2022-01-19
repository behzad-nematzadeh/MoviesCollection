import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/core/enums/http_error.dart';
import 'package:moviescollection/core/error/exceptions.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/network/network_info.dart';
import 'package:moviescollection/src/data/datasources/local/local_data_source.dart';
import 'package:moviescollection/src/data/datasources/remote/auth_remote_data_source.dart';
import 'package:moviescollection/src/data/models/auth_model.dart';
import 'package:moviescollection/src/data/repositories/auth_remote_repository_impl.dart';
import 'package:moviescollection/src/domain/entities/auth.dart';

import '../../../fixtures/fixture_reader.dart';
import 'auth_remote_repository_impl_test.mocks.dart';

@GenerateMocks([LocalDataSource, AuthRemoteDataSource, NetworkInfo])
void main() {
  late AuthRemoteRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = AuthRemoteRepositoryImpl(
      localDataSource: mockLocalDataSource,
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

  group('login group', () {
    const userName = 'demo';
    const password = '123';
    const grantType = 'user';

    final tAuthModel = AuthModel.fromJson(json.decode(fixture('auth.json')));
    final Auth tAuth = tAuthModel;

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.login(userName, password, grantType))
              .thenAnswer((_) async => tAuthModel);
          // act
          final result = await repository.login(userName, password, grantType);
          // assert
          verify(mockRemoteDataSource.login(userName, password, grantType));
          expect(result, equals(Right(tAuth)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.login(userName, password, grantType))
              .thenAnswer((_) async => tAuthModel);
          // act
          await repository.login(userName, password, grantType);
          // assert
          verify(mockRemoteDataSource.login(userName, password, grantType));
          verify(mockLocalDataSource.cacheToken(tAuthModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.login(userName, password, grantType))
              .thenThrow(ServerException(
                  code: HttpError.unavailable.value,
                  message: HttpError.unavailable.name));
          // act
          final result = await repository.login(userName, password, grantType);
          // assert
          verify(mockRemoteDataSource.login(userName, password, grantType));
          verifyZeroInteractions(mockLocalDataSource);
          expect(
              result,
              equals(Left(ServerFailure(
                  HttpError.unavailable.value, HttpError.unavailable.name))));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.login(userName, password, grantType))
              .thenThrow((_) async => tAuthModel);
          // act
          final result = await repository.login(userName, password, grantType);
          // assert
          expect(result, equals(Left(NoConnectionFailure())));
        },
      );
    });
  });

  group('refresh token', () {
    const grantType = 'user';
    const refreshToken = 'user';

    final tAuthModel = AuthModel.fromJson(json.decode(fixture('auth.json')));
    final Auth tAuth = tAuthModel;

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.refreshToken(grantType, refreshToken))
              .thenAnswer((_) async => tAuthModel);
          // act
          final result = await repository.refreshToken(grantType, refreshToken);
          // assert
          //verify(mockRemoteDataSource.refreshToken(grantType, refreshToken));
          expect(result, equals(Right(tAuth)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.refreshToken(grantType, refreshToken))
              .thenThrow(ServerException(
                  code: HttpError.unavailable.value,
                  message: HttpError.unavailable.name));
          // act
          final result = await repository.refreshToken(grantType, refreshToken);
          // assert
          verify(mockRemoteDataSource.refreshToken(grantType, refreshToken));
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
          when(mockRemoteDataSource.refreshToken(grantType, refreshToken))
              .thenThrow((_) async => tAuthModel);
          // act
          final result = await repository.refreshToken(grantType, refreshToken);
          // assert
          expect(result, equals(Left(NoConnectionFailure())));
        },
      );
    });
  });
}
