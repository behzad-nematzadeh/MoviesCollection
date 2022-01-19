import 'package:dartz/dartz.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/src/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> register(
      String userName, String password, String email);

  Future<Either<Failure, User>> getUserInfo();
}
