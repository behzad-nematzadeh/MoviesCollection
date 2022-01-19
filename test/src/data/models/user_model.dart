import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moviescollection/src/data/models/user_model.dart';
import 'package:moviescollection/src/domain/entities/user.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  const tUserModel = UserModel(
      id: 23,
      name: "Abbas Ov",
      email: "abbas@oveissi.ir",
      createdAt: "2020-10-10 12:12:23",
      updateAt: "2020-10-10 12:12:23");

  test(
    'should be a subclass of Auth entity',
    () async {
      // assert
      expect(tUserModel, isA<User>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('user.json'));
        // act
        final result = UserModel.fromJson(jsonMap);
        // assert
        expect(result, tUserModel);
      },
    );
  });
}
