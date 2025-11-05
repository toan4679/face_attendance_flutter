import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class LopHocPhanApi {
  final Dio _client = ApiClient.instance.dio;

  // 🔹 GET tất cả lớp học phần
  Future<Response> getAll() async {
    try {
      print('[DEBUG] 📡 Fetching all lớp học phần...');
      final res = await _client.get('/v1/pdt/lophocphan');
      print('[DEBUG] ✅ Received ${res.data.runtimeType}: ${res.data}');
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
      print('[DEBUG] ✅ Created: ${res.data}');
      return res;
    } catch (e) {
      if (e is DioException) {
        print('[ERROR] ❌ create() failed: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        print('[ERROR] ❌ create() failed: $e');
      }
      rethrow;
    }
  }


  // 🔹 PATCH cập nhật lớp học phần
  Future<Response> update(int id, Map<String, dynamic> data) async {
    try {
      print('[DEBUG] 🛠 Updating lớp học phần $id with: $data');
      final res = await _client.patch('/v1/pdt/lophocphan/$id', data: data);
      print('[DEBUG] ✅ Updated lớp học phần: ${res.data}');
      return res;
    } catch (e) {
      print('[ERROR] ❌ update() failed: $e');
      rethrow;
    }
  }

  // 🔹 DELETE xóa lớp học phần
  Future<Response> delete(int id) async {
    try {
      print('[DEBUG] 🗑 Deleting lớp học phần $id...');
      final res = await _client.delete('/v1/pdt/lophocphan/$id');
      print('[DEBUG] ✅ Deleted lớp học phần $id');
      return res;
    } catch (e) {
      print('[ERROR] ❌ delete() failed: $e');
      rethrow;
    }
  }
}
