part of 'genre_cubit.dart';

@immutable
abstract class GenreState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GenreInitial extends GenreState {}

class GenreLoading extends GenreState {}

class GenreLoaded extends GenreState {
  final List<Genre> genreList;

  GenreLoaded({required this.genreList});
}

class GenreError extends GenreState {
  final String message;

  GenreError({required this.message});

  @override
  List<Object> get props => [message];
}

class NoConnection extends GenreState {
  NoConnection();
}
