import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ROUTES
import 'routes/app_router.dart';
import 'routes/route_names.dart';

// CONTROLLERS
import 'features/phong_daotao/presentation/controllers/pdt_dashboard_controller.dart';
import 'features/phong_daotao/presentation/controllers/mon_hoc_controller.dart';


// SCREENS
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/phong_daotao/presentation/screens/pdt_dashboard_screen.dart';

// THEME
import 'core/theme/app_theme.dart';

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
        ChangeNotifierProvider(create: (_) => MonHocController()),
        // bạn có thể thêm các Provider khác sau này như AuthController, AdminController...
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Face Attendance System',
        theme: AppTheme.lightTheme, // tạo trong core/theme/app_theme.dart
        routes: appRoutes,
        initialRoute: RouteNames.login, // Mặc định mở Login
        // Nếu bạn muốn test trực tiếp dashboard, dùng:
        // home: const PdtDashboardScreen(),
      ),
    );
  }
}
