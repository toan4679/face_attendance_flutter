import 'package:flutter/material.dart';
import '../../data/models/buoihoc_model.dart';

class KetQuaDiemDanhScreen extends StatelessWidget {
  final BuoiHoc buoiHoc;

  const KetQuaDiemDanhScreen({super.key, required this.buoiHoc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kết quả điểm danh - ${buoiHoc.tenMon}"),
        backgroundColor: const Color(0xFF154B71),
      ),
      body: const Center(
        child: Text(
          "Hiển thị danh sách sinh viên đã điểm danh...",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
