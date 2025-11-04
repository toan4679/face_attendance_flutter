import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "http://104.145.210.69/api"; // ⚙️ VPS Laravel backend URL
  final Dio _dio = Dio();

  ApiService() {
    _dio.options
      ..baseUrl = baseUrl
      ..connectTimeout = const Duration(seconds: 10)
      ..receiveTimeout = const Duration(seconds: 10)
      ..headers = {'Accept': 'application/json'};
  }

  /// 🧩 Lấy token đã lưu (sau khi login)
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// 🧾 GET
  Future<dynamic> get(String endpoint) async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        endpoint,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  /// ➕ POST
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final token = await _getToken();
      final response = await _dio.post(
        endpoint,
        data: jsonEncode(data),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  /// ✏️ PUT
  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final token = await _getToken();
      final response = await _dio.put(
        endpoint,
        data: jsonEncode(data),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  /// ❌ DELETE
  Future<dynamic> delete(String endpoint) async {
    try {
      final token = await _getToken();
      final response = await _dio.delete(
        endpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  /// ⚠️ Xử lý lỗi Dio
  void _handleError(DioException e) {
    String message = "Lỗi không xác định";

    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
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
