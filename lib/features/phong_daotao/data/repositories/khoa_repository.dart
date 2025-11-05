import 'package:flutter/foundation.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/khoa_model.dart';

class KhoaRepository {
  final ApiService _api = ApiService();

  /// 📥 Lấy danh sách tất cả Khoa
  Future<List<KhoaModel>> getAll() async {
    try {
      final response = await _api.get(ApiEndpoints.pdtKhoa);
      debugPrint('📥 Response khoa: $response');

      // ✅ Laravel paginate (có current_page + data)
      if (response is Map && response['data'] is List) {
        final list = response['data'] as List;
        return list.map((e) => KhoaModel.fromJson(e)).toList();
      }

      // ✅ Nếu trả thẳng danh sách
      if (response is List) {
        return response.map((e) => KhoaModel.fromJson(e)).toList();
      }

      debugPrint('⚠️ Response không hợp lệ khi lấy danh sách Khoa');
      return [];
    } catch (e, st) {
      debugPrint('❌ Lỗi getAll() trong KhoaRepository: $e');
      debugPrintStack(stackTrace: st);
      return [];
    }
  }

  /// ➕ Thêm mới Khoa
  Future<KhoaModel> create(KhoaModel khoa) async {
    final response = await _api.post(ApiEndpoints.pdtKhoa, khoa.toJson());
    // Laravel có thể trả dạng { "data": { ... } }
    final data = (response is Map && response['data'] != null)
        ? response['data']
        : response;
    return KhoaModel.fromJson(data);
  }

  /// 🛠 Cập nhật Khoa
  Future<KhoaModel> update(int id, KhoaModel khoa) async {
    final response = await _api.put('${ApiEndpoints.pdtKhoa}/$id', khoa.toJson());
    final data = (response is Map && response['data'] != null)
        ? response['data']
        : response;
    return KhoaModel.fromJson(data);
  }

  /// 🗑 Xóa Khoa
  Future<void> delete(int id) async {
    await _api.delete('${ApiEndpoints.pdtKhoa}/$id');
  }
}
