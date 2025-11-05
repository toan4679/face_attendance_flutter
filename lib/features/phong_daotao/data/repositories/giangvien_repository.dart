import '../datasources/giangvien_api.dart';
import '../models/giangvien_model.dart';
import 'package:flutter/foundation.dart';

class GiangVienRepository {
  final GiangVienApi api;
  GiangVienRepository({GiangVienApi? api}) : api = api ?? GiangVienApi();

  /// 🟢 Lấy toàn bộ danh sách giảng viên
  Future<List<GiangVienModel>> getAll() async {
    try {
      final res = await api.getAll();
      final data = res.data;

      List<dynamic> list = [];
      if (data is Map && data['data'] is List) {
        list = data['data'];
      } else if (data is List) {
        list = data;
      }

      return list.map((e) => GiangVienModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('[ERROR] ❌ Load giảng viên thất bại: $e');
      return [];
    }
  }

  /// 🟣 Lấy danh sách giảng viên theo mã khoa
  /// (Nếu API backend chưa có filter này, tạm filter client-side)
  Future<List<GiangVienModel>> getAllByKhoa(int maKhoa) async {
    try {
      final res = await api.getAll();
      final data = res.data;

      List<dynamic> list = [];
      if (data is Map && data['data'] is List) {
        list = data['data'];
      } else if (data is List) {
        list = data;
      }

      // ✅ Lọc theo mã khoa
      final filtered = list
          .map((e) => GiangVienModel.fromJson(e))
          .where((gv) => gv.maKhoa == maKhoa)
          .toList();

      debugPrint('✅ [GiangVienRepo] Loaded ${filtered.length} GV của khoa $maKhoa');
      return filtered;
    } catch (e, st) {
      debugPrint('❌ [GiangVienRepo] Lỗi getAllByKhoa: $e\n$st');
      return [];
    }
  }
}
