import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moviescollection/core/usecases/usecase.dart';
import 'package:moviescollection/src/domain/usecases/authentication.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final Authentication authentication;

  SplashCubit({required this.authentication}) : super(SplashInitial());

  authenticationEvent() async {
    final result = await authentication.call(NoParams());
    result.fold((failure) {
      emit(SplashToLoginPage());
    }, (response) {
      if (response) return emit(SplashToLoginPage());
      emit(SplashToHomePage());
    });
  }
}
