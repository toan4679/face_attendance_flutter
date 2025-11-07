import '../../data/models/giangvien_model.dart';
import '../../data/repositories/giangvien_repository.dart';
import '../../data/datasources/giangvien_api.dart';

class GiangVienController {
  static final GiangVienController _instance = GiangVienController._internal();
  factory GiangVienController() => _instance;
  GiangVienController._internal();

  GiangVien? currentGiangVien;

  final GiangVienApi _api = GiangVienApi();
  final GiangVienRepository _repo = GiangVienRepository(GiangVienApi());

  // ===============================
  // 🟦 Lấy thông tin giảng viên hiện tại
  // ===============================
  Future<void> loadCurrentGiangVien() async {
    currentGiangVien = await _api.fetchCurrentGiangVien();
  }

  GiangVien? get giangVien => currentGiangVien;

  // ===============================
  // 🟩 Cập nhật thông tin giảng viên
  // ===============================
  Future<void> updateGiangVien(GiangVien updatedGV) async {
    await _repo.updateGiangVien(updatedGV);
    currentGiangVien = updatedGV;
  }
}
