import '../datasources/giangvien_api.dart';
import '../models/buoihoc_model.dart';
import '../models/giangvien_model.dart';

class GiangVienRepository {
  final GiangVienApi api;

  GiangVienRepository(this.api);

  // ===============================
  // Lấy giảng viên theo ID
  // ===============================
  Future<GiangVien> getGiangVienById(int id) async {
    return await api.fetchGiangVienById(id);
  }

  // ===============================
  // Lấy giảng viên hiện tại (token)
  // ===============================
  Future<GiangVien> getCurrentGiangVien() async {
    return await api.fetchCurrentGiangVien();
  }

  // ===============================
  // Cập nhật thông tin giảng viên
  // ===============================
  Future<void> updateGiangVien(GiangVien giangVien) async {
    await api.updateGiangVien(giangVien);
  }

  // ===============================
  // Lấy lịch dạy hôm nay
  // ===============================
  Future<List<BuoiHoc>> getLichDayHomNay(int maGV) async {
    return await api.fetchLichDayHomNay(maGV);
  }

  // ===============================
  // Lấy danh sách sinh viên theo buổi học
  // ===============================
  Future<List<Map<String, dynamic>>> getDanhSachSinhVienTheoBuoi(int maBuoi) async {
    return await api.fetchDanhSachSinhVienTheoBuoi(maBuoi);
  }

  // ===============================
  // Mở điểm danh
  // ===============================
  Future<void> moDiemDanh(int maBuoi) async {
    await api.moDiemDanh(maBuoi);
    await generateQR(maBuoi); // tạo QR khi mở điểm danh
  }

  // ===============================
  // Đóng điểm danh
  // ===============================
  Future<void> dongDiemDanh(int maBuoi) async {
    await api.dongDiemDanh(maBuoi);
    await clearQR(maBuoi); // xóa QR khi đóng điểm danh
  }

  // ===============================
  // Tạo QR code cho buổi học
  // ===============================
  Future<void> generateQR(int maBuoi) async {
    await api.generateQR(maBuoi);
  }

  // ===============================
  // Xóa QR code của buổi học
  // ===============================
  Future<void> clearQR(int maBuoi) async {
    await api.clearQR(maBuoi);
  }
}
