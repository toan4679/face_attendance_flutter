import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:face_attendance_flutter/features/auth/controllers/auth_controller.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const FaceAttendanceApp());
}

class FaceAttendanceApp extends StatelessWidget {
  const FaceAttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Face Attendance',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/login',
        routes: appRoutes,
      ),
    );
  }
}
