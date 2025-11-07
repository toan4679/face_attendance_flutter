// lib/data/datasources/lophocphan_remote_datasource.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:face_attendance_flutter/core/network/token_storage.dart';
import '../models/giangvien_model.dart';
import '../models/lophocphan_model.dart';
import '../models/buoihoc_model.dart';
import '../models/monhoc_model.dart';
import '../models/sinhvien_model.dart';
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

      // 🔹 Map từng lớp học phần
      return Future.wait(list.map((e) async {
        // 1️⃣ Tạo đối tượng MonHoc
        final monHoc = MonHoc.fromJson(e['mon_hoc']);

        // 2️⃣ Tạo đối tượng GiangVien
        final giangVien = GiangVien.fromJson(e['giang_vien']);

        // 3️⃣ Lấy danh sách sinh viên cho lớp (nếu API trả kèm, nếu không gọi API khác)
        List<SinhVien> dsSinhVien = [];
        if (e['danhSachSinhVien'] != null) {
          dsSinhVien = (e['danhSachSinhVien'] as List)
              .map((sv) => SinhVien.fromJson(sv))
              .toList();
        } else if (e['maLopHP'] != null) {
          // nếu backend trả riêng route, gọi API fetchDanhSachSinhVienTheoBuoi
          dsSinhVien =
              (await fetchDanhSachSinhVienTheoBuoi(e['maLopHP']))
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
    } else {
      throw Exception(
          "Không thể tải dữ liệu lớp học phần (${response.statusCode})");
    }
  }


  Future<List<BuoiHoc>> getLichDayHomNay(int maGV) async {
    final token = await TokenStorage.getToken();

    // 🔹 Base URL chuẩn: KHÔNG lặp /api/v1/giangvien/lophocphan nữa
    final url = Uri.parse('http://104.145.210.69/api/v1/giangvien/$maGV/lichday/homnay');

    final res = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Lỗi lấy lịch dạy hôm nay (${res.statusCode})');
    }

    final data = jsonDecode(res.body);
    final list = (data['lichDayHomNay'] as List)
        .map((e) => BuoiHoc.fromJson(e))
        .toList();
    return list;
  }
  // NEW: fetch danh sách sinh viên cho 1 buổi (route của bạn: giangvien/buoihoc/{maBuoi}/diemdanh)
  Future<List<Map<String, dynamic>>> fetchDanhSachSinhVienTheoBuoi(int maBuoi) async {
    final url = Uri.parse('$baseUrl/giangvien/buoihoc/$maBuoi/diemdanh');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // kiểm tra cấu trúc trả về từ backend:
      // - nếu backend trả 1 object { data: [...] } hoặc { danhSach: [...] } sửa key tương ứng
      // Mặc định mình thử lấy toàn bộ body nếu là list, hoặc data['data'] nếu backend dùng đó.
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      } else if (data is Map && data['data'] is List) {
        return (data['data'] as List).cast<Map<String, dynamic>>();
      } else if (data is Map && data['danhSach'] is List) {
        return (data['danhSach'] as List).cast<Map<String, dynamic>>();
      } else {
        // fallback: nếu backend trả object chứa key khác, bạn sẽ cần điều chỉnh ở đây
        throw Exception('Không nhận được danh sách sinh viên hợp lệ từ server');
      }
    } else {
      throw Exception('Lỗi khi tải danh sách sinh viên (${response.statusCode}) - ${response.body}');
    }
  }
}