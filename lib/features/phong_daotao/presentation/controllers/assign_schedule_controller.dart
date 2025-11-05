import 'package:flutter/material.dart';
import '../../data/models/giangvien_model.dart';
import '../../data/models/buoi_hoc_model.dart';
import '../../data/models/khoa_model.dart';
import '../../data/repositories/buoihoc_repository.dart';
import '../../data/repositories/khoa_repository.dart';
import '../../data/repositories/giangvien_repository.dart';
import '../../data/repositories/lophocphan_repository.dart';

class AssignScheduleController extends ChangeNotifier {
  final KhoaRepository khoaRepo;
  final GiangVienRepository gvRepo;
  final LopHocPhanRepository lhpRepo;
  final BuoiHocRepository buoiHocRepo;

  AssignScheduleController({
    required this.khoaRepo,
    required this.gvRepo,
    required this.lhpRepo,
    required this.buoiHocRepo,
  });

  bool isLoading = false;
  int? selectedKhoaId;
  List<KhoaModel> khoaList = [];
  List<GiangVienModel> giangVienList = [];
  List<BuoiHocModel> allBuoiHoc = [];
  List<int> selectedBuoiIds = [];

  // 🔹 Load khoa
  Future<void> loadKhoa() async {
    isLoading = true;
    notifyListeners();
    try {
      khoaList = await khoaRepo.getAll();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Load giảng viên theo khoa
  Future<void> loadGiangVienTheoKhoa(int maKhoa) async {
    isLoading = true;
    selectedKhoaId = maKhoa;
    notifyListeners();
    try {
      final all = await gvRepo.getAll();
      giangVienList = all.where((gv) => gv.maKhoa == maKhoa).toList();
    } catch (e) {
      debugPrint('❌ Lỗi load giảng viên: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Load buổi học chưa có giảng viên
  Future<void> loadBuoiHocChuaGan() async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await buoiHocRepo.getAll();
      allBuoiHoc = data.where((b) => b.maGV == null).toList();
      debugPrint("📅 Có ${allBuoiHoc.length} buổi học chưa gán.");
    } catch (e) {
      debugPrint('❌ Lỗi load buổi học: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🟢 Toggle chọn buổi học
  void toggleBuoiHoc(int maBuoi) {
    if (selectedBuoiIds.contains(maBuoi)) {
      selectedBuoiIds.remove(maBuoi);
    } else {
      selectedBuoiIds.add(maBuoi);
    }
    notifyListeners();
  }

  // 🟢 Gán buổi học cho giảng viên
  Future<void> assignBuoiHocToGiangVien(
      BuildContext context, GiangVienModel gv) async {
    if (selectedBuoiIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Vui lòng chọn ít nhất 1 buổi học!')),
      );
      return;
    }

    try {
      for (final id in selectedBuoiIds) {
        await buoiHocRepo.update(id, {'maGV': gv.maGV});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Gán lịch dạy thành công!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Lỗi khi gán lịch: $e')),
      );
    } finally {
      selectedBuoiIds.clear();
      await loadBuoiHocChuaGan();
    }
  }
}
