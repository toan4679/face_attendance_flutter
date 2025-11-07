import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import '../datasources/buoihoc_api.dart';
import '../models/buoi_hoc_model.dart';

class BuoiHocRepository {
  final BuoiHocApi api;
  BuoiHocRepository({required this.api});

  /// 🔹 Lấy tất cả buổi học (alias của getList)
  Future<List<BuoiHocModel>> getAll() async {
    return getList(); // Gọi lại getList() mà không cần truyền maLopHP
  }

  /// 🔹 Lấy danh sách buổi học (có thể lọc theo mã lớp học phần)
  Future<List<BuoiHocModel>> getList({int? maLopHP}) async {
    try {
      final res = await api.getList(maLopHP: maLopHP);
      debugPrint('📡 [BuoiHocRepo] Response type: ${res.data.runtimeType}');
      debugPrint('📡 [BuoiHocRepo] Response content: ${res.data}');

      final data = res.data;
      List<dynamic> raw;

      if (data is List) {
        raw = data;
      } else if (data is Map && data['data'] is List) {
        raw = data['data'];
      } else {
        debugPrint('[WARN] ⚠️ Dữ liệu buổi học không hợp lệ: $data');
        return [];
      }

      final list = raw.map((e) {
        try {
          return BuoiHocModel.fromJson(e);
        } catch (err) {
          debugPrint('[ERROR] ❌ Parse buổi học thất bại: $err\nDữ liệu: $e');
          return null;
        }
      }).whereType<BuoiHocModel>().toList();

      debugPrint('✅ [BuoiHocRepo] Parsed ${list.length} buổi học');
      return list;
    } catch (e, st) {
      debugPrint('❌ [BuoiHocRepo] Lỗi tải danh sách buổi học: $e\n$st');
      return [];
    }
  }

  /// 🔹 Tạo buổi học mới
  Future<BuoiHocModel> create(Map<String, dynamic> body) async {
    final res = await api.create(body);
    final obj = (res.data is Map && res.data['data'] != null)
        ? res.data['data']
        : res.data;
    return BuoiHocModel.fromJson(obj);
  }

  /// 🔹 Cập nhật buổi học
  Future<BuoiHocModel> update(int id, Map<String, dynamic> body) async {
    final res = await api.update(id, body);
    final obj = (res.data is Map && res.data['data'] != null)
        ? res.data['data']
        : res.data;
    return BuoiHocModel.fromJson(obj);
  }

  Future<void> createMultiple(List<Map<String, dynamic>> list) async {
    await api.createMultiple(list);  }

  /// 🔹 Xóa buổi học
  Future<void> delete(int id) => api.delete(id);
}
