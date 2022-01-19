import 'dart:convert';

import 'package:moviescollection/core/error/exceptions.dart';
import 'package:moviescollection/core/utils/constants.dart';
import 'package:moviescollection/src/data/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<bool> isAuthenticated();

  Future<void> cacheToken(AuthModel auth);

  Future<AuthModel> getToken();
}

class LocalDataSourceImpl extends LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> isAuthenticated() {
    bool? isAuthenticated =
        sharedPreferences.getBool(Constant.authenticationKey);
    if (isAuthenticated != null) {
      return Future.value(isAuthenticated);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheToken(AuthModel auth) {
    return sharedPreferences.setString(
        Constant.tokenKey, json.encode(auth.toJson()));
  }

  @override
  Future<AuthModel> getToken() {
    final jsonString = sharedPreferences.getString(Constant.tokenKey);
    if (jsonString != null) {
      return Future.value(AuthModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
