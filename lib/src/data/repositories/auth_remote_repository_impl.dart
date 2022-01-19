import 'package:dartz/dartz.dart';
import 'package:moviescollection/core/error/exceptions.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/network/network_info.dart';
import 'package:moviescollection/src/data/datasources/local/local_data_source.dart';
import 'package:moviescollection/src/data/datasources/remote/auth_remote_data_source.dart';
import 'package:moviescollection/src/domain/entities/auth.dart';
import 'package:moviescollection/src/domain/repositories/auth_repository.dart';

class AuthRemoteRepositoryImpl implements AuthRepository {
  final LocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRemoteRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Auth>> login(
      String userName, String password, String grantType) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await remoteDataSource.login(userName, password, grantType);
        localDataSource.cacheToken(response);
        return Right(response);
      } on ServerException catch (exp) {
        return Left(ServerFailure(exp.code, exp.message));
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Auth>> refreshToken(
      String grantType, String refreshToken) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await remoteDataSource.refreshToken(grantType, refreshToken);
        return Right(response);
      } on ServerException catch (exp) {
        return Left(ServerFailure(exp.code, exp.message));
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      bool isAuthenticated = await localDataSource.isAuthenticated();
      return Right(isAuthenticated);
    } on CacheException catch (exp) {
      return Left(CacheFailure());
    }
  }
}
