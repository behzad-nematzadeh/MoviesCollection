import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/usecases/usecase.dart';
import 'package:moviescollection/src/domain/entities/genre.dart';
import 'package:moviescollection/src/domain/usecases/get_genres.dart';

part 'genre_state.dart';

class GenreCubit extends Cubit<GenreState> {
  final GetGenres getGenres;

  GenreCubit({required this.getGenres})  : super(GenreInitial());

  getGenreList() async {
    emit(GenreLoading());

    final request = await getGenres.call(NoParams());
    request.fold((failure) {
      if (failure is NoConnectionFailure) {
        emit(NoConnection());
      } else {
        ServerFailure err = failure as ServerFailure;
        emit(GenreError(message: err.message!));
      }
    }, (response) => emit(GenreLoaded(genreList: response)));
  }
}
