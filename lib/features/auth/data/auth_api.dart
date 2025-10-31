import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/network/token_storage.dart';
import '../../../core/network/api_exception.dart';
import 'auth_model.dart';

class AuthApi {
  final Dio dio = Dio(BaseOptions(baseUrl: dotenv.env['API_BASE_URL'] ?? ''));

  Future<AuthUser> login({
    required String email,
    required String password,
    required String loai, // admin, pdt, giangvien, sinhvien
  }) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
        'loai': loai,
      });

      final user = AuthUser.fromJson(response.data);
      await TokenStorage.saveToken(user.token);
      return user;
    } on DioError catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String hoTen,
    required String loai, // chỉ áp dụng cho sinh viên hoặc giảng viên
  }) async {
    try {
      await dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'hoTen': hoTen,
        'loai': loai,
      });
    } on DioError catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> logout() async {
    try {
      final token = await TokenStorage.getToken();
      if (token != null) {
        await dio.post(
          '/auth/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }
      await TokenStorage.clear();
    } catch (_) {
      await TokenStorage.clear();
    }
  }
}
