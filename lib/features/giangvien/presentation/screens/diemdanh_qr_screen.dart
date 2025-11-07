import 'package:flutter/material.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../widgets/gv_side_menu.dart';
import '../../data/models/giangvien_model.dart';

class DiemDanhQRScreen extends StatelessWidget {
  final GiangVien? giangVien;

  const DiemDanhQRScreen({super.key, this.giangVien});

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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            const Spacer(),
            const Text(
              'Điểm danh QR',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          "Đây là trang DiemDanhQR",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: const GiangVienBottomNav(currentIndex: 2),
    );
  }
}
