import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _gvIdKey = 'giangvien_id';
  // static Future<void> saveToken(String token) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('auth_token', token);
  // }
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }
  // static Future<String?> getToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('auth_token');
  // }
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
  // static Future<void> clearToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('auth_token');
  //   await prefs.remove('user_name');
  //   await prefs.remove('user_email');
  // }
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
  static Future<void> saveGiangVienId(String id) async {
    await _storage.write(key: _gvIdKey, value: id);
  }

  static Future<String?> getGiangVienId() async {
    return await _storage.read(key: _gvIdKey);
  }
  // 🧩 Lưu thông tin người dùng thật
  static Future<void> saveUserInfo(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
  }

  static Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('user_name'),
      'email': prefs.getString('user_email'),
    };
  }
}
