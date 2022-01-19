import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/usecases/usecase.dart';
import 'package:moviescollection/src/domain/entities/movie.dart';
import 'package:moviescollection/src/domain/repositories/movie_repository.dart';

class GetMovieInfo implements UseCase<Movie, GetMovieInfoParams> {
  final MovieRepository repository;

  GetMovieInfo({required this.repository});

  @override
  Future<Either<Failure, Movie>> call(GetMovieInfoParams params) async {
    return await repository.getMovieInfo(params.movieId);
  }
}

class GetMovieInfoParams extends Equatable {
  final int movieId;

  const GetMovieInfoParams({required this.movieId});

  @override
  List<Object> get props => [movieId];
}
