import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/src/domain/entities/metadata.dart';
import 'package:moviescollection/src/domain/entities/movie.dart';
import 'package:moviescollection/src/domain/entities/pagination.dart';
import 'package:moviescollection/src/domain/entities/post_movie.dart';
import 'package:moviescollection/src/domain/usecases/add_movie.dart';
import 'package:moviescollection/src/domain/usecases/get_movie_info.dart';
import 'package:moviescollection/src/domain/usecases/get_movies.dart';
import 'package:moviescollection/src/domain/usecases/get_movies_by_genre_id.dart';
import 'package:moviescollection/src/domain/usecases/search_movies.dart';
import 'package:moviescollection/src/presentation/blocs/movie/movie_cubit.dart';

import 'movie_cubit_test.mocks.dart';

@GenerateMocks([
  GetMovieInfo,
  GetMovies,
  GetMoviesByGenreId,
  AddMovie,
  SearchMovies,
])
void main() {
  late MovieCubit cubit;
  late MockGetMovieInfo mockGetMovieInfo;
  late MockGetMovies mockGetMovies;
  late MockGetMoviesByGenreId mockGetMoviesByGenreId;
  late MockAddMovie mockAddMovie;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockGetMovieInfo = MockGetMovieInfo();
    mockGetMovies = MockGetMovies();
    mockGetMoviesByGenreId = MockGetMoviesByGenreId();
    mockAddMovie = MockAddMovie();
    mockSearchMovies = MockSearchMovies();

    cubit = MovieCubit(
      getMovieInfo: mockGetMovieInfo,
      getMovies: mockGetMovies,
      getMoviesByGenreId: mockGetMoviesByGenreId,
      addMovie: mockAddMovie,
      searchMovies: mockSearchMovies,
    );
  });

  tearDown(() {
    cubit.close();
  });

  Movie tMovie = const Movie(
      id: 0, title: 'title', poster: 'poster', genres: [], images: []);
  List<Movie> tMovieList = [tMovie];
  Metadata tMetadata = const Metadata(
      currentPage: "1", perPage: 10, pageCount: 1, totalCount: 1);

  Pagination tPagination = Pagination(data: tMovieList, metadata: tMetadata);

  group('GetMovieInfo', () {
    blocTest(
      'emits [Loading, Success] when successful',
      build: () => cubit,
      act: (MovieCubit cubit) {
        when(mockGetMovieInfo.call(any)).thenAnswer((_) async => Right(tMovie));
        cubit.getMovieInfoEvent(1);
      },
      expect: () => [
        MovieLoading(),
        MovieLoaded(response: tMovie),
      ],
    );

    blocTest(
      'emits [Loading, Error] when fails',
      build: () => cubit,
      act: (MovieCubit cubit) {
        when(mockGetMovieInfo.call(any))
            .thenAnswer((_) async => Left(ServerFailure(400, 'service error')));
        cubit.getMovieInfoEvent(1);
      },
      expect: () => [
        MovieLoading(),
        MovieError(message: 'service error'),
      ],
    );

    blocTest(
      'emits [Loading, NoConnection] when fails',
      build: () => cubit,
      act: (MovieCubit cubit) {
        when(mockGetMovieInfo.call(any))
            .thenAnswer((_) async => Left(NoConnectionFailure()));
        cubit.getMovieInfoEvent(1);
      },
      expect: () => [
        MovieLoading(),
        MovieNoConnection(),
      ],
    );
  });

  group('GetMovies', () {
    blocTest(
      'emits [Loading, Success] when successful',
      build: () => cubit,
      act: (MovieCubit cubit) {
        when(mockGetMovies.call(any))
            .thenAnswer((_) async => Right(tPagination));
        cubit.getMoviesEvent(1);
      },
      expect: () => [
        MovieLoading(),
        MovieLoaded(response: tPagination),
      ],
    );

    blocTest(
      'emits [Loading, Error] when fails',
      build: () => cubit,
      act: (MovieCubit cubit) {
        when(mockGetMovies.call(any))
            .thenAnswer((_) async => Left(ServerFailure(400, 'service error')));
        cubit.getMoviesEvent(1);
      },
      expect: () => [
        MovieLoading(),
        MovieError(message: 'service error'),
      ],
    );

    blocTest(
      'emits [Loading, NoConnection] when fails',
      build: () => cubit,
      act: (MovieCubit cubit) {
        when(mockGetMovies.call(any))
            .thenAnswer((_) async => Left(NoConnectionFailure()));
        cubit.getMoviesEvent(1);
      },
      expect: () => [
        MovieLoading(),
        MovieNoConnection(),
      ],
    );
  });

  group('GetMoviesByGenreId', () {
    blocTest(
      'emits [Loading, Success] when successful',
      build: () => cubit,
      act: (MovieCubit cubit) {
        when(mockGetMoviesByGenreId.call(any))
            .thenAnswer((_) async => Right(tPagination));
        cubit.getMoviesByGenreIdEvent(1);
      },
      expect: () => [
        MovieLoading(),
        MovieLoaded(response: tPagination),
      ],
    );

    blocTest(
      'emits [Loading, Error] when fails',
      build: () => cubit,
      act: (MovieCubit cubit) {
        when(mockGetMoviesByGenreId.call(any))
            .thenAnswer((_) async => Left(ServerFailure(400, 'service error')));
        cubit.getMoviesByGenreIdEvent(1);
      },
      expect: () => [
        MovieLoading(),
        MovieError(message: 'service error'),
      ],
    );

    blocTest(
      'emits [Loading, NoConnection] when fails',
      build: () => cubit,
      act: (MovieCubit cubit) {
        when(mockGetMoviesByGenreId.call(any))
            .thenAnswer((_) async => Left(NoConnectionFailure()));
        cubit.getMoviesByGenreIdEvent(1);
      },
      expect: () => [
        MovieLoading(),
        MovieNoConnection(),
      ],
    );
  });

  PostMovie tPostMovie =
      const PostMovie(title: 'title', year: 0, country: 'country', imdbId: '0');
  group('AddMovie', () {
    blocTest(
      'emits [Loading, Success] when successful',
      build: () => cubit,
      act: (MovieCubit cubit) {
        when(mockAddMovie.call(any)).thenAnswer((_) async => Right(tPostMovie));
        cubit.addMovieEvent(tPostMovie);
      },
      expect: () => [
        MovieLoading(),
        MovieLoaded(response: tPagination),
      ],
    );

    blocTest(
      'emits [Loading, Error] when fails',
      build: () => cubit,
      act: (MovieCubit cubit) {
        when(mockAddMovie.call(any))
            .thenAnswer((_) async => Left(ServerFailure(400, 'service error')));
        cubit.addMovieEvent(tPostMovie);
      },
      expect: () => [
        MovieLoading(),
        MovieError(message: 'service error'),
      ],
    );

    blocTest(
      'emits [Loading, NoConnection] when fails',
      build: () => cubit,
      act: (MovieCubit cubit) {
        when(mockAddMovie.call(any))
            .thenAnswer((_) async => Left(NoConnectionFailure()));
        cubit.addMovieEvent(tPostMovie);
      },
      expect: () => [
        MovieLoading(),
        MovieNoConnection(),
      ],
    );
  });
}
