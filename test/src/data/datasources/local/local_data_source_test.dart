import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/core/error/exceptions.dart';
import 'package:moviescollection/core/utils/constants.dart';
import 'package:moviescollection/src/data/datasources/local/local_data_source.dart';
import 'package:moviescollection/src/data/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late LocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group(
    'user authentication',
    () {
      test('should return true if user authentication', () async {
        //arrange
        when(mockSharedPreferences.getBool(any)).thenReturn(true);
        //act
        final result = await dataSource.isAuthenticated();
        //assert
        verify(mockSharedPreferences.getBool(Constant.authenticationKey));
        expect(result, true);
      });

      test('should return a Cache Failure when user not authenticated',
          () async {
        //arrange
        when(mockSharedPreferences.getBool(any)).thenThrow(CacheException());
        //act
        final call = dataSource.isAuthenticated;
        //assert
        expect(() => call(), throwsA(isA<CacheException>()));
      });
    },
  );

  final tAuth = AuthModel.fromJson(json.decode(fixture('auth.json')));

  group(
    'getLastToken',
    () {
      test('should return last stored token (cached)', () async {
        //arrange
        when(mockSharedPreferences.getString(any))
            .thenReturn(fixture('auth.json'));
        //act
        final result = await dataSource.getToken();
        //assert
        verify(mockSharedPreferences.getString(Constant.tokenKey));
        expect(result, tAuth);
      });

      test('should return a Cache Failure when there is no stored token',
          () async {
        //arrange
        when(mockSharedPreferences.getString(any)).thenThrow(CacheException());
        //act
        final call = dataSource.getToken;
        //assert
        expect(() => call(), throwsA(isA<CacheException>()));
      });
    },
  );

  group(
    'cache token',
    () {
      const tAuthModel = AuthModel(
          tokenType: "Bearer",
          expiresIn: 16537295,
          accessToken: "NJhsHG6TFC5kdTEM34cMzAxFtfs34x...",
          refreshToken: "eNUSyyhn3kmIJ64jnUH56DMsfNUhN4...");

      test('should store the token', () async {
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);
        //act
        dataSource.cacheToken(tAuthModel);
        //assert
        final expectedJsonString = json.encode(tAuthModel.toJson());
        verify(mockSharedPreferences.setString(
            Constant.tokenKey, expectedJsonString));
      });
    },
  );
}
