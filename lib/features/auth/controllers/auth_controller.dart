import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:face_attendance_flutter/core/network/api_client.dart';
import 'package:face_attendance_flutter/core/network/api_constants.dart';

class AuthController with ChangeNotifier {
  final ApiClient _api = ApiClient();
  final _storage = const FlutterSecureStorage();

  bool isLoading = false;

  Future<bool> login(String email, String password, String role, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final res = await _api.post(ApiConstants.login, {
      'email': email,
      'matKhau': password,
      'loai': role,
    });

    isLoading = false;
    notifyListeners();

    if (res.statusCode == 200 && res.data['token'] != null) {
      await _storage.write(key: 'token', value: res.data['token']);
      await _storage.write(key: 'role', value: role);

      // Điều hướng theo role
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
      }
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sai tài khoản hoặc mật khẩu')),
      );
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, String confirmPassword, String role, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final res = await _api.post(ApiConstants.register, {
      'hoTen': name,
      'email': email,
      'matKhau': password,
      'matKhau_confirmation': confirmPassword,
      'loai': role,
    });

    isLoading = false;
    notifyListeners();

    if (res.statusCode == 201) {
      // Hiển thị dialog thành công
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Thành công'),
          content: const Text('Đăng ký tài khoản thành công!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Đóng dialog
                Navigator.pop(context); // Quay về trang login
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thất bại')),
      );
      return false;
    }
  }
}
