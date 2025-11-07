import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/network/token_storage.dart'; // ✅ thêm dòng này

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: dotenv.env['API_BASE_URL'] ?? ''),
  );

  /// 🟢 Đăng nhập
  Future<Map<String, dynamic>> login(String email, String password, String loai) async {
    try {
      final res = await _dio.post('/v1/auth/login', data: {
        'email': email,
        'matKhau': password,
        'loai': loai,
      });

      final data = res.data;
      final token = data['token'] ?? data['access_token'];

      // ✅ Lưu token
      if (token != null && token.toString().isNotEmpty) {
        await TokenStorage.saveToken(token);
      }

      return data;
    } catch (e) {
      return {'error': 'Đăng nhập thất bại'};
    }
  }

  /// 🟡 Đăng ký (nếu backend có)
  Future<Map<String, dynamic>> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return {'message': 'Đăng ký thành công'};
  }
}

class AuthUser {
  final int id;
  final String hoTen;
  final String vaiTro;
  final String token;

  AuthUser({
    required this.id,
    required this.hoTen,
    required this.vaiTro,
    required this.token,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['user']['id'],
      hoTen: json['user']['hoTen'] ?? '',
      vaiTro: json['user']['vaiTro'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
