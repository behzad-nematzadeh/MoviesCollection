import 'package:moviescollection/src/data/models/user_model.dart';

import 'api_provider.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> register(String userName, String password, String email);

  Future<UserModel> getUserInfo();
}

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final ApiProvider apiProvider;

  UserRemoteDataSourceImpl({required this.apiProvider});

  @override
  Future<UserModel> getUserInfo() => _getDataFromUrl<UserModel>(
      apiProvider.postRequest('api/user'), (data) => UserModel.fromJson(data));

  @override
  Future<UserModel> register(String userName, String password, String email) =>
      _getDataFromUrl<UserModel>(
          apiProvider.postRequest('api/v1/register', <String, dynamic>{
            'name': userName,
            'password': password,
            'email': email,
          }),
          (data) => UserModel.fromJson(data));

  Future<T> _getDataFromUrl<T>(Future request, Function(dynamic) func) async {
    var response = await request;
    return func(response);
  }
}
