import 'package:flutter/material.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../widgets/gv_side_menu.dart';
import '../../data/models/giangvien_model.dart';

class ThongKeScreen extends StatelessWidget {
  final GiangVien? giangVien;

  const ThongKeScreen({super.key, this.giangVien});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: GVSideMenu(
        giangVienId: giangVien?.maGV.toString() ?? '',
        onClose: () => Navigator.pop(context),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF154B71),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: const Text(
          'Thống kê',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Đây là trang thống kê",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: const GiangVienBottomNav(currentIndex: 4),
    );
  }
}
