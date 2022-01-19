import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/core/enums/http_error.dart';
import 'package:moviescollection/core/error/exceptions.dart';
import 'package:moviescollection/src/data/datasources/remote/api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:moviescollection/src/data/datasources/remote/user_remote_data_source.dart';
import 'package:moviescollection/src/data/models/user_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'user_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late UserRemoteDataSourceImpl dataSource;
  late MockClient mockClient;
  late ApiProvider apiProvider;

  setUp(() {
    mockClient = MockClient();
    apiProvider = ApiProvider(httpClient: mockClient);
    dataSource = UserRemoteDataSourceImpl(apiProvider: apiProvider);
  });

  void setUpMockHttpClientPostSuccess200({
    required Object? body,
    required String jsonResult,
  }) {
    when(mockClient.post(any,
            headers: anyNamed('headers'), body: utf8.encode(json.encode(body))))
        .thenAnswer((_) async => http.Response(fixture(jsonResult), 200));
  }

  void setUpMockHttpPostClientFailure(Object? body, int errorCode) {
    when(mockClient.post(any,
            headers: anyNamed('headers'), body: utf8.encode(json.encode(body))))
        .thenAnswer(
            (_) async => http.Response('Something went wrong', errorCode));
  }

  final userModel = UserModel.fromJson(json.decode(fixture('user.json')));

  group('user info', () {
    test('should return UserModel when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientPostSuccess200(body: null, jsonResult: 'user.json');
      // act
      final result = await dataSource.getUserInfo();

      // assert
      expect(result, equals(userModel));
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpPostClientFailure(null, HttpError.forbidden.value);
        // act
        final call = dataSource.getUserInfo;
        // assert
        expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });

  const userName = 'demo';
  const password = '123';
  const email = 'email@yahoo.com';
  final body = <String, dynamic>{
    "name": userName,
    "password": password,
    "email": email
  };

  group('User registration', () {
    test('should return UserModel when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientPostSuccess200(body: body, jsonResult: 'user.json');
      // act
      final result = await dataSource.register(userName, password, email);

      // assert
      expect(result, equals(userModel));
    });

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpPostClientFailure(body, HttpError.forbidden.value);
        // act
        final call = dataSource.register;
        // assert
        expect(() => call(userName, password, email),
            throwsA(const TypeMatcher<ServerException>()));
      },
    );
  });
}
