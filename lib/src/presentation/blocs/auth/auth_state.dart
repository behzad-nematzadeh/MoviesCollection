part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthEmpty extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final Auth auth;

  AuthLoaded({required this.auth});

  @override
  List<Object> get props => [auth];
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

class NoConnection extends AuthState {
  NoConnection();
}
