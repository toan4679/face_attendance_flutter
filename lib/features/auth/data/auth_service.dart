import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/network/token_storage.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: dotenv.env['API_BASE_URL'] ?? ''),
  );

  /// Đăng nhập
  Future<Map<String, dynamic>> login(String email, String password, String loai) async {
    try {
      final res = await _dio.post('/auth/login', data: {
        'email': email,
        'matKhau': password,
        'loai': loai,
      });

      final data = res.data;
      final token = data['token'] ?? data['access_token'];
      final user = data['user'] ?? {};

      // Lưu token
      if (token != null && token.toString().isNotEmpty) {
        await TokenStorage.saveToken(token.toString());
      }

      // Lưu ID người dùng (giảng viên/sinh viên)
      if (user['id'] != null) {
        await TokenStorage.saveUserId(user['id'].toString());
      }

      // Lưu tên và email
      if (user['hoTen'] != null) {
        await TokenStorage.saveUserInfo(
          user['hoTen'].toString(),
          user['email']?.toString() ?? '',
        );
      }

      // Lưu vai trò
      if (user['vaiTro'] != null) {
        await TokenStorage.saveUserRole(user['vaiTro'].toString());
      }

      return data;
    } catch (e) {
      return {
        'error': 'Đăng nhập thất bại',
        'detail': e.toString(),
      };
    }
  }
}
