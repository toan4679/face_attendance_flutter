import 'package:flutter/material.dart';
import '../../presentation/controllers/giangvien_controller.dart';
import '../../data/models/giangvien_model.dart';
import '../screens/giangvien_dashboard_screen.dart';
import '../screens/diemdanh_screen.dart';
import '../screens/lichday_screen.dart';
import '../screens/quanlylop_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/thongke_screen.dart';

class GiangVienBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const GiangVienBottomNav({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  State<GiangVienBottomNav> createState() => _GiangVienBottomNavState();
}

class _GiangVienBottomNavState extends State<GiangVienBottomNav> {
  void _handleTap(int index) {
    widget.onTap?.call(index);

    // Lấy giảng viên hiện tại từ controller
    final GiangVien? gv = GiangVienController().currentGiangVien;

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = const GiangVienDashboardScreen();
        break;
      case 1:
        nextScreen = LichDayScreen(giangVien: gv);
        break;
      case 2:
        nextScreen = const DiemDanhScreen();
        break;
      case 3:
        nextScreen = QuanLyLopScreen(giangVien: gv);
        break;
      case 4:
        nextScreen = const ProfileScreen();
        break;
      default:
        nextScreen = const GiangVienDashboardScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      selectedItemColor: const Color(0xFF154B71),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: _handleTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Lịch dạy',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_2, size: 32),
          label: 'Điểm danh',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'QL Lớp',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Tôi',
        ),
      ],
    );
  }
}
