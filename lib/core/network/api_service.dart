import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:face_attendance_flutter/core/network/token_storage.dart';

class ApiService {
  static const String baseUrl = "http://104.145.210.69/api/v1";
  final Dio _dio = Dio();

  ApiService() {
    _dio.options
      ..baseUrl = baseUrl
      ..connectTimeout = const Duration(seconds: 10)
      ..receiveTimeout = const Duration(seconds: 10)
      ..headers = {'Accept': 'application/json'};
  }

  /// Luôn bắt đầu bằng "/"
  String _normalize(String endpoint) {
    if (endpoint.startsWith('http://') || endpoint.startsWith('https://')) {
      return endpoint;
    }
    return endpoint.startsWith('/') ? endpoint : '/$endpoint';
  }

  Future<String?> _getToken() async {
    final token = await TokenStorage.getToken(); // ✅ flutter_secure_storage
    return (token != null && token.isNotEmpty) ? token : null;
  }

  Map<String, String> _headers(String? token, {bool isJson = true}) {
    final h = <String, String>{'Accept': 'application/json'};
    if (isJson) h['Content-Type'] = 'application/json';
    if (token != null) h['Authorization'] = 'Bearer $token'; // ✅ chỉ gắn khi có
    return h;
  }

  void _logReq(String method, String url, String? token) {
    final short = (token == null || token.isEmpty) ? '(no token)' : '${token.substring(0, 8)}…';
    debugPrint('➡️ $method $url | token=$short');
  }

  /// GET
  Future<dynamic> get(String endpoint) async {
    final url = _normalize(endpoint);
    try {
      final token = await _getToken();
      _logReq('GET', '${_dio.options.baseUrl}$url', token);
      final res = await _dio.get(url, options: Options(headers: _headers(token)));
      return res.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  /// POST (JSON hoặc FormData)
  Future<dynamic> post(String endpoint, dynamic data) async {
    final url = _normalize(endpoint);
    try {
      final token = await _getToken();
      final isForm = data is FormData;
      _logReq('POST', '${_dio.options.baseUrl}$url', token);

      final res = await _dio.post(
        url,
        data: isForm ? data : jsonEncode(data),
        options: Options(headers: _headers(token, isJson: !isForm)),
      );
      return res.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  /// PUT
  Future<dynamic> put(String endpoint, dynamic data) async {
    final url = _normalize(endpoint);
    try {
      final token = await _getToken();
      _logReq('PUT', '${_dio.options.baseUrl}$url', token);
      final res = await _dio.put(
        url,
        data: jsonEncode(data),
        options: Options(headers: _headers(token)),
      );
      return res.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  /// DELETE
  Future<dynamic> delete(String endpoint) async {
    final url = _normalize(endpoint);
    try {
      final token = await _getToken();
      _logReq('DELETE', '${_dio.options.baseUrl}$url', token);
      final res = await _dio.delete(url, options: Options(headers: _headers(token)));
      return res.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  /// UPLOAD (multipart)
  Future<dynamic> upload(String endpoint, FormData formData) async {
    final url = _normalize(endpoint);
    try {
      final token = await _getToken();
      _logReq('UPLOAD', '${_dio.options.baseUrl}$url', token);
      final res = await _dio.post(
        url,
        data: formData,
        options: Options(headers: _headers(token, isJson: false)),
      );
      return res.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  void _handleError(DioException e) {
    String message = "Lỗi không xác định";
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map && data['message'] is String) {
        message = data['message'];
      } else {
        message = "HTTP ${e.response?.statusCode}: ${e.response?.statusMessage}";
      }
    } else if (e.type == DioExceptionType.connectionTimeout) {
      message = "⏱️ Kết nối server quá lâu.";
    } else if (e.type == DioExceptionType.badResponse) {
      message = "💥 Phản hồi không hợp lệ từ server.";
    } else {
      message = "⚠️ ${e.message}";
    }
    debugPrint('❌ API Error: $message');
    throw Exception(message);
  }
}
