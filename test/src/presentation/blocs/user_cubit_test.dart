import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/src/domain/entities/user.dart';
import 'package:moviescollection/src/domain/usecases/get_user_info.dart';
import 'package:moviescollection/src/domain/usecases/register.dart';
import 'package:moviescollection/src/presentation/blocs/user/user_cubit.dart';

import 'user_cubit_test.mocks.dart';

@GenerateMocks([GetUserInfo, Register])
void main() {
  late UserCubit cubit;
  late MockGetUserInfo mockGetUserInfo;
  late MockRegister mockRegister;

  setUp(() {
    mockGetUserInfo = MockGetUserInfo();
    mockRegister = MockRegister();

    cubit = UserCubit(
      getUserInfo: mockGetUserInfo,
      register: mockRegister,
    );
  });

  tearDown(() {
    cubit.close();
  });

  User tUser = const User(
      id: 1,
      name: 'user',
      email: 'email@yahoo.com',
      createdAt: '2020-10-10 12:12:23',
      updateAt: '2020-10-10 12:12:23');

  group('GetUserInfo', () {
    blocTest(
      'emits [Loading, Success] when successful',
      build: () => cubit,
      act: (UserCubit cubit) {
        when(mockGetUserInfo.call(any)).thenAnswer((_) async => Right(tUser));
        cubit.getUserInfoEvent();
      },
      expect: () => [
        UserLoading(),
        UserLoaded(user: tUser),
      ],
    );

    blocTest(
      'emits [Loading, Error] when fails',
      build: () => cubit,
      act: (UserCubit cubit) {
        when(mockGetUserInfo.call(any))
            .thenAnswer((_) async => Left(ServerFailure(400, 'service error')));
        cubit.getUserInfoEvent();
      },
      expect: () => [
        UserLoading(),
        UserError(message: 'service error'),
      ],
    );

    blocTest(
      'emits [Loading, NoConnection] when fails',
      build: () => cubit,
      act: (UserCubit cubit) {
        when(mockGetUserInfo.call(any))
            .thenAnswer((_) async => Left(NoConnectionFailure()));
        cubit.getUserInfoEvent();
      },
      expect: () => [
        UserLoading(),
        NoConnection(),
      ],
    );
  });

  group('Register', () {
    blocTest(
      'emits [Loading, Success] when successful',
      build: () => cubit,
      act: (UserCubit cubit) {
        when(mockRegister.call(any)).thenAnswer((_) async => Right(tUser));
        cubit.registerEvent('user', '123', 'email@yahoo.com');
      },
      expect: () => [
        UserLoading(),
        UserLoaded(user: tUser),
      ],
    );

    blocTest(
      'emits [Loading, Error] when fails',
      build: () => cubit,
      act: (UserCubit cubit) {
        when(mockRegister.call(any))
            .thenAnswer((_) async => Left(ServerFailure(400, 'service error')));
        cubit.registerEvent('user', '123', 'email@yahoo.com');
      },
      expect: () => [
        UserLoading(),
        UserError(message: 'service error'),
      ],
    );

    blocTest(
      'emits [Loading, NoConnection] when fails',
      build: () => cubit,
      act: (UserCubit cubit) {
        when(mockRegister.call(any))
            .thenAnswer((_) async => Left(NoConnectionFailure()));
        cubit.registerEvent('user', '123', 'email@yahoo.com');
      },
      expect: () => [
        UserLoading(),
        NoConnection(),
      ],
    );
  });
}
