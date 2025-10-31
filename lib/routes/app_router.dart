import 'package:flutter/material.dart';
import 'package:face_attendance_flutter/features/auth/presentation/screens/login_screen.dart';
import 'package:face_attendance_flutter/features/auth/presentation/screens/register_screen.dart';
import 'package:face_attendance_flutter/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/pdt_dashboard_screen.dart';
import 'package:face_attendance_flutter/features/giangvien/presentation/screens/giangvien_dashboard_screen.dart';
import 'package:face_attendance_flutter/features/sinhvien/presentation/screens/sinhvien_dashboard_screen.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/login': (_) => const LoginScreen(),
  '/register': (_) => const RegisterScreen(),
  '/admin_dashboard': (_) => const AdminDashboardScreen(),
  '/pdt_dashboard': (_) => const PDTDashboardScreen(),
  '/giangvien_dashboard': (_) => const GiangVienDashboardScreen(),
  '/sinhvien_dashboard': (_) => const SinhVienDashboardScreen(),
};
