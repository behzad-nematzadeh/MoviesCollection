import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {
  final int code;
  final String? message;

  ServerFailure(this.code, this.message);
}

class CacheFailure extends Failure {}

class NoConnectionFailure extends Failure {}
