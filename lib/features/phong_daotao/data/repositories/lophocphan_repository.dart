import '../datasources/lophocphan_api.dart';
import '../models/lop_hoc_phan_model.dart';

class LopHocPhanRepository {
  final LopHocPhanApi api;
  LopHocPhanRepository({required this.api});

  Future<List<LopHocPhanModel>> getAll() async {
    final res = await api.getAll();
    final data = res.data;
    if (data is List) {
      return data.map((e) => LopHocPhanModel.fromJson(e)).toList();
    }
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => LopHocPhanModel.fromJson(e))
          .toList();
    }
    print('[WARN] ⚠️ Dữ liệu trả về không hợp lệ: $data');
    return [];
  }

  Future<LopHocPhanModel?> create(Map<String, dynamic> body) async {
    final res = await api.create(body);
    return LopHocPhanModel.fromJson(res.data);
  }

  Future<LopHocPhanModel?> update(int id, Map<String, dynamic> body) async {
    final res = await api.update(id, body);
    return LopHocPhanModel.fromJson(res.data);
  }

  Future<void> delete(int id) async {
    await api.delete(id);
  }
}
