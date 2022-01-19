import 'package:moviescollection/src/domain/entities/auth.dart';

class AuthModel extends Auth {
  const AuthModel({
    required String tokenType,
    required int expiresIn,
    required String accessToken,
    required String refreshToken,
  }) : super(
            tokenType: tokenType,
            expiresIn: expiresIn,
            accessToken: accessToken,
            refreshToken: refreshToken);

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        tokenType: json['token_type'] as String,
        expiresIn: json['expries_in'] as int,
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String,
      );

  Map<String, dynamic> toJson() {
    return {
      'token_type': tokenType,
      'expries_in': expiresIn,
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }
}
