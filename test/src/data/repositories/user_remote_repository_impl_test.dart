import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/core/enums/http_error.dart';
import 'package:moviescollection/core/error/exceptions.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/network/network_info.dart';
import 'package:moviescollection/src/data/datasources/remote/user_remote_data_source.dart';
import 'package:moviescollection/src/data/models/user_model.dart';
import 'package:moviescollection/src/data/repositories/user_remote_repository_impl.dart';

import '../../../fixtures/fixture_reader.dart';
import 'user_remote_repository_impl_test.mocks.dart';

@GenerateMocks([UserRemoteDataSource, NetworkInfo])
void main() {
  late UserRemoteRepositoryImpl repository;
  late MockUserRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = UserRemoteRepositoryImpl(
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

  final tUserModel = UserModel.fromJson(json.decode(fixture('user.json')));
  final tUser = tUserModel;

  group('get user info group', () {
    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getUserInfo())
              .thenAnswer((_) async => tUserModel);
          // act
          final result = await repository.getUserInfo();
          // assert
          verify(mockRemoteDataSource.getUserInfo());
          expect(result, equals(Right(tUser)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getUserInfo()).thenThrow(
            ServerException(
                code: HttpError.unavailable.value,
                message: HttpError.unavailable.name),
          );
          // act
          final result = await repository.getUserInfo();
          // assert
          verify(mockRemoteDataSource.getUserInfo());
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
          when(mockRemoteDataSource.getUserInfo())
              .thenThrow((_) async => tUserModel);
          // act
          final result = await repository.getUserInfo();
          // assert
          expect(result, equals(Left(NoConnectionFailure())));
        },
      );
    });
  });

  const userName = 'demo';
  const password = '123';
  const email = 'email@yahoo.com';

  group('register group', () {
    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.register(userName, password, email))
              .thenAnswer((_) async => tUserModel);
          // act
          final result = await repository.register(userName, password, email);
          // assert
          verify(mockRemoteDataSource.register(userName, password, email));
          expect(result, equals(Right(tUser)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.register(userName, password, email))
              .thenThrow(
            ServerException(
                code: HttpError.unavailable.value,
                message: HttpError.unavailable.name),
          );
          // act
          final result = await repository.register(userName, password, email);
          // assert
          verify(mockRemoteDataSource.register(userName, password, email));
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
          when(mockRemoteDataSource.register(userName, password, email))
              .thenThrow((_) async => tUserModel);
          // act
          final result = await repository.register(userName, password, email);
          // assert
          expect(result, equals(Left(NoConnectionFailure())));
        },
      );
    });
  });
}
