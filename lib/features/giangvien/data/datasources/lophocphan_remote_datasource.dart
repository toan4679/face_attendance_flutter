import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:face_attendance_flutter/core/network/token_storage.dart';
import '../models/giangvien_model.dart';
import '../models/lophocphan_model.dart';
import '../models/buoihoc_model.dart';
import '../models/monhoc_model.dart';
import '../models/sinhvien_model.dart';

class LopHocPhanRemoteDataSource {
  final String baseUrl = "http://104.145.210.69/api/v1";

  /// 🔹 Lấy lớp học phần của giảng viên theo maGV
  Future<List<LopHocPhan>> fetchLopHocPhan(int maGV) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/giangvien/$maGV/lophocphan');

    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200) {
      throw Exception(
          "Không thể tải dữ liệu lớp học phần (${response.statusCode})");
    }

    final data = jsonDecode(response.body);
    final list = (data['data'] as List? ?? []);

    // Lưu maGV nếu chưa có
    if (list.isNotEmpty) {
      final gv = list[0]['giang_vien'];
      if (gv != null && gv['maGV'] != null) {
        await TokenStorage.saveUserId(gv['maGV'].toString());
      }
    }

    return Future.wait(list.map((e) async {
      final monHoc = MonHoc.fromJson(e['mon_hoc']);
      final giangVien = GiangVien.fromJson(e['giang_vien']);

      // Lấy danh sách sinh viên nếu có
      List<SinhVien> dsSinhVien = [];
      if (e['danhSachSinhVien'] != null) {
        dsSinhVien = (e['danhSachSinhVien'] as List)
            .map((sv) => SinhVien.fromJson(sv))
            .toList();
      } else if (e['maLopHP'] != null) {
        dsSinhVien = (await fetchDanhSachSinhVienTheoBuoi(e['maLopHP']))
            .map((sv) => SinhVien.fromJson(sv))
            .toList();
      }

      return LopHocPhan.fromJson(
        e,
        monHoc: monHoc,
        giangVien: giangVien,
        sinhVienList: dsSinhVien,
      );
    })).then((value) => value.toList());
  }

  /// 🔹 Lấy danh sách sinh viên theo buổi học
  Future<List<Map<String, dynamic>>> fetchDanhSachSinhVienTheoBuoi(int maBuoi) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/giangvien/buoihoc/$maBuoi/sinhvien');

    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200) {
      throw Exception(
          'Lỗi khi tải danh sách sinh viên (${response.statusCode}) - ${response.body}');
    }

    final data = jsonDecode(response.body);
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    } else if (data is Map && data['data'] is List) {
      return (data['data'] as List).cast<Map<String, dynamic>>();
    } else if (data is Map && data['danhSach'] is List) {
      return (data['danhSach'] as List).cast<Map<String, dynamic>>();
    } else {
      throw Exception('Không nhận được danh sách sinh viên hợp lệ từ server');
    }
  }
  Future<List<BuoiHoc>> getLichDayHomNay(int maGV) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/giangvien/$maGV/lichday/homnay');

    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200) {
      throw Exception(
          "Không thể tải lịch dạy hôm nay (${response.statusCode})");
    }

    final data = jsonDecode(response.body);

    // 🔹 Lấy trực tiếp mảng lichDayHomNay từ response
    final list = (data['lichDayHomNay'] as List? ?? []);

    return list.map((e) => BuoiHoc.fromJson(e)).toList();
  }


}
