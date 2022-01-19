import 'package:equatable/equatable.dart';

class Auth extends Equatable {
  final String tokenType;
  final int expiresIn;
  final String accessToken;
  final String refreshToken;

  const Auth({
    required this.tokenType,
    required this.expiresIn,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object> get props => [tokenType, expiresIn, accessToken, refreshToken];
}
