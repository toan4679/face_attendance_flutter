import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class TestLoginPage extends StatefulWidget {
  const TestLoginPage({super.key});

  @override
  State<TestLoginPage> createState() => _TestLoginPageState();
}

class _TestLoginPageState extends State<TestLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole = 'admin'; // admin, pdt, giangvien, sinhvien
  bool _loading = false;
  String _response = '';

  Future<void> _testLogin() async {
    setState(() {
      _loading = true;
      _response = '';
    });

    final String baseUrl = dotenv.env['API_BASE_URL'] ?? ''; // ✅ FIXED
    final Dio dio = Dio(BaseOptions(baseUrl: baseUrl));

    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
          'loai': _selectedRole,
        },
      );

      setState(() {
        _response =
        '✅ Đăng nhập thành công!\n\nToken:\n${response.data['token']}\n\nTên: ${response.data['user']['hoTen']}\nVai trò: ${response.data['user']['vaiTro']}';
      });
    } on DioException catch (e) {
      final msg = e.response?.data.toString() ?? e.message ?? 'Lỗi không xác định';
      setState(() => _response = '❌ Lỗi khi đăng nhập: $msg');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Login API Laravel')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nhập thông tin tài khoản để kiểm tra kết nối:'),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mật khẩu'),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedRole,
              items: const [
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
                DropdownMenuItem(value: 'pdt', child: Text('Phòng Đào Tạo')),
                DropdownMenuItem(value: 'giangvien', child: Text('Giảng viên')),
                DropdownMenuItem(value: 'sinhvien', child: Text('Sinh viên')),
              ],
              onChanged: (value) => setState(() => _selectedRole = value),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _testLogin,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Gửi yêu cầu đăng nhập'),
            ),
            const SizedBox(height: 30),
            const Text('Kết quả:'),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _response,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
