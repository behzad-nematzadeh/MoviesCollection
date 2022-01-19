import 'package:moviescollection/src/data/models/auth_model.dart';

import 'api_provider.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login(String userName, String password, String grantType);

  Future<AuthModel> refreshToken(String grantType, String refreshToken);
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final ApiProvider apiProvider;

  AuthRemoteDataSourceImpl({required this.apiProvider});

  @override
  Future<AuthModel> login(String userName, String password, String grantType) =>
      _getDataFromUrl<AuthModel>(
          apiProvider.postRequest('oauth/token', <String, String>{
            'username': userName,
            'password': password,
            'grant_type': grantType
          }),
          (data) => AuthModel.fromJson(data));

  @override
  Future<AuthModel> refreshToken(String grantType, String refreshToken) =>
      _getDataFromUrl<AuthModel>(
          apiProvider.postRequest('api/oauth/token', <String, String>{
            'grant_type': grantType,
            'refresh_token': refreshToken
          }),
          (data) => AuthModel.fromJson(data));

  Future<T> _getDataFromUrl<T>(Future request, Function(dynamic) func) async {
    var response = await request;
    return func(response);
  }
}
