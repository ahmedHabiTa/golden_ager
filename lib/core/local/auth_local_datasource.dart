import 'dart:convert';


import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/domain/entities/user.dart';
import '../error/exceptions.dart';

const userCacheConst = "user_cache";
const cacheTokenConst = "cache_token";
const loginInfoConst = "login_info";

abstract class AuthLocalDataSource {
  Future<void> cacheUserData({required User user});
  Future<User> getcachedUserData();

  Future<void> clearCachedUser();


  Future<void> cacheUserLoginInfo(
      {required String password, required String email});
  Future<Map<String, dynamic>> getCacheUserLoginInfo();

  Future<void> clearData();
}

class AuthLocalDataSourceImpl extends AuthLocalDataSource {
  final SharedPreferences sharedPreference;

  AuthLocalDataSourceImpl({required this.sharedPreference});
  @override
  Future<void> cacheUserData({required User user}) async {
    try {
      sharedPreference.setString(userCacheConst, user.toJson());
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<User> getcachedUserData() async {
    try {
      final usershared = sharedPreference.getString(userCacheConst);
      if (usershared != null) {
        return User.fromMap(
            json.decode(sharedPreference.getString(userCacheConst)!));
      } else {
        throw NoCachedUserException();
      }
    } on NoCachedUserException {
      throw NoCachedUserException();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await sharedPreference.clear();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheUserLoginInfo(
      {required String password, required String email}) async {
    try {
      await sharedPreference.setString(
          loginInfoConst, json.encode({"email": email, "password": password}));
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<Map<String, dynamic>> getCacheUserLoginInfo() async {
    try {
      final loginInfo = sharedPreference.getString(loginInfoConst);
      if (loginInfo != null) {
        return json.decode(loginInfo) as Map<String, dynamic>;
      } else {
        throw NoCachedUserException();
      }
    } catch (e) {
      throw NoCachedUserException();
    }
  }

  @override
  Future<void> clearData() async {
    try {
      await sharedPreference.clear();
    } catch (e) {
      throw NoCachedUserException();
    }
  }
}
