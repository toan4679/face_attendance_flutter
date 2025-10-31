import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:face_attendance_flutter/core/network/api_constants.dart';

class AuthController with ChangeNotifier {
  final Dio _dio = Dio();
  final _storage = const FlutterSecureStorage();

  bool isLoading = false;

  Future<bool> login(String email, String password, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await _dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'matKhau': password,
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      isLoading = false;
      notifyListeners();

      if (res.statusCode == 200 && res.data['token'] != null) {
        final data = res.data;
        final token = data['token'];
        final role = data['user']['vaiTro'];

        await _storage.write(key: 'token', value: token);
        await _storage.write(key: 'role', value: role);

        // ✅ Điều hướng theo role trả về từ backend
        switch (role) {
          case 'admin':
            Navigator.pushReplacementNamed(context, '/admin_dashboard');
            break;
          case 'pdt':
            Navigator.pushReplacementNamed(context, '/pdt_dashboard');
            break;
          case 'giangvien':
            Navigator.pushReplacementNamed(context, '/giangvien_dashboard');
            break;
          case 'sinhvien':
            Navigator.pushReplacementNamed(context, '/sinhvien_dashboard');
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Role không hợp lệ')),
            );
        }
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sai tài khoản hoặc mật khẩu')),
        );
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đăng nhập: ${e.toString()}')),
      );
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, String confirmPassword, String role, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await _dio.post(
        ApiConstants.register,
        data: {
          'hoTen': name,
          'email': email,
          'matKhau': password,
          'matKhau_confirmation': confirmPassword,
          'loai': role,
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      isLoading = false;
      notifyListeners();

      if (res.statusCode == 201) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Thành công'),
            content: const Text('Đăng ký tài khoản thành công!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng ký thất bại')),
        );
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đăng ký: ${e.toString()}')),
      );
      return false;
    }
  }
}
