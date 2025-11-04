import 'package:flutter/material.dart';
import 'package:face_attendance_flutter/features/auth/presentation/screens/login_screen.dart';
import 'package:face_attendance_flutter/features/auth/presentation/screens/register_screen.dart';
import 'package:face_attendance_flutter/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/pdt_dashboard_screen.dart';
import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/manage_nganh_screen.dart';
import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/manage_monhoc_screen.dart';
import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/manage_lop_screen.dart';
// import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/manage_lophocphan_screen.dart';
// import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/manage_buoihoc_screen.dart';
// import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/assign_schedule_screen.dart';
// import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/manage_sinhvien_screen.dart';
// import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/manage_face_data_screen.dart';
import 'package:face_attendance_flutter/features/giangvien/presentation/screens/giangvien_dashboard_screen.dart';
import 'package:face_attendance_flutter/features/sinhvien/presentation/screens/sinhvien_dashboard_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (_) => const LoginScreen(),
  '/register': (_) => const RegisterScreen(),
  '/admin_dashboard': (_) => const AdminDashboardScreen(),
  '/pdt_dashboard': (_) => const PdtDashboardScreen(),
  '/pdt/nganh': (_) => const ManageNganhScreen(),
  '/pdt/monhoc': (_) => const ManageMonHocScreen(),
  '/pdt/lop': (_) => const ManageLopScreen(),
  // '/pdt/lophocphan': (_) => const ManageLopHocPhanScreen(),
  // '/pdt/buoihoc': (_) => const ManageBuoiHocScreen(),
  // '/pdt/assign_schedule': (_) => const AssignScheduleScreen(),
  // '/pdt/sinhvien': (_) => const ManageSinhVienScreen(),
  // '/pdt/face_data': (_) => const ManageFaceDataScreen(),
  '/giangvien_dashboard': (_) => const GiangVienDashboardScreen(),
  '/sinhvien_dashboard': (_) => const SinhVienDashboardScreen(),
};
