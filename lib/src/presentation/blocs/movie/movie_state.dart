part of 'movie_cubit.dart';

@immutable
abstract class MovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final dynamic response;

  MovieLoaded({required this.response});
}

class MovieError extends MovieState {
  final String message;

  MovieError({required this.message});

  @override
  List<Object> get props => [message];
}

class MovieNoConnection extends MovieState {
  MovieNoConnection();
}
