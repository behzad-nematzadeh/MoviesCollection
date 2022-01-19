import 'package:moviescollection/src/domain/entities/user_register.dart';

class UserRegisterModel extends UserRegister {
  const UserRegisterModel({
    required String email,
    required String password,
    required String userName,
  }) : super(email: email, password: password, userName: userName);

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'name': userName,
      };
}
