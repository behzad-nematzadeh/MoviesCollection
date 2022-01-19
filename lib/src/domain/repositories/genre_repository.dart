import 'package:dartz/dartz.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/src/domain/entities/genre.dart';

abstract class GenreRepository {
  Future<Either<Failure, List<Genre>>> getGenres();
}
