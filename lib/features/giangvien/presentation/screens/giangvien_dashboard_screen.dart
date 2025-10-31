import 'package:flutter/material.dart';

class GiangVienDashboardScreen extends StatelessWidget {
  const GiangVienDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giảng viên Dashboard')),
      body: const Center(
        child: Text(
          'Chào mừng Giảng viên 👨‍🏫',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
