import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/lop_model.dart';
import '../models/sinhvien_model.dart';

class LopRepository {
  final ApiService _api = ApiService();

  Future<List<LopModel>> getAll() async {
    final endpoint = ApiEndpoints.pdtLop;
    final response = await _api.get(endpoint);
    if (response is List) {
      return response.map((e) => LopModel.fromJson(e)).toList();
    }
    if (response is Map && response['data'] is List) {
      return (response['data'] as List).map((e) => LopModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> create(Map<String, dynamic> data) async {
    final endpoint = ApiEndpoints.pdtLop;
    debugPrint('➡️ [Repo] POST $endpoint');
    debugPrint('🧾 [Repo] body: $data');
    final res = await _api.post(endpoint, data);
    debugPrint('✅ [Repo] Tạo lớp OK: $res');
  }

  Future<void> update(int id, Map<String, dynamic> data) async {
    final endpoint = '${ApiEndpoints.pdtLop}/$id';
    debugPrint('➡️ [Repo] PUT $endpoint');
    debugPrint('🧾 [Repo] body: $data');
    final res = await _api.put(endpoint, data);
    debugPrint('✅ [Repo] Cập nhật lớp OK: $res');
  }

  Future<void> delete(int id) async {
    final endpoint = '${ApiEndpoints.pdtLop}/$id';
    debugPrint('➡️ [Repo] DELETE $endpoint');
    final res = await _api.delete(endpoint);
    debugPrint('✅ [Repo] Xóa lớp OK: $res');
  }

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

  Future<void> importSinhVienExcel(int maLop, dynamic fileInput) async {
    MultipartFile filePart;
    if (kIsWeb && fileInput is Uint8List) {
      debugPrint('🌐 [Repo] Import Web bytes: ${fileInput.length}');
      filePart = MultipartFile.fromBytes(fileInput, filename: 'sinhvien.xlsx');
    } else if (fileInput is String) {
      debugPrint('📱 [Repo] Import File Path: $fileInput');
      filePart = await MultipartFile.fromFile(fileInput, filename: 'sinhvien.xlsx');
    } else {
      throw Exception('File không hợp lệ! (${fileInput.runtimeType})');
    }

    final formData = FormData.fromMap({'file': filePart});
    final endpoint = '${ApiEndpoints.pdtLop}/$maLop/import-sinhvien';
    debugPrint('➡️ [Repo] POST $endpoint (multipart)');
    final res = await _api.post(endpoint, formData);
    debugPrint('✅ [Repo] Import OK: $res');
  }
}
