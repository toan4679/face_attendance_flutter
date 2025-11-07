import 'package:flutter/foundation.dart';
import '../../data/models/buoihoc_model.dart';
import '../../data/models/giangvien_model.dart';
import '../../data/repositories/giangvien_repository.dart';
import '../../data/datasources/giangvien_api.dart';
import '../../data/repositories/lophocphan_repository.dart';
import '../../data/datasources/lophocphan_remote_datasource.dart';

class GiangVienController with ChangeNotifier {
  // 🔹 Singleton
  static final GiangVienController _instance = GiangVienController._internal();
  factory GiangVienController() => _instance;

  // 🔹 Constructor duy nhất
  GiangVienController._internal() {
    lopHocPhanRepo = LopHocPhanRepository(LopHocPhanRemoteDataSource());
  }

  // 🔹 Biến nội bộ
  final GiangVienApi _api = GiangVienApi();
  final GiangVienRepository _repo = GiangVienRepository(GiangVienApi());
  late final LopHocPhanRepository lopHocPhanRepo;

  List<BuoiHoc> lichDayHomNay = [];
  bool loadingLichDay = false;
  String? errorLichDay;
  GiangVien? currentGiangVien;

  // ===============================
  // 🟦 Lấy thông tin giảng viên hiện tại
  // ===============================
  Future<void> loadCurrentGiangVien() async {
    currentGiangVien = await _api.fetchCurrentGiangVien();
    notifyListeners();
  }

  GiangVien? get giangVien => currentGiangVien;

  // ===============================
  // 🟩 Cập nhật thông tin giảng viên
  // ===============================
  Future<void> updateGiangVien(GiangVien updatedGV) async {
    await _repo.updateGiangVien(updatedGV);
    currentGiangVien = updatedGV;
    notifyListeners();
  }

  // ===============================
  // 🟪 Lấy lịch dạy hôm nay của giảng viên
  // ===============================
  Future<void> fetchLichDayHomNay(int maGV) async {
    try {
      loadingLichDay = true;
      errorLichDay = null;
      notifyListeners();

      lichDayHomNay = await lopHocPhanRepo.getLichDayHomNay(maGV);
    } catch (e) {
      errorLichDay = e.toString();
    } finally {
      loadingLichDay = false;
      notifyListeners();
    }
  }

  // ===============================
  // 🟨 Lấy lịch dạy dựa trên currentGiangVien
  // ===============================
  Future<void> fetchLichDayHomNayCurrent() async {
    if (currentGiangVien == null) {
      errorLichDay = "Chưa load thông tin giảng viên";
      notifyListeners();
      return;
    }
    await fetchLichDayHomNay(currentGiangVien!.maGV);
  }

// 🧾 Lấy danh sách sinh viên của 1 buổi học
  Future<List<Map<String, dynamic>>> getDanhSachSinhVien(int maBuoi) async {
    try {
      final response = await _repo.getDanhSachSinhVienTheoBuoi(maBuoi);

      // Nếu response là List<dynamic>, ép kiểu về List<Map<String, dynamic>>
      if (response is List) {
        return response.map<Map<String, dynamic>>((e) {
          if (e is Map<String, dynamic>) {
            return e;
          } else {
            return {};
          }
        }).toList();
      }

      // Trường hợp khác trả về rỗng
      return [];
    } catch (e) {
      debugPrint("❌ Lỗi khi lấy danh sách sinh viên: $e");
      rethrow;
    }
  }

// ===============================
// 🟪 Tạo QR code cho buổi học
// ===============================
  Future<void> generateQR(int maBuoi) async {
    try {
      await _repo.generateQR(maBuoi);
      debugPrint("✅ QR code đã được tạo cho buổi $maBuoi");
    } catch (e) {
      debugPrint("❌ Lỗi tạo QR code: $e");
      rethrow;
    }
  }

// ===============================
// 🟥 Xóa QR code
// ===============================
  Future<void> clearQR(int maBuoi) async {
    try {
      await _repo.clearQR(maBuoi);
      debugPrint("📘 QR code đã bị xóa cho buổi $maBuoi");
    } catch (e) {
      debugPrint("❌ Lỗi xóa QR code: $e");
      rethrow;
    }
  }
}
