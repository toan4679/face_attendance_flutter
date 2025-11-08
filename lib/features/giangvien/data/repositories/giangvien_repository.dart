import '../datasources/giangvien_api.dart';
import '../models/buoihoc_model.dart';
import '../models/giangvien_model.dart';

class GiangVienRepository {
  final GiangVienApi api;
  GiangVienRepository(this.api);

  Future<GiangVien> getGiangVienById(int id) => api.fetchGiangVienById(id);

  Future<GiangVien> getCurrentGiangVien() => api.fetchCurrentGiangVien();

  Future<void> updateGiangVien(GiangVien gv) => api.updateGiangVien(gv);

  Future<List<BuoiHoc>> getLichDayHomNay(int maGV) => api.fetchLichDayHomNay(maGV);

  Future<List<Map<String, dynamic>>> getDanhSachSinhVienTheoBuoi(int maBuoi) =>
      api.fetchDanhSachSinhVienTheoBuoi(maBuoi);

  /// Mở điểm danh → trả QR thật từ server
  Future<String> generateQR(int maBuoi) => api.generateQR(maBuoi);

  /// Đóng điểm danh
  Future<void> clearQR(int maBuoi) => api.clearQR(maBuoi);
}
