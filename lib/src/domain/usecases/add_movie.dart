import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/usecases/usecase.dart';
import 'package:moviescollection/src/domain/entities/post_movie.dart';
import 'package:moviescollection/src/domain/repositories/movie_repository.dart';

class AddMovie implements UseCase<PostMovie, AddMovieParams> {
  final MovieRepository repository;

  AddMovie({required this.repository});

  @override
  Future<Either<Failure, PostMovie>> call(AddMovieParams params) async {
    return await repository.addMovie(params.postMovie);
  }
}

class AddMovieParams extends Equatable {
  final PostMovie postMovie;

  const AddMovieParams({required this.postMovie});

  @override
  List<Object> get props => [postMovie];
}
