import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:face_attendance_flutter/core/network/api_constants.dart';
import 'package:face_attendance_flutter/routes/route_names.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  bool _isLoading = false;
  String? _error;
  String _selectedRole = 'giangvien'; // mặc định

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    if (_passwordController.text != _confirmController.text) {
      setState(() {
        _isLoading = false;
        _error = 'Mật khẩu xác nhận không khớp';
      });
      return;
    }

    try {
      final response = await _dio.post(
        '/v1/auth/register',
        data: {
          'loai': _selectedRole,
          'hoTen': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'matKhau': _passwordController.text.trim(),
          'matKhau_confirmation': _passwordController.text.trim(),
        },
        options: Options(headers: {'Accept': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công! Hãy đăng nhập.')),
        );
        Navigator.pushReplacementNamed(context, RouteNames.login);
      } else {
        _error = 'Phản hồi không hợp lệ từ server';
      }
    } on DioException catch (e) {
      setState(() {
        _error = e.response?.data['error']?.toString() ??
            'Đăng ký thất bại (${e.response?.statusCode})';
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
                    'Đăng ký tài khoản',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // 🔽 Dropdown chọn loại tài khoản
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Loại tài khoản',
                      prefixIcon: Icon(Icons.account_circle_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'giangvien', child: Text('Giảng viên')),
                      DropdownMenuItem(value: 'sinhvien', child: Text('Sinh viên')),
                    ],
                    onChanged: (val) => setState(() => _selectedRole = val!),
                  ),

                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Họ và tên',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  TextField(
                    controller: _confirmController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Xác nhận mật khẩu',
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
                    onPressed: _isLoading ? null : _register,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Đăng ký'),
                  ),

                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, RouteNames.login);
                    },
                    child: const Text('Đã có tài khoản? Đăng nhập'),
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
