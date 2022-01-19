import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/src/domain/entities/auth.dart';
import 'package:moviescollection/src/domain/usecases/user_login.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserLogin userLogin;

  LoginCubit({required this.userLogin}) : super(LoginInitial());

  userLoginEvent(String userName, String password, String grantType) async {
    emit(LoginLoading());
    final request = await userLogin.call(UserLoginParams(
      userName: userName,
      password: password,
      grantType: grantType,
    ));
    emitFunction(request);
  }

  void emitFunction(Either<Failure, dynamic> request) {
    request.fold((failure) {
      if (failure is NoConnectionFailure) {
        emit(NoConnection());
      } else {
        ServerFailure err = failure as ServerFailure;
        emit(LoginError(message: err.message!));
      }
    }, (response) => emit(LoginLoaded(auth: response)));
  }
}
