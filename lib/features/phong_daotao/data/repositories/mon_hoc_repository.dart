import '../datasources/mon_hoc_api.dart';
import '../models/mon_hoc_model.dart';

class MonHocRepository {
  final MonHocApi _api = MonHocApi();

  Future<List<MonHocModel>> getAll() async {
    final data = await _api.fetchAll();
    return data.map((e) => MonHocModel.fromJson(e)).toList();
  }

  Future<void> create(MonHocModel monHoc) async {
    await _api.create(monHoc.toJson());
  }

  Future<void> update(int id, MonHocModel monHoc) async {
    await _api.update(id, monHoc.toJson());
  }

  Future<void> delete(int id) async {
    await _api.delete(id);
  }
}
