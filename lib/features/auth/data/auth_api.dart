// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:face_attendance_flutter/core/constants/api_endpoints.dart';
// import 'package:face_attendance_flutter/core/network/token_storage.dart';
// import 'package:face_attendance_flutter/core/network/api_exception.dart';
// import 'auth_model.dart';
//
// class AuthApi {
//   final Dio _dio = Dio(BaseOptions(
//     baseUrl: ApiEndpoints.baseUrl,
//     headers: {'Accept': 'application/json'},
//   ));
//
//   // ===================== ĐĂNG NHẬP =====================
//   Future<AuthUser> login({
//     required String email,
//     required String password,
//     required String loai,
//   }) async {
//     try {
//       print('🚀 [DEBUG] Gửi yêu cầu đăng nhập tới ${ApiEndpoints.login}');
//       print('📧 Email: $email | Loại tài khoản: $loai');
//
//       final response = await _dio.post(
//         ApiEndpoints.login,
//         data: {'email': email, 'password': password, 'loai': loai},
//       );
//
//       // 🔍 In phản hồi thô để debug
//       print('📦 [DEBUG] Raw response data: ${response.data}');
//
//       final decoded = response.data is String
//           ? jsonDecode(response.data)
//           : response.data;
//
//       print('📦 [DEBUG] Phản hồi JSON sau decode: $decoded');
//
// // ✅ Lưu token từ field "token"
//       final token = decoded['token'];
//       if (token != null && token.isNotEmpty) {
//         await TokenStorage.saveAccessToken(token);
//         print('💾 [DEBUG] Đã lưu token: $token');
//       } else {
//         print('⚠️ [WARN] Không có token trong phản hồi!');
//       }
//
//       if (token != null && token.isNotEmpty) {
//         print('🔑 [DEBUG] Token nhận được: $token');
//         await TokenStorage.saveAccessToken(token);
//         print('💾 [DEBUG] Token đã được lưu thành công.');
//       } else {
//         print('⚠️ [WARN] Không tìm thấy token trong phản hồi backend!');
//       }
//
//       // ✅ Parse dữ liệu user nếu có
//       final user = AuthUser.fromJson(decoded);
//       return user;
//     } on DioException catch (e) {
//       print('❌ [ERROR] Login thất bại: ${e.message}');
//       print('📄 [DETAILS] ${e.response?.data}');
//       throw ApiException.fromDioError(e);
//     } catch (e, st) {
//       print('❌ [ERROR] Ngoại lệ không xác định: $e');
//       print('📄 [STACKTRACE] $st');
//       rethrow;
//     }
//   }
//
//   // ===================== ĐĂNG KÝ =====================
//   Future<void> register({
//     required String email,
//     required String password,
//     required String hoTen,
//     required String loai,
//   }) async {
//     try {
//       print('📝 [DEBUG] Gửi yêu cầu đăng ký...');
//       final response = await _dio.post(
//         ApiEndpoints.register,
//         data: {
//           'email': email,
//           'password': password,
//           'hoTen': hoTen,
//           'loai': loai,
//         },
//       );
//       print('✅ [DEBUG] Đăng ký thành công: ${response.statusCode}');
//     } on DioException catch (e) {
//       print('❌ [ERROR] Đăng ký thất bại: ${e.message}');
//       print('📄 [DETAILS] ${e.response?.data}');
//       throw ApiException.fromDioError(e);
//     }
//   }
//
//   // ===================== ĐĂNG XUẤT =====================
//   Future<void> logout() async {
//     try {
//       final token = await TokenStorage.getAccessToken();
//       print('🔑 [DEBUG] Đăng xuất với token: $token');
//
//       if (token != null && token.isNotEmpty) {
//         await _dio.post(
//           ApiEndpoints.logout,
//           options: Options(
//             headers: {
//               'Authorization': 'Bearer $token',
//               'Accept': 'application/json',
//             },
//           ),
//         );
//         print('✅ [DEBUG] Logout API gọi thành công.');
//       }
//
//       await TokenStorage.clearTokens();
//       print('🧹 [DEBUG] Token đã được xóa khỏi storage.');
//     } catch (e, st) {
//       print('⚠️ [WARN] Lỗi trong quá trình logout: $e');
//       print('📄 [STACKTRACE] $st');
//       await TokenStorage.clearTokens();
//     }
//   }
// }
