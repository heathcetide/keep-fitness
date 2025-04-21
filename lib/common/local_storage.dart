import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class LocalStorage {

  // 用户
  static _LS<String> user_token = _LS('user_token');

  static _LS<String> user_avatar = _LS('user_avatar');
  static _LS<String> user_userName = _LS('user_userName');
  static _LS<String> user_email = _LS('email');
  static _LS<String> user_phone = _LS('phone');
  static _LS<String> user_address = _LS('address');
  static _LS<String> user_points = _LS('points');
  static _LS<String> user_articleCount = _LS('articleCount');
  static _LS<String> user_activityCount = _LS('activityCount');
  static _LS<String> user_gender = _LS('gender');
  static _LS<String> user_bio = _LS('bio');
  static _LS<String> user_birthday = _LS('birthday');
  static _LS<String> user_lastLoginTime = _LS('lastLoginTime');
  static _LS<String> user_createdAt = _LS('createdAt');
}

class _LS<T> {
  final String key;
  final GetStorage _storage = GetStorage();

  _LS(this.key);

  T? get() {
    var v = _storage.read(key);
    if (v == null) {
      return null;
    }
    if (v is String && v.startsWith('@@**JSON^^@@')) {
      v = v.substring('@@**JSON^^@@'.length);
      return json.decode(v) as T;
    }
    return v as T?;
  }

  void set(T value) {
    if (value is Map) {
      _storage.write(key, '@@**JSON^^@@${json.encode(value)}');
    } else {
      _storage.write(key, value);
    }
  }
}
