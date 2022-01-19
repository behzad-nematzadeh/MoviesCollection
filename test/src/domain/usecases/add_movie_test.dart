import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/src/domain/entities/post_movie.dart';
import 'package:moviescollection/src/domain/repositories/movie_repository.dart';
import 'package:moviescollection/src/domain/usecases/add_movie.dart';

import 'add_movie_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late AddMovie useCase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    useCase = AddMovie(repository: mockMovieRepository);
  });

  PostMovie tPostMovie =
      const PostMovie(title: 'title', year: 0, country: 'country', imdbId: '0');
  test(
    'should add movie to remote database from the repository',
    () async {
      // arrange
      when(mockMovieRepository.addMovie(any))
          .thenAnswer((_) async => Right(tPostMovie));
      // act
      final result = await useCase(AddMovieParams(postMovie: tPostMovie));
      // assert
      expect(result, Right(tPostMovie));
      verify(mockMovieRepository.addMovie(tPostMovie));
      verifyNoMoreInteractions(mockMovieRepository);
    },
  );
}
