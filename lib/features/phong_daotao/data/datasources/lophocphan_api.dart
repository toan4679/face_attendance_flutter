import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class LopHocPhanApi {
  final Dio _client = ApiClient.instance.dio;

  // 🔹 GET tất cả lớp học phần
  Future<Response> getAll() async {
    try {
      print('[DEBUG] 📡 Fetching all lớp học phần...');
      final res = await _client.get('/v1/pdt/lophocphan');
      return res;
    } catch (e) {
      print('[ERROR] ❌ getAll() failed: $e');
      rethrow;
    }
  }

  // 🔹 POST thêm lớp học phần
  Future<Response> create(Map<String, dynamic> data) async {
    try {
      print('[DEBUG] 📤 Creating lớp học phần: $data');
      final res = await _client.post(
        '/v1/pdt/lophocphan',
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return res;
    } catch (e) {
      print('[ERROR] ❌ create() failed: $e');
      rethrow;
    }
  }

  // 🔹 PATCH cập nhật lớp học phần
  Future<Response> update(int id, Map<String, dynamic> data) async {
    try {
      final res = await _client.patch('/v1/pdt/lophocphan/$id', data: data);
      return res;
    } catch (e) {
      print('[ERROR] ❌ update() failed: $e');
      rethrow;
    }
  }

  // 🔹 DELETE xóa lớp học phần
  Future<Response> delete(int id) async {
    try {
      final res = await _client.delete('/v1/pdt/lophocphan/$id');
      return res;
    } catch (e) {
      print('[ERROR] ❌ delete() failed: $e');
      rethrow;
    }
  }

  // 🧩 GET sinh viên theo lớp học phần
  Future<Response> getSinhVienByLopHocPhan(int id) async {
    try {
      final res = await _client.get('/v1/pdt/lophocphan/$id/sinhvien');
      return res;
    } catch (e) {
      print('[ERROR] ❌ getSinhVienByLopHocPhan() failed: $e');
      rethrow;
    }
  }

  // 🧩 PATCH gán lớp hành chính vào lớp học phần
  Future<Response> ganLopHanhChinh(int id, List<int> dsMaLop) async {
    try {
      final res = await _client.patch(
        '/v1/pdt/lophocphan/$id/gan-lop',
        data: {'dsMaLop': dsMaLop},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return res;
    } catch (e) {
      print('[ERROR] ❌ ganLopHanhChinh() failed: $e');
      rethrow;
    }
  }

  // 🧩 GET danh sách lớp hành chính
  Future<Response> getDanhSachLopHanhChinh() async {
    try {
      final res = await _client.get('/v1/pdt/lop');
      return res;
    } catch (e) {
      print('[ERROR] ❌ getDanhSachLopHanhChinh() failed: $e');
      rethrow;
    }
  }
}
