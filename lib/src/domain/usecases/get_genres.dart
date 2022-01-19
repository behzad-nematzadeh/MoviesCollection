import 'package:dartz/dartz.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/usecases/usecase.dart';
import 'package:moviescollection/src/domain/entities/genre.dart';
import 'package:moviescollection/src/domain/repositories/genre_repository.dart';

class GetGenres implements UseCase<List<Genre>, NoParams> {
  final GenreRepository repository;

  GetGenres({required this.repository});

  @override
  Future<Either<Failure, List<Genre>>> call(NoParams params) async {
    return await repository.getGenres();
  }
}
