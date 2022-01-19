import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/src/domain/entities/genre.dart';
import 'package:moviescollection/src/domain/usecases/get_genres.dart';
import 'package:moviescollection/src/presentation/blocs/genre/genre_cubit.dart';

import 'genre_cubit_test.mocks.dart';

@GenerateMocks([GetGenres])
void main() {
  late GenreCubit cubit;
  late MockGetGenres mockGetGenres;

  setUp(() {
    mockGetGenres = MockGetGenres();

    cubit = GenreCubit(getGenres: mockGetGenres);
  });

  tearDown(() {
    cubit.close();
  });

  Genre tGenre = const Genre(id: 1, name: 'drama');
  var tGenreList = [tGenre];

  group('GetGenres', () {
    
    blocTest(
      'emits [Loading, Success] when successful',
      build: () => cubit,
      act: (GenreCubit cubit) {
        when(mockGetGenres.call(any))
            .thenAnswer((_) async => Right(tGenreList));
        cubit.getGenreList();
      },
      expect: () => [
        GenreLoading(),
        GenreLoaded(genreList: tGenreList),
      ],
    );

    blocTest(
      'emits [Loading, Error] when fails',
      build: () => cubit,
      act: (GenreCubit cubit) {
        when(mockGetGenres.call(any))
            .thenAnswer((_) async => Left(ServerFailure(400, 'service error')));
        cubit.getGenreList();
      },
      expect: () => [
        GenreLoading(),
        GenreError(message: 'service error'),
      ],
    );

    blocTest(
      'emits [Loading, NoConnection] when fails',
      build: () => cubit,
      act: (GenreCubit cubit) {
        when(mockGetGenres.call(any))
            .thenAnswer((_) async => Left(NoConnectionFailure()));
        cubit.getGenreList();
      },
      expect: () => [
        GenreLoading(),
        NoConnection(),
      ],
    );
  });
}
