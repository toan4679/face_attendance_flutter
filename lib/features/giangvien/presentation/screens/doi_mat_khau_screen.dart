import 'package:flutter/material.dart';

class DoiMatKhauScreen extends StatelessWidget {
  final String giangVienId;
  const DoiMatKhauScreen({super.key, required this.giangVienId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đổi mật khẩu"),
        backgroundColor: const Color(0xFF154B71),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mật khẩu hiện tại",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mật khẩu mới",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Xác nhận mật khẩu mới",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đổi mật khẩu thành công!")),
                  );
                  Navigator.pop(context);
                },
                child: const Text("Xác nhận"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
