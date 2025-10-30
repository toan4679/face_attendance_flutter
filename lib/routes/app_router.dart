import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import các màn hình đầu tiên
import '../features/splash/splash_screen.dart';
import '../features/auth/presentation/login_screen.dart';

// TODO: Import thêm route của các module khác sau (admin, pdt, gv, sv)

final GoRouter appRouter = GoRouter(
  initialLocation: '/', // đường dẫn mặc định khi khởi chạy app
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Không tìm thấy trang: ${state.error}'),
    ),
  ),
);
