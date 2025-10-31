import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: dotenv.env['API_BASE_URL'] ?? ''),
  );

  Future<Map<String, dynamic>> login(String email, String password, String loai) async {
    try {
      final res = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
        'loai': loai,
      });
      return res.data;
    } catch (e) {
      return {'error': 'Đăng nhập thất bại'};
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    // Đây là mock API vì backend chưa có đăng ký.
    await Future.delayed(const Duration(seconds: 1));
    return {'message': 'Đăng ký thành công'};
  }
}
