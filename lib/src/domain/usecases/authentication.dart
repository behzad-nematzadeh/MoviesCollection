import 'package:dartz/dartz.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/usecases/usecase.dart';
import 'package:moviescollection/src/domain/repositories/auth_repository.dart';

class Authentication implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  Authentication({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isAuthenticated();
  }
}
