import 'package:dartz/dartz.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/src/domain/entities/auth.dart';

abstract class AuthRepository {
  Future<Either<Failure, Auth>> login(
      String userName, String password, String grantType);

  Future<Either<Failure, Auth>> refreshToken(
      String grantType, String refreshToken);

  Future<Either<Failure, bool>> isAuthenticated();
}
