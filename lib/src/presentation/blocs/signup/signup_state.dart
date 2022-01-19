part of 'signup_cubit.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupLoaded extends SignupState {
  final User user;

  SignupLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class SignupError extends SignupState {
  final String message;

  SignupError({required this.message});

  @override
  List<Object> get props => [message];
}

class NoConnection extends SignupState {
  NoConnection();
}
