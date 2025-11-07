import '../../data/models/buoihoc_model.dart';
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
  // ===============================
  // 🟪 Lấy lịch dạy hôm nay của giảng viên
  // ===============================
  Future<List<BuoiHoc>> getLichDayHomNay() async {
    if (currentGiangVien == null) {
      throw Exception("Chưa load thông tin giảng viên");
    }
    final maGV = currentGiangVien!.maGV;
    return await _repo.getLichDayHomNay(maGV);
  }
}
