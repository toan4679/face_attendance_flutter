import 'package:flutter/material.dart';
import '../../data/models/giangvien_model.dart';

class EditProfileForm extends StatelessWidget {
  final GiangVien giangVien;

  const EditProfileForm({super.key, required this.giangVien});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
    TextEditingController(text: giangVien.hoTen);
    final TextEditingController emailController =
    TextEditingController(text: giangVien.email);
    final TextEditingController phoneController =
    TextEditingController(text: giangVien.soDienThoai ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa hồ sơ"),
        backgroundColor: const Color(0xFF154B71),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Họ tên")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Số điện thoại")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đã lưu thay đổi (mock)")),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF154B71)),
              child: const Text("Lưu thay đổi"),
            ),
          ],
        ),
      ),
    );
  }
}
