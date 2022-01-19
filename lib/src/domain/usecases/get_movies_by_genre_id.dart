import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/usecases/usecase.dart';
import 'package:moviescollection/src/domain/entities/pagination.dart';
import 'package:moviescollection/src/domain/repositories/movie_repository.dart';

class GetMoviesByGenreId
    implements UseCase<Pagination, GetMoviesByGenreIdParams> {
  final MovieRepository repository;

  GetMoviesByGenreId({required this.repository});

  @override
  Future<Either<Failure, Pagination>> call(
      GetMoviesByGenreIdParams params) async {
    return await repository.getMoviesByGenreId(
        params.genreId, params.pageNumber);
  }
}

class GetMoviesByGenreIdParams extends Equatable {
  final int genreId;
  final int pageNumber;

  const GetMoviesByGenreIdParams({required this.genreId, this.pageNumber = 1});

  @override
  List<Object> get props => [genreId, pageNumber];
}
