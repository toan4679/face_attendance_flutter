import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:face_attendance_flutter/core/network/api_constants.dart';
import 'package:face_attendance_flutter/core/network/token_storage.dart';
import 'package:face_attendance_flutter/routes/route_names.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  bool _isLoading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _dio.post(
        '/v1/auth/login',
        data: {
          'email': _emailController.text.trim(),
          'matKhau': _passwordController.text.trim(),
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data['token'] != null) {
        await TokenStorage.saveToken(response.data['token']);
        final role = response.data['role'] ?? response.data['user']['vaiTro'] ?? 'pdt';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thành công (${role.toUpperCase()})')),
        );

        // ✅ Route theo vai trò
        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, RouteNames.adminDashboard);
        } else if (role == 'pdt') {
          Navigator.pushReplacementNamed(context, RouteNames.pdtDashboard);
        } else if (role == 'giangvien') {
          Navigator.pushReplacementNamed(context, RouteNames.giangvienDashboard);
        } else if (role == 'sinhvien') {
          Navigator.pushReplacementNamed(context, RouteNames.sinhvienDashboard);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Không xác định vai trò người dùng')),
          );
        }
      } else {
        _error = 'Phản hồi không hợp lệ từ server';
      }
    } on DioException catch (e) {
      setState(() {
        _error = e.response?.data['error']?['message'] ??
            'Đăng nhập thất bại (${e.response?.statusCode})';
      });
    } catch (e) {
      _error = 'Lỗi không xác định: $e';
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Đăng nhập hệ thống',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),

                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Đăng nhập'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, RouteNames.register);
                    },
                    child: const Text('Chưa có tài khoản? Đăng ký ngay'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
