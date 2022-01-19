import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/src/domain/entities/auth.dart';
import 'package:moviescollection/src/domain/usecases/refresh_token.dart';
import 'package:moviescollection/src/domain/usecases/user_login.dart';
import 'package:moviescollection/src/presentation/blocs/auth/auth_cubit.dart';

import 'auth_cubit_test.mocks.dart';

@GenerateMocks([UserLogin, RefreshToken])
void main() {
  late AuthCubit cubit;
  late MockUserLogin mockUserLogin;
  late MockRefreshToken mockRefreshToken;

  setUp(() {
    mockUserLogin = MockUserLogin();
    mockRefreshToken = MockRefreshToken();

    cubit = AuthCubit(
      userLogin: mockUserLogin,
      refreshToken: mockRefreshToken,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initialState should be AuthInitial', () {
    // assert
    expect(cubit.state, equals(AuthInitial()));
  });

  Auth tAuth = const Auth(
    tokenType: 'Bearer',
    expiresIn: 16537295,
    accessToken: 'NJhsHG6TFC5kdTEM34cMzAxFtfs34x...',
    refreshToken: 'NJhsHG6TFC5kdTEM34cMzAxFtfs34x...',
  );

  group('UserLogin', () {
    blocTest(
      'emits [Loading, Success] when successful',
      build: () => cubit,
      act: (AuthCubit cubit) {
        when(mockUserLogin.call(any)).thenAnswer((_) async => Right(tAuth));
        cubit.userLoginEvent('userName', 'password', 'grantType');
      },
      expect: () => [
        AuthLoading(),
        AuthLoaded(auth: tAuth),
      ],
    );


    blocTest(
      'emits [Loading, Error] when fails',
      build: () => cubit,
      act: (AuthCubit cubit) {
        when(mockUserLogin.call(any))
            .thenAnswer((_) async => Left(ServerFailure(400, 'service error')));
        cubit.userLoginEvent('userName', 'password', 'grantType');
      },
      expect: () => [
        AuthLoading(),
        AuthError(message: 'service error'),
      ],
    );

    blocTest(
      'emits [Loading, NoConnection] when fails',
      build: () => cubit,
      act: (AuthCubit cubit) {
        when(mockUserLogin.call(any))
            .thenAnswer((_) async => Left(NoConnectionFailure()));
        cubit.userLoginEvent('userName', 'password', 'grantType');
      },
      expect: () => [
        AuthLoading(),
        NoConnection(),
      ],
    );
  });

  group('RefreshToken', () {
    blocTest(
      'emits [Loading, Success] when successful',
      build: () => cubit,
      act: (AuthCubit cubit) {
        when(mockRefreshToken.call(any)).thenAnswer((_) async => Right(tAuth));
        cubit.refreshTokenEvent('grantType', 'token');
      },
      expect: () => [
        AuthLoading(),
        AuthLoaded(auth: tAuth),
      ],
    );


    blocTest(
      'emits [Loading, Error] when fails',
      build: () => cubit,
      act: (AuthCubit cubit) {
        when(mockRefreshToken.call(any))
            .thenAnswer((_) async => Left(ServerFailure(400, 'service error')));
        cubit.refreshTokenEvent('grantType', 'token');
      },
      expect: () => [
        AuthLoading(),
        AuthError(message: 'service error'),
      ],
    );

    blocTest(
      'emits [Loading, NoConnection] when fails',
      build: () => cubit,
      act: (AuthCubit cubit) {
        when(mockRefreshToken.call(any))
            .thenAnswer((_) async => Left(NoConnectionFailure()));
        cubit.refreshTokenEvent('grantType', 'token');
      },
      expect: () => [
        AuthLoading(),
        NoConnection(),
      ],
    );
  });
}
