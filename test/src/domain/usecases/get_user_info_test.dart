import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/core/usecases/usecase.dart';
import 'package:moviescollection/src/domain/entities/user.dart';
import 'package:moviescollection/src/domain/repositories/user_repository.dart';
import 'package:moviescollection/src/domain/usecases/get_user_info.dart';

import 'get_user_info_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late GetUserInfo useCase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    useCase = GetUserInfo(repository: mockUserRepository);
  });

  User tUser = const User(
      id: 1,
      name: 'user',
      email: 'email@yahoo.com',
      createdAt: '2020-10-10 12:12:23',
      updateAt: '2020-10-10 12:12:23');

  test(
    'should get user information from the repository',
    () async {
      // arrange
      when(mockUserRepository.getUserInfo())
          .thenAnswer((_) async => Right(tUser));
      // act
      final result = await useCase(NoParams());
      // assert
      expect(result, Right(tUser));
      verify(mockUserRepository.getUserInfo());
      verifyNoMoreInteractions(mockUserRepository);
    },
  );
}
