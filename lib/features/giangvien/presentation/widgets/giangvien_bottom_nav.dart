import 'package:flutter/material.dart';
import '../screens/diemdanh_qr_screen.dart';
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
    // Nếu có callback truyền từ bên ngoài → gọi lại
    widget.onTap?.call(index);

    // Điều hướng đến trang tương ứng
    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = const GiangVienDashboardScreen();
        break;
      case 1:
        nextScreen = const LichDayScreen(giangVienId: 'GV001');
        break;
      case 2:
        nextScreen = const DiemDanhScreen();
        break;
      case 3:
        nextScreen = const QuanLyLopScreen(giangVienId: 'GV001');
        break;
      case 4:
        nextScreen = const ProfileScreen(giangVienId: 'GV001');
        break;
      default:
        nextScreen = const GiangVienDashboardScreen();
    }

    // Chuyển trang mà không tạo chồng màn hình
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
