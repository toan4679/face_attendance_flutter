import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';
import 'routes/route_names.dart';

// CONTROLLERS
import 'features/phong_daotao/presentation/controllers/pdt_dashboard_controller.dart';
import 'features/phong_daotao/presentation/controllers/mon_hoc_controller.dart';
import 'features/phong_daotao/presentation/controllers/nganh_controller.dart';
import 'features/phong_daotao/presentation/controllers/lop_controller.dart';
// import 'features/phong_daotao/presentation/controllers/lophocphan_controller.dart';
// import 'features/phong_daotao/presentation/controllers/buoihoc_controller.dart';
// import 'features/phong_daotao/presentation/controllers/sinhvien_controller.dart';
// import 'features/phong_daotao/presentation/controllers/face_data_controller.dart';

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
        ChangeNotifierProvider(create: (_) => PdtDashboardController()),
        ChangeNotifierProvider(create: (_) => NganhController()),
        ChangeNotifierProvider(create: (_) => MonHocController()),
        ChangeNotifierProvider(create: (_) => LopController()),
        // ChangeNotifierProvider(create: (_) => LopHocPhanController()),
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
      ),
    );
  }
}
