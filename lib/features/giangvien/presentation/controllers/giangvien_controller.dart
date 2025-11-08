import 'package:flutter/foundation.dart';
import '../../data/models/buoihoc_model.dart';
import '../../data/models/giangvien_model.dart';
import '../../data/repositories/giangvien_repository.dart';
import '../../data/datasources/giangvien_api.dart';
import '../../data/repositories/lophocphan_repository.dart';
import '../../data/datasources/lophocphan_remote_datasource.dart';

class GiangVienController with ChangeNotifier {
  static final GiangVienController _instance = GiangVienController._internal();
  factory GiangVienController() => _instance;

  GiangVienController._internal() {
    lopHocPhanRepo = LopHocPhanRepository(LopHocPhanRemoteDataSource());
  }

  final GiangVienRepository _repo = GiangVienRepository(GiangVienApi());
  late final LopHocPhanRepository lopHocPhanRepo;

  // ===============================
  // Dữ liệu trạng thái
  // ===============================
  List<BuoiHoc> lichDayHomNay = [];
  bool loadingLichDay = false;
  String? errorLichDay;

  GiangVien? currentGiangVien;
  GiangVien? get giangVien => currentGiangVien; // ✅ Getter để trang chủ dùng

  String? qrCode; // QR code thật từ server
  bool loadingQR = false;
  String? errorQR;

  // ===============================
  // Giảng viên hiện tại
  // ===============================
  Future<void> loadCurrentGiangVien() async {
    try {
      currentGiangVien = await _repo.getCurrentGiangVien();
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Lỗi load giảng viên: $e");
    }
  }

  // ===============================
  // Lịch dạy hôm nay
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

  Future<void> fetchLichDayHomNayCurrent() async {
    if (currentGiangVien == null) {
      errorLichDay = "Chưa load thông tin giảng viên";
      notifyListeners();
      return;
    }
    await fetchLichDayHomNay(currentGiangVien!.maGV);
  }

  // ===============================
  // Danh sách sinh viên
  // ===============================
  Future<List<Map<String, dynamic>>> getDanhSachSinhVien(int maBuoi) async {
    try {
      final response = await _repo.getDanhSachSinhVienTheoBuoi(maBuoi);
      if (response is List) {
        return response.map<Map<String, dynamic>>((e) {
          if (e is Map<String, dynamic>) return e;
          return {};
        }).toList();
      }
      return [];
    } catch (e) {
      debugPrint("❌ Lỗi khi lấy danh sách sinh viên: $e");
      rethrow;
    }
  }

  // ===============================
  // Bắt đầu điểm danh → tạo QR
  // ===============================
  Future<void> startDiemDanh(int maBuoi) async {
    loadingQR = true;
    errorQR = null;
    notifyListeners();
    try {
      qrCode = await _repo.generateQR(maBuoi);
      debugPrint("✅ QR code đã được tạo: $qrCode");
    } catch (e) {
      errorQR = e.toString();
      qrCode = null;
      debugPrint("❌ Lỗi tạo QR code: $errorQR");
    } finally {
      loadingQR = false;
      notifyListeners();
    }
  }

  // ===============================
  // Kết thúc điểm danh → xóa QR
  // ===============================
  Future<void> endDiemDanh(int maBuoi) async {
    try {
      await _repo.clearQR(maBuoi);
      qrCode = null;
      notifyListeners();
      debugPrint("📘 QR code đã bị xóa cho buổi $maBuoi");
    } catch (e) {
      debugPrint("❌ Lỗi xóa QR code: $e");
    }
  }

  // ===============================
  // Cập nhật giảng viên
  // ===============================
  Future<void> updateGiangVien(GiangVien updatedGV) async {
    await _repo.updateGiangVien(updatedGV);
    currentGiangVien = updatedGV;
    notifyListeners();
  }
}
