import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/src/domain/entities/auth.dart';
import 'package:moviescollection/src/domain/usecases/refresh_token.dart';
import 'package:moviescollection/src/domain/usecases/user_login.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserLogin userLogin;
  final RefreshToken refreshToken;

  AuthCubit({
    required this.userLogin,
    required this.refreshToken,
  }) : super(AuthInitial());

  userLoginEvent(String userName, String password, String grantType) async {
    emit(AuthLoading());
    final request = await userLogin.call(UserLoginParams(
      userName: userName,
      password: password,
      grantType: grantType,
    ));
    emitFunction(request);
  }

  refreshTokenEvent(String grantType, String token) async {
    emit(AuthLoading());
    final request = await refreshToken.call(RefreshTokenParams(
      grantType: grantType,
      refreshToken: token,
    ));
    emitFunction(request);
  }

  void emitFunction(Either<Failure, dynamic> request) {
    request.fold((failure) {
      if (failure is NoConnectionFailure) {
        emit(NoConnection());
      } else {
        ServerFailure err = failure as ServerFailure;
        emit(AuthError(message: err.message!));
      }
    }, (response) => emit(AuthLoaded(auth: response)));
  }
}
