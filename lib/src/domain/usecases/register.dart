import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/usecases/usecase.dart';
import 'package:moviescollection/src/domain/entities/user.dart';
import 'package:moviescollection/src/domain/repositories/user_repository.dart';

class Register implements UseCase<User, RegisterParams> {
  final UserRepository repository;

  Register({required this.repository});

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
        params.userName, params.password, params.email);
  }
}

class RegisterParams extends Equatable {
  final String userName;
  final String password;
  final String email;

  const RegisterParams({
    required this.userName,
    required this.password,
    required this.email,
  });

  @override
  List<Object> get props => [userName, password, email];
}
