import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';

const Color primaryPurple = Color(0xFF7853FD);
const Color lightGreyBackground = Color(0xFFF5F5F5);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _confirmCtl = TextEditingController();
  String selectedRole = 'giangvien';

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _passCtl.dispose();
    _confirmCtl.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: primaryPurple, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: lightGreyBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/register_illustration.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                const Text('Tạo tài khoản mới',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black)),
                const SizedBox(height: 8),
                const Text(
                  'Vui lòng điền thông tin để đăng ký tài khoản',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                const SizedBox(height: 40),

                TextField(controller: _nameCtl, decoration: _inputDecoration(hintText: 'Họ và tên')),
                const SizedBox(height: 18),
                TextField(controller: _emailCtl, decoration: _inputDecoration(hintText: 'Email')),
                const SizedBox(height: 18),
                TextField(
                  controller: _passCtl,
                  obscureText: true,
                  decoration: _inputDecoration(hintText: 'Mật khẩu'),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _confirmCtl,
                  obscureText: true,
                  decoration: _inputDecoration(hintText: 'Xác nhận mật khẩu'),
                ),
                const SizedBox(height: 18),

                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: _inputDecoration(hintText: 'Chọn loại tài khoản'),
                  items: const [
                    DropdownMenuItem(value: 'giangvien', child: Text('Giảng viên')),
                    DropdownMenuItem(value: 'sinhvien', child: Text('Sinh viên')),
                  ],
                  onChanged: (value) => setState(() => selectedRole = value!),
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.isLoading
                        ? null
                        : () => auth.register(
                      _nameCtl.text,
                      _emailCtl.text,
                      _passCtl.text,
                      _confirmCtl.text,
                      selectedRole,
                      context,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 8,
                      shadowColor: primaryPurple.withOpacity(0.4),
                    ),
                    child: auth.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Đăng ký',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Đã có tài khoản? ', style: TextStyle(color: Colors.black54, fontSize: 15)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('Đăng nhập',
                          style: TextStyle(color: primaryPurple, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
