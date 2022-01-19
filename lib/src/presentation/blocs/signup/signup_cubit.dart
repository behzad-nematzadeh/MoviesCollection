import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/src/domain/entities/user.dart';
import 'package:moviescollection/src/domain/usecases/register.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final Register register;

  SignupCubit({required this.register}) : super(SignupInitial());

  registerEvent(String userName, String password, String email) async {
    emit(SignupLoading());
    final request = await register.call(
        RegisterParams(userName: userName, password: password, email: email));
    emitFunction(request);
  }

  void emitFunction(Either<Failure, dynamic> request) {
    request.fold((failure) {
      if (failure is NoConnectionFailure) {
        emit(NoConnection());
      } else {
        ServerFailure err = failure as ServerFailure;
        emit(SignupError(message: err.message!));
      }
    }, (response) => emit(SignupLoaded(user: response)));
  }
}
