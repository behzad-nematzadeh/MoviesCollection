import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/core/enums/http_error.dart';
import 'package:moviescollection/core/error/exceptions.dart';
import 'package:moviescollection/src/data/datasources/remote/api_provider.dart';
import 'package:moviescollection/src/data/datasources/remote/auth_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:moviescollection/src/data/models/auth_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'auth_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockClient mockClient;
  late ApiProvider apiProvider;

  setUp(() {
    mockClient = MockClient();
    apiProvider = ApiProvider(httpClient: mockClient);
    dataSource = AuthRemoteDataSourceImpl(apiProvider: apiProvider);
  });

  void setUpMockHttpClientGetSuccess200() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('auth.json'), 200));
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

  final tAuth = AuthModel.fromJson(json.decode(fixture('auth.json')));

  group('login', () {
    const userName = 'demo';
    const password = '123';
    const grantType = 'user';
    final body = <String, dynamic>{
      "username": userName,
      "password": password,
      "grant_type": grantType
    };

    test('should return AuthModel when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientPostSuccess200(body: body, jsonResult: 'auth.json');
      // act
      final result = await dataSource.login(userName, password, grantType);
      // assert
      expect(result, equals(tAuth));
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpPostClientFailure(body, HttpError.forbidden.value);
        // act
        final call = dataSource.login;
        // assert
        expect(() => call(userName, password, grantType),
            throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  group('refresh token', () {
    const grantType = 'user';
    const refreshToken = 'user';
    final body = <String, dynamic>{
      "grant_type": grantType,
      "refresh_token": refreshToken,
    };

    test('should return AuthModel when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientPostSuccess200(body: body, jsonResult: 'auth.json');
      // act
      final result = await dataSource.refreshToken(grantType, refreshToken);
      // assert
      expect(result, equals(tAuth));
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpPostClientFailure(body, HttpError.forbidden.value);
        // act
        final call = dataSource.refreshToken;
        // assert
        expect(() => call(grantType, refreshToken),
            throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
