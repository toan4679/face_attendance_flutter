import 'package:flutter/material.dart';

// AUTH
import 'package:face_attendance_flutter/features/auth/presentation/screens/login_screen.dart';
import 'package:face_attendance_flutter/features/auth/presentation/screens/register_screen.dart';

// ADMIN
import 'package:face_attendance_flutter/features/admin/presentation/screens/admin_dashboard_screen.dart';

// GIẢNG VIÊN
import 'package:face_attendance_flutter/features/giangvien/presentation/screens/giangvien_dashboard_screen.dart';

// SINH VIÊN
import 'package:face_attendance_flutter/features/sinhvien/presentation/screens/sinhvien_dashboard_screen.dart';

// 📦 ROUTES PHÒNG ĐÀO TẠO
import 'package:face_attendance_flutter/features/phong_daotao/pdt_routes.dart';

// ============================================================
// ============= DANH SÁCH ROUTES TOÀN ỨNG DỤNG ===============
// ============================================================

final Map<String, WidgetBuilder> baseRoutes = {
  // ==== AUTH ====
  '/login': (_) => const LoginScreen(),
  '/register': (_) => const RegisterScreen(),

  // ==== ADMIN ====
  '/admin_dashboard': (_) => const AdminDashboardScreen(),

  // ==== GIẢNG VIÊN ====
  '/giangvien_dashboard': (_) => const GiangVienDashboardScreen(),

  // ==== SINH VIÊN ====
  '/sinhvien_dashboard': (_) => const SinhVienDashboardScreen(),
};

Map<String, WidgetBuilder> get appRoutes => {
  ...baseRoutes,
  ...pdtRoutes,
};
