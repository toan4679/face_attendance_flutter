import '../datasources/giangvien_api.dart';
import '../models/giangvien_model.dart';

class GiangVienRepository {
  final GiangVienApi api;

  GiangVienRepository(this.api);

  Future<GiangVien> getGiangVienById(int id) async {
    return await api.fetchGiangVienById(id);
  }
  // ✅ Lấy giảng viên hiện tại (đọc ID từ token storage)
  Future<GiangVien> getCurrentGiangVien() async {
    return await api.fetchCurrentGiangVien();
  }

  // ✅ Cập nhật thông tin giảng viên
  Future<void> updateGiangVien(GiangVien giangVien) async {
    await api.updateGiangVien(giangVien);
  }
}
