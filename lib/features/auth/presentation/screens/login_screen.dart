import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';

const Color primaryPurple = Color(0xFF7853FD);
const Color lightGreyBackground = Color(0xFFF5F5F5);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
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
                // Logo hoặc hình minh họa
                Container(
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/login_illustration.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                const Text('Chào mừng trở lại',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black)),
                const SizedBox(height: 8),
                const Text(
                  'Vui lòng đăng nhập vào tài khoản\nhiện tại của bạn',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                const SizedBox(height: 40),

                // Email
                TextField(
                  controller: _emailCtl,
                  decoration: _inputDecoration(hintText: 'Nhập Email'),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 18),

                // Password
                TextField(
                  controller: _passCtl,
                  obscureText: true,
                  decoration: _inputDecoration(hintText: 'Nhập Password'),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 40),

                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.isLoading
                        ? null
                        : () => auth.login(_emailCtl.text, _passCtl.text, 'admin', context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 8,
                      shadowColor: primaryPurple.withOpacity(0.4),
                    ),
                    child: auth.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Đăng nhập',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Không có tài khoản ? ',
                        style: TextStyle(color: Colors.black54, fontSize: 15)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/register'),
                      child: const Text('Đăng ký',
                          style: TextStyle(
                              color: primaryPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                GestureDetector(
                  onTap: () {},
                  child: const Text('Quên mật khẩu ?',
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
