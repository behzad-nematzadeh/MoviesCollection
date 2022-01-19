import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/src/domain/entities/auth.dart';
import 'package:moviescollection/src/domain/repositories/auth_repository.dart';
import 'package:moviescollection/src/domain/usecases/user_login.dart';

import 'refresh_token_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late UserLogin useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = UserLogin(repository: mockAuthRepository);
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
      when(mockAuthRepository.login(any, any, any))
          .thenAnswer((_) async => Right(tAuth));
      // act
      final result = await useCase(const UserLoginParams(
          userName: 'user', password: '123', grantType: 'refresh_token'));
      // assert
      expect(result, Right(tAuth));
      verify(mockAuthRepository.login('user', '123', 'refresh_token'));
      verifyNoMoreInteractions(mockAuthRepository);
    },
  );
}
