import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/lop_model.dart';
import '../models/sinhvien_model.dart';

class LopRepository {
  final ApiService _api = ApiService();

  /// 🧾 Lấy danh sách lớp
  Future<List<LopModel>> getAll() async {
    final endpoint = ApiEndpoints.pdtLop;
    final response = await _api.get(endpoint);

    if (response is List) {
      return response.map((e) => LopModel.fromJson(e)).toList();
    }

    if (response is Map && response['data'] is List) {
      return (response['data'] as List)
          .map((e) => LopModel.fromJson(e))
          .toList();
    }

    return [];
  }

  /// ➕ Thêm lớp mới
  Future<void> create(Map<String, dynamic> data) async {
    final endpoint = ApiEndpoints.pdtLop;
    debugPrint('➡️ [Repo] POST $endpoint');
    debugPrint('🧾 [Repo] body: $data');
    final res = await _api.post(endpoint, data);
    debugPrint('✅ [Repo] Tạo lớp OK: $res');
  }

  /// ✏️ Cập nhật lớp
  Future<void> update(int id, Map<String, dynamic> data) async {
    final endpoint = '${ApiEndpoints.pdtLop}/$id';
    debugPrint('➡️ [Repo] PUT $endpoint');
    debugPrint('🧾 [Repo] body: $data');
    final res = await _api.put(endpoint, data);
    debugPrint('✅ [Repo] Cập nhật lớp OK: $res');
  }

  /// 🗑 Xóa lớp
  Future<void> delete(int id) async {
    final endpoint = '${ApiEndpoints.pdtLop}/$id';
    debugPrint('➡️ [Repo] DELETE $endpoint');
    final res = await _api.delete(endpoint);
    debugPrint('✅ [Repo] Xóa lớp OK: $res');
  }

  /// 👨‍🎓 Lấy danh sách sinh viên theo mã lớp
  Future<List<SinhVienModel>> getSinhVienByLop(int maLop) async {
    final endpoint = '${ApiEndpoints.pdtLop}/$maLop/sinhvien';
    debugPrint('➡️ [Repo] GET $endpoint');
    final res = await _api.get(endpoint);
    debugPrint('📦 [Repo] res sinhvien: $res');

    if (res is List) {
      return res.map((e) => SinhVienModel.fromJson(e)).toList();
    }
    return [];
  }

  /// 📤 Import danh sách sinh viên từ file Excel (.xls, .xlsx)
  Future<void> importSinhVienExcel(int maLop, dynamic fileInput) async {
    MultipartFile filePart;

    // 🌐 Trường hợp chạy Web: upload bằng bytes
    if (kIsWeb && fileInput is Uint8List) {
      debugPrint('🌐 [Repo] Import Web bytes: ${fileInput.length}');
      filePart = MultipartFile.fromBytes(
        fileInput,
        filename: 'sinhvien.xlsx',
      );
    }

    // 📱 Trường hợp chạy Desktop / Mobile: upload bằng file path
    else if (fileInput is String) {
      debugPrint('📱 [Repo] Import File Path: $fileInput');
      filePart = await MultipartFile.fromFile(
        fileInput,
        filename: 'sinhvien.xlsx',
      );
    } else {
      throw Exception('File không hợp lệ! (${fileInput.runtimeType})');
    }

    // ✅ Gói file thành FormData
    final formData = FormData.fromMap({'file': filePart});

    // Endpoint import
    final endpoint = '${ApiEndpoints.pdtLop}/$maLop/import-sinhvien';
    debugPrint('➡️ [Repo] POST $endpoint (multipart)');

    try {
      final res = await _api.post(endpoint, formData);
      debugPrint('✅ [Repo] Import OK: $res');
    } on DioException catch (e) {
      final serverMsg = e.response?.data;
      debugPrint('❌ [Repo] Import lỗi: ${e.message}');
      debugPrint('❌ [Repo] Server says: $serverMsg');
      throw Exception(serverMsg is Map && serverMsg['message'] != null
          ? serverMsg['message']
          : '❌ Lỗi khi import file.');
    } catch (e) {
      debugPrint('❌ [Repo] Import exception: $e');
      throw Exception('❌ Lỗi khi import file.');
    }
  }
}
