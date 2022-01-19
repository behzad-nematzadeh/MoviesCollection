import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/src/domain/entities/auth.dart';
import 'package:moviescollection/src/domain/repositories/auth_repository.dart';
import 'package:moviescollection/src/domain/usecases/refresh_token.dart';

import 'refresh_token_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late RefreshToken useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = RefreshToken(repository: mockAuthRepository);
  });

  Auth tAuth = const Auth(
      tokenType: 'Bearer',
      expiresIn: 16537295,
      accessToken: 'NJhsHG6TFC5kdTEM34cMzAxFtfs34x...',
      refreshToken: 'NJhsHG6TFC5kdTEM34cMzAxFtfs34x...');

  test(
    'should refresh user token from the repository',
    () async {
      // arrange
      when(mockAuthRepository.refreshToken(any, any))
          .thenAnswer((_) async => Right(tAuth));
      // act
      final result = await useCase(const RefreshTokenParams(
          grantType: 'refresh_token',
          refreshToken: 'NJhsHG6TFC5kdTEM34cMzAxFtfs34x...'));
      // assert
      expect(result, Right(tAuth));
      verify(mockAuthRepository.refreshToken(
          'refresh_token', 'NJhsHG6TFC5kdTEM34cMzAxFtfs34x...'));
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
