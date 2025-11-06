import 'package:flutter/material.dart';

// ==================== IMPORT CÁC MÀN HÌNH PDT ====================
import 'presentation/screens/pdt_dashboard_screen.dart';
import 'presentation/screens/manage_khoa_screen.dart';
import 'presentation/screens/manage_nganh_screen.dart';
import 'presentation/screens/manage_monhoc_screen.dart';
import 'presentation/screens/manage_lop_screen.dart';
import 'presentation/screens/manage_lophocphan_screen.dart';
import 'presentation/screens/manage_buoihoc_screen.dart';
import 'presentation/screens/assign_schedule_screen.dart';
import 'presentation/screens/manage_khuonmat_screen.dart';

// ==================== ROUTES CHO PHÒNG ĐÀO TẠO ====================

final Map<String, WidgetBuilder> pdtRoutes = {
  '/pdt_dashboard': (_) => const PdtDashboardScreen(),
  '/pdt/khoa': (_) => const ManageKhoaScreen(),
  '/pdt/nganh': (_) => const ManageNganhScreen(),
  '/pdt/monhoc': (_) => const ManageMonHocScreen(),
  '/pdt/lop': (_) => const ManageLopScreen(),
  '/pdt/lophocphan': (_) => const ManageLopHocPhanScreen(),
  '/pdt/buoihoc': (_) => const ManageBuoiHocScreen(),
  '/pdt/assign_schedule': (_) => const AssignScheduleScreen(),

  // 🆕 Màn hình quản lý ảnh sinh viên
  '/pdt/khuonmat': (_) => const ManageKhuonMatScreen(),
};
