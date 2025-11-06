import 'package:flutter/material.dart';
import 'presentation/screens/giangvien_dashboard_screen.dart';
import 'presentation/screens/diemdanh_screen.dart';
import 'presentation/screens/diemdanh_qr_screen.dart';
import 'presentation/screens/lichday_screen.dart';
import 'presentation/screens/quanlylop_screen.dart';
import 'presentation/screens/profile_screen.dart';
import 'presentation/screens/thongke_screen.dart';
import 'presentation/screens/doi_mat_khau_screen.dart';
import 'data/models/buoihoc_model.dart';

class GvRoutes {
  static const String dashboard = '/giangvien/dashboard';
  static const String diemdanh = '/giangvien/diemdanh';
  static const String diemdanhQR = '/giangvien/diemdanh_qr';
  static const String lichday = '/giangvien/lichday';
  static const String quanlylop = '/giangvien/quanlylop';
  static const String profile = '/giangvien/profile';
  static const String thongke = '/giangvien/thongke';
  static const String doiMatKhau = '/giangvien/doi_mat_khau';

  static Map<String, WidgetBuilder> staticRoutes = {
    dashboard: (_) => const GiangVienDashboardScreen(),
    diemdanh: (_) => const DiemDanhScreen(),
    lichday: (_) => const LichDayScreen(giangVienId: 'GV001'),
    quanlylop: (_) => const QuanLyLopScreen(giangVienId: 'GV001'),
    profile: (_) => const ProfileScreen(giangVienId: 'GV001'),
    thongke: (_) => const ThongKeScreen(giangVienId: 'GV001'),
    doiMatKhau: (_) => const DoiMatKhauScreen(giangVienId: 'GV001'),
  };

  static void navigate(BuildContext context, String route,
      {Map<String, dynamic>? arguments}) {
    // Dùng postFrameCallback để chắc Drawer đã đóng
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (route == diemdanhQR) {
        final BuoiHoc? buoiHoc = arguments?['buoiHoc'];
        if (buoiHoc != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DiemDanhQRScreen(buoiHoc: buoiHoc),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Không tìm thấy buổi học để điểm danh!")),
          );
        }
      } else if (route == doiMatKhau) {
        final giangVienId = arguments?['giangVienId'] ?? 'GV001';
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoiMatKhauScreen(giangVienId: giangVienId),
          ),
        );
      } else if (staticRoutes.containsKey(route)) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: staticRoutes[route]!),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GiangVienDashboardScreen()),
        );
      }
    });
  }
}
