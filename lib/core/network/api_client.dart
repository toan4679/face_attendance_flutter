import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Accept': 'application/json'},
  ));

  Future<Response> post(String url, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(url, data: data);
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      rethrow;
    }
  }
}
