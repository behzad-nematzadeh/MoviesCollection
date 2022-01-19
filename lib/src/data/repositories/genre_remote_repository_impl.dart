import 'package:dartz/dartz.dart';
import 'package:moviescollection/core/error/exceptions.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/network/network_info.dart';
import 'package:moviescollection/src/data/datasources/remote/genre_remote_data_source.dart';
import 'package:moviescollection/src/domain/entities/genre.dart';
import 'package:moviescollection/src/domain/repositories/genre_repository.dart';

class GenreRemoteRepositoryImpl implements GenreRepository {
  final GenreRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  GenreRemoteRepositoryImpl(
      {required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<Genre>>> getGenres() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getGenres();
        return Right(response);
      } on ServerException catch (exp) {
        return Left(ServerFailure(exp.code, exp.message));
      }
    } else {
      return Left(NoConnectionFailure());
    }
  }
}
