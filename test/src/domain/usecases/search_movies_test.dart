import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/src/domain/entities/metadata.dart';
import 'package:moviescollection/src/domain/entities/movie.dart';
import 'package:moviescollection/src/domain/entities/pagination.dart';
import 'package:moviescollection/src/domain/repositories/movie_repository.dart';
import 'package:moviescollection/src/domain/usecases/search_movies.dart';

import 'add_movie_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late SearchMovies useCase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    useCase = SearchMovies(repository: mockMovieRepository);
  });

  Movie tMovie = const Movie(
      id: 0, title: 'title', poster: 'poster', genres: [], images: []);
  List<Movie> tMovieList = [tMovie];
  Metadata tMetadata =
      const Metadata(currentPage: "1", perPage: 10, pageCount: 1, totalCount: 1);

  Pagination tPagination = Pagination(data: tMovieList, metadata: tMetadata);

  test(
    'should search in list of movies by letter and page number from the repository',
    () async {
      // arrange
      when(mockMovieRepository.searchMovie(any))
          .thenAnswer((_) async => Right(tPagination));
      // act
      final result = await useCase(
          const SearchMoviesParams(movieName: 'movie', pageNumber: 1));
      // assert
      expect(result, Right(tPagination));
      verify(mockMovieRepository.searchMovie('movie', 1));
      verifyNoMoreInteractions(mockMovieRepository);
    },
  );
}
