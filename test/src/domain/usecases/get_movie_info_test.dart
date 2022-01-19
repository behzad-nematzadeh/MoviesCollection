import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/src/domain/entities/movie.dart';
import 'package:moviescollection/src/domain/repositories/movie_repository.dart';
import 'package:moviescollection/src/domain/usecases/get_movie_info.dart';

import 'add_movie_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late GetMovieInfo useCase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    useCase = GetMovieInfo(repository: mockMovieRepository);
  });

  Movie tMovie = const Movie(
      id: 0, title: 'title', poster: 'poster', genres: [], images: []);
  test(
    'should get movie info by movie id from the repository',
    () async {
      // arrange
      when(mockMovieRepository.getMovieInfo(any))
          .thenAnswer((_) async => Right(tMovie));
      // act
      final result = await useCase(const GetMovieInfoParams(movieId: 1));
      // assert
      expect(result, Right(tMovie));
      verify(mockMovieRepository.getMovieInfo(1));
      verifyNoMoreInteractions(mockMovieRepository);
    },
  );
}
