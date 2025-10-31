import 'package:flutter/material.dart';

class SinhVienDashboardScreen extends StatelessWidget {
  const SinhVienDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sinh viên Dashboard')),
      body: const Center(
        child: Text(
          'Chào mừng Sinh viên 🎓',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
