part of 'splash_cubit.dart';

abstract class SplashState extends Equatable {
  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashState {}

class SplashToHomePage extends SplashState {}

class SplashToLoginPage extends SplashState {}
