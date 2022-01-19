import 'package:moviescollection/src/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required int id,
    required String name,
    required String email,
    required String createdAt,
    required String updateAt,
  }) : super(
          id: id,
          name: name,
          email: email,
          createdAt: createdAt,
          updateAt: updateAt,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email'] as String,
        createdAt: json['created_at'] as String,
        updateAt: json['updated_at'] as String,
      );
}
