import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/usecases/usecase.dart';
import 'package:moviescollection/src/domain/entities/auth.dart';
import 'package:moviescollection/src/domain/repositories/auth_repository.dart';

class RefreshToken implements UseCase<Auth, RefreshTokenParams> {
  final AuthRepository repository;

  RefreshToken({required this.repository});

  @override
  Future<Either<Failure, Auth>> call(RefreshTokenParams params) async {
    return await repository.refreshToken(params.grantType, params.refreshToken);
  }
}

class RefreshTokenParams extends Equatable {
  final String grantType;
  final String refreshToken;

  const RefreshTokenParams({
    required this.grantType,
    required this.refreshToken,
  });

  @override
  List<Object> get props => [grantType, refreshToken];
}
