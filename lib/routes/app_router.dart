import 'package:flutter/material.dart';

// AUTH
import 'package:face_attendance_flutter/features/auth/presentation/screens/login_screen.dart';
import 'package:face_attendance_flutter/features/auth/presentation/screens/register_screen.dart';

// ADMIN
import 'package:face_attendance_flutter/features/admin/presentation/screens/admin_dashboard_screen.dart';

// PHÒNG ĐÀO TẠO
import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/pdt_dashboard_screen.dart';
import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/manage_nganh_screen.dart';
import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/manage_monhoc_screen.dart';
import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/manage_lop_screen.dart';
import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/manage_lophocphan_screen.dart';
import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/manage_buoihoc_screen.dart';
import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/assign_schedule_screen.dart';
// import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/manage_sinhvien_screen.dart';
// import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/manage_face_data_screen.dart';

// GIẢNG VIÊN
import 'package:face_attendance_flutter/features/giangvien/presentation/screens/giangvien_dashboard_screen.dart';

// SINH VIÊN
import 'package:face_attendance_flutter/features/sinhvien/presentation/screens/sinhvien_dashboard_screen.dart';

import '../features/phong_daotao/data/models/giangvien_model.dart';
import '../features/phong_daotao/presentation/screens/manage_khoa_screen.dart';

// ============================================================
// ============= DANH SÁCH ROUTES TOÀN ỨNG DỤNG ===============
// ============================================================

final Map<String, WidgetBuilder> appRoutes = {
  // ==== AUTH ====
  '/login': (_) => const LoginScreen(),
  '/register': (_) => const RegisterScreen(),

  // ==== ADMIN ====
  '/admin_dashboard': (_) => const AdminDashboardScreen(),

  // ==== PHÒNG ĐÀO TẠO ====
  '/pdt_dashboard': (_) => const PdtDashboardScreen(),
  '/pdt/khoa': (context) => const ManageKhoaScreen(),
  '/pdt/nganh': (_) => const ManageNganhScreen(),
  '/pdt/monhoc': (_) => const ManageMonHocScreen(),
  '/pdt/lop': (_) => const ManageLopScreen(),
  '/pdt/lophocphan': (_) => const ManageLopHocPhanScreen(),
  '/pdt/buoihoc': (_) => const ManageBuoiHocScreen(),
  '/pdt/assign_schedule': (_) => const AssignScheduleScreen(),
  // '/pdt/face_data': (_) => const ManageFaceDataScreen(),

  // ==== GIẢNG VIÊN ====
  '/giangvien_dashboard': (_) => const GiangVienDashboardScreen(),

  // ==== SINH VIÊN ====
  '/sinhvien_dashboard': (_) => const SinhVienDashboardScreen(),
};
