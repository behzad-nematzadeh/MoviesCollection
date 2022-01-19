import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/usecases/usecase.dart';
import 'package:moviescollection/src/domain/entities/pagination.dart';
import 'package:moviescollection/src/domain/repositories/movie_repository.dart';

class GetMovies implements UseCase<Pagination, GetMoviesParams> {
  final MovieRepository repository;

  GetMovies({required this.repository});

  @override
  Future<Either<Failure, Pagination>> call(GetMoviesParams params) async {
    return await repository.getMovies(params.pageNumber);
  }
}

class GetMoviesParams extends Equatable {
  final int pageNumber;

  const GetMoviesParams([this.pageNumber = 1]);

  @override
  List<Object> get props => [pageNumber];
}
