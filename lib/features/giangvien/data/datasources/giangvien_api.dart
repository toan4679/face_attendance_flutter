import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/giangvien_model.dart';
import 'package:face_attendance_flutter/core/network/token_storage.dart';
class GiangVienApi {
  final String baseUrl = "http://104.145.210.69/api/v1/giangvien";

  Future<GiangVien> fetchGiangVienById(int id) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/$id"), // <-- PHẢI có /$id
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return GiangVien.fromJson(json['data']);
    } else {
      throw Exception('Không thể tải thông tin giảng viên');
    }
  }
  Future<GiangVien> fetchCurrentGiangVien() async {
    final token = await TokenStorage.getToken();
    final id = await TokenStorage.getGiangVienId();

    if (id == null) {
      throw Exception("Không tìm thấy ID giảng viên trong bộ nhớ.");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/$id"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("📡 GET $baseUrl/$id -> ${response.statusCode}");
    print("📄 Body: ${response.body}");
    print("📡 Token: $token");
    print("📡 ID: $id");
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return GiangVien.fromJson(json['data']);
    } else {
      throw Exception(
          "Không thể tải dữ liệu giảng viên (${response.statusCode})");
    }
  }
}
