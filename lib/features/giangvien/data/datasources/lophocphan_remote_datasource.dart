// lib/data/datasources/lophocphan_remote_datasource.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:face_attendance_flutter/core/network/token_storage.dart';
import '../models/lophocphan_model.dart';

class LopHocPhanRemoteDataSource {
  final String baseUrl = "http://104.145.210.69/api/v1/giangvien/lophocphan";

  Future<List<LopHocPhan>> fetchLopHocPhan() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // 🔑 LẤY id giảng viên và LƯU VÀO STORAGE (nếu chưa có)
      final gv = data['giangVien'];
      if (gv != null && gv['maGV'] != null) {
        await TokenStorage.saveGiangVienId(gv['maGV'].toString());
      }

      final List<dynamic> list = data['data'] ?? [];
      return list.map((e) => LopHocPhan.fromJson(e)).toList();
    } else {
      throw Exception("Không thể tải dữ liệu lớp học phần (${response.statusCode})");
    }
  }
}
