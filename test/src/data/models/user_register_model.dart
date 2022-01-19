import 'package:flutter_test/flutter_test.dart';
import 'package:moviescollection/src/data/models/user_register_model.dart';
import 'package:moviescollection/src/domain/entities/user_register.dart';

void main() {
  const tUserRegisterModel = UserRegisterModel(
      email: 'email@yahoo.com', password: '123456', userName: 'userName');

  test(
    'should be a subclass of Auth entity',
    () async {
      // assert
      expect(tUserRegisterModel, isA<UserRegister>());
    },
  );

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tUserRegisterModel.toJson();
        // assert
        final expectedMap = {
          'email': 'email@yahoo.com',
          'password': '123456',
          'name': 'userName',
        };
        expect(result, expectedMap);
      },
    );
  });
}
