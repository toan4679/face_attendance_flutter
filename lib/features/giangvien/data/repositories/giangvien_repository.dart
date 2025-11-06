import '../datasources/giangvien_api.dart';
import '../models/giangvien_model.dart';

class GiangVienRepository {
  final GiangVienApi api;

  GiangVienRepository(this.api);

  Future<GiangVien> getGiangVienById(int id) async {
    return await api.fetchGiangVienById(id);
  }
}
