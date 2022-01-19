import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/core/usecases/usecase.dart';
import 'package:moviescollection/src/domain/entities/genre.dart';
import 'package:moviescollection/src/domain/repositories/genre_repository.dart';
import 'package:moviescollection/src/domain/usecases/get_genres.dart';

import 'get_genres_test.mocks.dart';

@GenerateMocks([GenreRepository])
void main() {
  late GetGenres useCase;
  late MockGenreRepository mockGenreRepository;

  setUp(() {
    mockGenreRepository = MockGenreRepository();
    useCase = GetGenres(repository: mockGenreRepository);
  });

  final List<Genre> tGenreList = [];
  test(
    'should get list of genres from the repository',
        () async {
      // arrange
      when(mockGenreRepository.getGenres())
          .thenAnswer((_) async => Right(tGenreList));
      // act
      final result = await useCase(NoParams());
      // assert
      expect(result, Right(tGenreList));
      verify(mockGenreRepository.getGenres());
      verifyNoMoreInteractions(mockGenreRepository);
    },
  );
}
