import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  factory ApiException.fromDioError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectionTimeout:
        return ApiException('Không thể kết nối đến máy chủ', 408);
      case DioErrorType.receiveTimeout:
        return ApiException('Máy chủ phản hồi quá chậm', 504);
      case DioErrorType.badResponse:
        final msg = error.response?.data['error']?['message'] ??
            'Lỗi máy chủ (${error.response?.statusCode})';
        return ApiException(msg, error.response?.statusCode);
      default:
        return ApiException('Đã xảy ra lỗi không xác định');
    }
  }

  @override
  String toString() => message;
}
