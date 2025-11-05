import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/phong_daotao/data/datasources/buoihoc_api.dart';
import 'features/phong_daotao/data/repositories/buoihoc_repository.dart';
import 'routes/app_router.dart';
import 'routes/route_names.dart';

// 📦 REPOSITORIES
import 'features/phong_daotao/data/repositories/assign_schedule_repository.dart';
import 'features/phong_daotao/data/repositories/giangvien_repository.dart';
import 'features/phong_daotao/data/repositories/lophocphan_repository.dart';
import 'features/phong_daotao/data/repositories/khoa_repository.dart';

// 🧠 CONTROLLERS
import 'features/phong_daotao/presentation/controllers/pdt_dashboard_controller.dart';
import 'features/phong_daotao/presentation/controllers/mon_hoc_controller.dart';
import 'features/phong_daotao/presentation/controllers/nganh_controller.dart';
import 'features/phong_daotao/presentation/controllers/lop_controller.dart';
import 'features/phong_daotao/presentation/controllers/lophocphan_controller.dart';
import 'features/phong_daotao/presentation/controllers/assign_schedule_controller.dart';
import 'features/phong_daotao/presentation/controllers/giangvien_controller.dart';
import 'features/phong_daotao/presentation/controllers/khoa_controller.dart';

// 📡 API
import 'features/phong_daotao/data/datasources/lophocphan_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FaceAttendanceApp());
}

class FaceAttendanceApp extends StatelessWidget {
  const FaceAttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 📊 Dashboard
        ChangeNotifierProvider(create: (_) => PdtDashboardController()),

        // 📚 Quản lý Ngành, Môn học, Khoa, Lớp, Lớp học phần
        ChangeNotifierProvider(create: (_) => NganhController()),
        ChangeNotifierProvider(create: (_) => MonHocController()),
        ChangeNotifierProvider(create: (_) => LopController()),

        ChangeNotifierProvider(
          create: (_) => LopHocPhanController(
            repository: LopHocPhanRepository(api: LopHocPhanApi()),
          ),
        ),

        // 🏫 Quản lý Khoa
        ChangeNotifierProvider(
          create: (_) => KhoaController(KhoaRepository()),
        ),

        // 🕒 Gán lịch dạy, giảng viên

        ChangeNotifierProvider(
          create: (_) => AssignScheduleController(
            khoaRepo: KhoaRepository(),
            gvRepo: GiangVienRepository(),
            lhpRepo: LopHocPhanRepository(api: LopHocPhanApi()), // 🆕 Thêm dòng này
            buoiHocRepo: BuoiHocRepository(api: BuoiHocApi()),
          ),
        ),


        // (Có thể bật lại sau nếu dùng)
        // ChangeNotifierProvider(create: (_) => BuoiHocController()),
        // ChangeNotifierProvider(create: (_) => SinhVienController()),
        // ChangeNotifierProvider(create: (_) => FaceDataController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Face Attendance System',
        theme: AppTheme.lightTheme,
        routes: appRoutes,
        initialRoute: RouteNames.login,

        // 🌐 Hỗ trợ đa ngôn ngữ (fix lỗi DatePicker)
        locale: const Locale('vi', 'VN'),
        supportedLocales: const [
          Locale('vi', 'VN'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
