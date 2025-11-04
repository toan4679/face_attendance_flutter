import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'token_storage.dart';

class ApiClient {
  // Singleton instance
  static final ApiClient instance = ApiClient._internal();

  late Dio dio;

  ApiClient._internal() {
    final options = BaseOptions(
      baseUrl: ApiConstants.baseUrl, // ví dụ: http://104.145.210.69/api
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    );

    dio = Dio(options);

    // Thêm interceptor để tự động gắn token khi có
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenStorage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        // Debug lỗi chi tiết
        print('❌ API ERROR: ${e.response?.statusCode} ${e.response?.data}');
        return handler.next(e);
      },
    ));
  }
}
