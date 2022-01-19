import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moviescollection/src/data/models/auth_model.dart';
import 'package:moviescollection/src/domain/entities/auth.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const tAuthModel = AuthModel(
      tokenType: "Bearer",
      expiresIn: 16537295,
      accessToken: "NJhsHG6TFC5kdTEM34cMzAxFtfs34x...",
      refreshToken: "eNUSyyhn3kmIJ64jnUH56DMsfNUhN4...");

  test(
    'should be a subclass of Auth entity',
    () async {
      // assert
      expect(tAuthModel, isA<Auth>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('auth.json'));
        // act
        final result = AuthModel.fromJson(jsonMap);
        // assert
        expect(result, tAuthModel);
      },
    );
  });
}
