import '../datasources/lophocphan_api.dart';
import '../models/lop_hoc_phan_model.dart';

class LopHocPhanRepository {
  final LopHocPhanApi api;
  LopHocPhanRepository({required this.api});

  Future<List<LopHocPhanModel>> getAll() async {
    final res = await api.getAll();
    final data = res.data;

    if (data is List) {
      return data.map((e) => LopHocPhanModel.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => LopHocPhanModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }

  Future<LopHocPhanModel?> create(Map<String, dynamic> body) async {
    final res = await api.create(body);
    return LopHocPhanModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<LopHocPhanModel?> update(int id, Map<String, dynamic> body) async {
    final res = await api.update(id, body);
    return LopHocPhanModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<void> delete(int id) async => await api.delete(id);

  Future<Map<String, dynamic>> getSinhVienByLopHocPhan(int id) async {
    final res = await api.getSinhVienByLopHocPhan(id);
    return Map<String, dynamic>.from(res.data);
  }

  Future<void> ganLopHanhChinh(int id, List<int> dsMaLop) async {
    await api.ganLopHanhChinh(id, dsMaLop);
  }

  Future<List<Map<String, dynamic>>> getDanhSachLopHanhChinh() async {
    final res = await api.getDanhSachLopHanhChinh();
    final data = res.data;

    if (data is List) {
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return [];
  }
}
