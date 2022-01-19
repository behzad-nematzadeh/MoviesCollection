import 'package:dartz/dartz.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/usecases/usecase.dart';
import 'package:moviescollection/src/domain/entities/user.dart';
import 'package:moviescollection/src/domain/repositories/user_repository.dart';

class GetUserInfo implements UseCase<User, NoParams> {
  final UserRepository repository;

  GetUserInfo({required this.repository});

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getUserInfo();
  }
}
