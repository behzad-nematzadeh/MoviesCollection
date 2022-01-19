import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/usecases/usecase.dart';
import 'package:moviescollection/src/domain/entities/pagination.dart';
import 'package:moviescollection/src/domain/repositories/movie_repository.dart';

class SearchMovies implements UseCase<Pagination, SearchMoviesParams> {
  final MovieRepository repository;

  SearchMovies({required this.repository});

  @override
  Future<Either<Failure, Pagination>> call(SearchMoviesParams params) async {
    return await repository.searchMovie(params.movieName, params.pageNumber);
  }
}

class SearchMoviesParams extends Equatable {
  final String movieName;
  final int pageNumber;

  const SearchMoviesParams({required this.movieName, this.pageNumber = 1});

  @override
  List<Object> get props => [movieName, pageNumber];
}
