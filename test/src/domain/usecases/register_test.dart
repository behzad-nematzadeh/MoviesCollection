import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/src/domain/entities/user.dart';
import 'package:moviescollection/src/domain/repositories/user_repository.dart';
import 'package:moviescollection/src/domain/usecases/register.dart';

import 'get_user_info_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late Register useCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    useCase = Register(repository: mockUserRepository);
  });

  User tUser = const User(
      id: 1,
      name: 'user',
      email: 'email@yahoo.com',
      createdAt: '2020-10-10 12:12:23',
      updateAt: '2020-10-10 12:12:23');

  test(
    'should register user to remote database from the repository',
    () async {
      // arrange
      when(mockUserRepository.register(any, any, any))
          .thenAnswer((_) async => Right(tUser));
      // act
      final result = await useCase(const RegisterParams(
          userName: 'user', password: '123', email: 'email@yahoo.com'));
      // assert
      expect(result, Right(tUser));
      verify(mockUserRepository.register('user', '123', 'email@yahoo.com'));
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}
