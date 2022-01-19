import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/usecases/usecase.dart';
import 'package:moviescollection/src/domain/entities/auth.dart';
import 'package:moviescollection/src/domain/repositories/auth_repository.dart';

class UserLogin implements UseCase<Auth, UserLoginParams> {
  final AuthRepository repository;

  UserLogin({required this.repository});

  @override
  Future<Either<Failure, Auth>> call(UserLoginParams params) async {
    return await repository.login(
        params.userName, params.password, params.grantType);
  }
}

class UserLoginParams extends Equatable {
  final String userName;
  final String password;
  final String grantType;

  const UserLoginParams({
    required this.userName,
    required this.password,
    required this.grantType,
  });

  @override
  List<Object> get props => [userName, password, grantType];
}
