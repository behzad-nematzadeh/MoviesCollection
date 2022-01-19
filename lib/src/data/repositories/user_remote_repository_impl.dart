import 'package:dartz/dartz.dart';
import 'package:moviescollection/core/error/exceptions.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/network/network_info.dart';
import 'package:moviescollection/src/data/datasources/remote/user_remote_data_source.dart';
import 'package:moviescollection/src/domain/entities/user.dart';
import 'package:moviescollection/src/domain/repositories/user_repository.dart';

class UserRemoteRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRemoteRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> getUserInfo() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getUserInfo();
        return Right(response);
      } on ServerException catch (exp) {
        return Left(ServerFailure(exp.code, exp.message));
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, User>> register(
    String userName,
    String password,
    String email,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await remoteDataSource.register(userName, password, email);
        return Right(response);
      } on ServerException catch (exp) {
        return Left(ServerFailure(exp.code, exp.message));
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }
}
