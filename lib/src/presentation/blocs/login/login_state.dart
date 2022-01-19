part of 'login_cubit.dart';

@immutable
abstract class LoginState extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginLoaded extends LoginState {
  final Auth auth;

  LoginLoaded({required this.auth});

  @override
  List<Object> get props => [auth];
}

class LoginError extends LoginState {
  final String message;

  LoginError({required this.message});

  @override
  List<Object> get props => [message];
}

class NoConnection extends LoginState {
  NoConnection();
}
