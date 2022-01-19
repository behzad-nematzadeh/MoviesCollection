import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:moviescollection/core/error/failures.dart';
import 'package:moviescollection/core/usecases/usecase.dart';
import 'package:moviescollection/src/domain/entities/user.dart';
import 'package:moviescollection/src/domain/usecases/get_user_info.dart';
import 'package:moviescollection/src/domain/usecases/register.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUserInfo getUserInfo;
  final Register register;

  UserCubit({required this.getUserInfo, required this.register})
      : super(UserInitial());

  getUserInfoEvent() async {
    emit(UserLoading());
    final request = await getUserInfo.call(NoParams());
    emitFunction(request);
  }

  registerEvent(String userName, String password, String email) async {
    emit(UserLoading());
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
        emit(UserError(message: err.message!));
      }
    }, (response) => emit(UserLoaded(user: response)));
  }
}
