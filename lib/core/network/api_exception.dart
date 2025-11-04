// import 'package:dio/dio.dart';
//
// class ApiException implements Exception {
//   final String message;
//   final int? statusCode;
//
//   ApiException({required this.message, this.statusCode});
//
//   factory ApiException.fromDioError(DioException e) {
//     String errorMessage = 'Lỗi không xác định';
//     int? code;
//
//     if (e.response != null) {
//       code = e.response?.statusCode;
//       final data = e.response?.data;
//
//       if (data is Map<String, dynamic>) {
//         // Xử lý message an toàn
//         errorMessage = data['message']?.toString() ??
//             data['error']?.toString() ??
//             'Lỗi máy chủ';
//       } else if (data is String) {
//         errorMessage = data;
//       } else {
//         errorMessage = 'Lỗi server không xác định';
//       }
//     } else if (e.type == DioExceptionType.connectionTimeout ||
//         e.type == DioExceptionType.receiveTimeout) {
//       errorMessage = '⏱️ Kết nối tới máy chủ bị gián đoạn';
//     } else if (e.type == DioExceptionType.connectionError) {
//       errorMessage = 'Không thể kết nối tới server';
//     } else {
//       errorMessage = e.message ?? 'Lỗi không xác định';
//     }
//
//     print('❌ [ApiException] code=$code | message=$errorMessage');
//     return ApiException(message: errorMessage, statusCode: code);
//   }
//
//   @override
//   String toString() => 'ApiException($statusCode): $message';
// }
