import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String createdAt;
  final String updateAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updateAt,
  });

  @override
  List<Object> get props => [id, name, email, createdAt, updateAt];
}
