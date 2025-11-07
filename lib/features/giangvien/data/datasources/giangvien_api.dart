import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/buoihoc_model.dart';
import '../models/giangvien_model.dart';
import 'package:face_attendance_flutter/core/network/token_storage.dart';

class GiangVienApi {
  final String baseUrl = "http://104.145.210.69/api/v1/giangvien";

  /// ✅ Lấy thông tin giảng viên theo ID
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

  /// ✅ Lấy thông tin giảng viên hiện tại
  Future<GiangVien> fetchCurrentGiangVien() async {
    final token = await TokenStorage.getToken();
    final id = await TokenStorage.getGiangVienId();

    if (id == null) throw Exception("Không tìm thấy ID giảng viên trong bộ nhớ.");

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

  /// ✅ Cập nhật giảng viên
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

  /// ✅ Lấy lịch dạy hôm nay
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

  /// 🧾 Lấy danh sách sinh viên theo buổi học
  Future<List<Map<String, dynamic>>> fetchDanhSachSinhVienTheoBuoi(int maBuoi) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse("$baseUrl/buoihoc/$maBuoi/sinhvien");

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Không thể lấy danh sách sinh viên (${response.statusCode})');
    }
  }

  /// ✅ Mở điểm danh
  Future<void> moDiemDanh(int maBuoi) async {
    final token = await TokenStorage.getToken();
    final url = "$baseUrl/buoihoc/$maBuoi/qr"; // thống nhất route POST tạo QR
    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200) throw Exception("Không thể mở điểm danh");
  }

  /// ✅ Đóng điểm danh
  Future<void> dongDiemDanh(int maBuoi) async {
    final token = await TokenStorage.getToken();
    final url = "$baseUrl/buoihoc/$maBuoi/clear-qr"; // route POST xóa QR
    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200) throw Exception("Không thể đóng điểm danh");
  }

  /// ✅ Tạo QR code cho buổi học
  Future<void> generateQR(int maBuoi) async {
    final token = await TokenStorage.getToken();
    final url = "$baseUrl/buoihoc/$maBuoi/qr";
    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200) throw Exception("Không thể tạo QR code");
  }

  /// ✅ Xóa QR code
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
