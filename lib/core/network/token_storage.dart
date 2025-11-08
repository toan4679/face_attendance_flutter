import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _userRoleKey = 'user_role';
  static const _userNameKey = 'user_name';
  static const _userEmailKey = 'user_email';

  // TOKEN
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async => await _storage.read(key: _tokenKey);

  static Future<void> clearToken() async => await _storage.delete(key: _tokenKey);

  // USER ID
  static Future<void> saveUserId(String id) async {
    await _storage.write(key: _userIdKey, value: id);
  }

  static Future<String?> getUserId() async => await _storage.read(key: _userIdKey);

  static Future<void> clearUserId() async => await _storage.delete(key: _userIdKey);

  // ROLE
  static Future<void> saveUserRole(String role) async {
    await _storage.write(key: _userRoleKey, value: role);
  }

  static Future<String?> getUserRole() async => await _storage.read(key: _userRoleKey);

  // USER INFO
  static Future<void> saveUserInfo(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
  }

  static Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_userNameKey),
      'email': prefs.getString(_userEmailKey),
    };
  }

  // CLEAR ALL
  static Future<void> clearAll() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _userRoleKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
  }
}
