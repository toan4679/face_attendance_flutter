import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/buoihoc_model.dart';
import '../models/giangvien_model.dart';
import 'package:face_attendance_flutter/core/network/token_storage.dart';

class GiangVienApi {
  final String baseUrl = "http://104.145.210.69/api/v1/giangvien";

  /// Lấy giảng viên theo ID
  Future<GiangVien> fetchGiangVienById(int id) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/$id"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return GiangVien.fromJson(json['data']);
    } else {
      throw Exception('Không thể tải thông tin giảng viên (${response.statusCode})');
    }
  }

  /// Lấy giảng viên hiện tại
  Future<GiangVien> fetchCurrentGiangVien() async {
    final token = await TokenStorage.getToken();
    final id = await TokenStorage.getUserId();
    if (id == null) throw Exception("Không tìm thấy ID giảng viên.");

    final response = await http.get(
      Uri.parse("$baseUrl/$id"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return GiangVien.fromJson(json['data']);
    } else {
      throw Exception("Không thể tải dữ liệu giảng viên (${response.statusCode})");
    }
  }

  /// Cập nhật giảng viên
  Future<void> updateGiangVien(GiangVien giangVien) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse("$baseUrl/${giangVien.maGV}");
    final response = await http.put(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
      },
      body: {
        'hoTen': giangVien.hoTen,
        'email': giangVien.email,
        'soDienThoai': giangVien.soDienThoai ?? '',
        'hocVi': giangVien.hocVi ?? '',
        'moTa': giangVien.moTa ?? '',
      },
    );

    if (response.statusCode != 200) {
      try {
        final error = jsonDecode(response.body);
        throw Exception("Không thể cập nhật giảng viên: ${error['message'] ?? response.statusCode}");
      } catch (_) {
        throw Exception("Không thể cập nhật giảng viên (${response.statusCode})");
      }
    }
  }

  /// Lấy lịch dạy hôm nay
  Future<List<BuoiHoc>> fetchLichDayHomNay(int maGV) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse("$baseUrl/$maGV/lichday/homnay");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> lichList = data['lichDayHomNay'] ?? [];
      return lichList.map((e) => BuoiHoc.fromJson(e)).toList();
    } else {
      throw Exception('Không thể lấy lịch dạy hôm nay (${response.statusCode})');
    }
  }

  /// Lấy danh sách sinh viên theo buổi học
  Future<List<Map<String, dynamic>>> fetchDanhSachSinhVienTheoBuoi(int maBuoi) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse("$baseUrl/buoihoc/$maBuoi/sinhvien");
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> list = jsonData['data'] ?? [];
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception('Không thể lấy danh sách sinh viên (${response.statusCode})');
    }
  }

  /// Tạo QR code cho buổi học và trả về giá trị maQR từ server
  Future<String> generateQR(int maBuoi) async {
    final token = await TokenStorage.getToken();
    final url = "$baseUrl/buoihoc/$maBuoi/qr";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Không thể tạo QR code (${response.statusCode})");
    }

    final data = jsonDecode(response.body);
    final qr = data['maQR']?.toString().trim() ?? "";

    if (qr.isEmpty) {
      throw Exception("Server không trả QR code hợp lệ");
    }

    debugPrint("✅ QR code đã được tạo: $qr");
    return qr;
  }

  /// Xóa QR code
  Future<void> clearQR(int maBuoi) async {
    final token = await TokenStorage.getToken();
    final url = "$baseUrl/buoihoc/$maBuoi/clear-qr";
    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200) throw Exception("Không thể xóa QR code");
  }
}
