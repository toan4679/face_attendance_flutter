import 'package:flutter/material.dart';
import '../../data/models/mon_hoc_model.dart';
import '../../data/repositories/mon_hoc_repository.dart';

class MonHocController extends ChangeNotifier {
  final MonHocRepository _repo = MonHocRepository();

  List<MonHocModel> danhSachMon = [];
  bool isLoading = false;

  Future<void> fetchMonHoc() async {
    isLoading = true;
    notifyListeners();
    try {
      danhSachMon = await _repo.getAll();
      debugPrint("✅ Đã tải ${danhSachMon.length} môn học");
      if (danhSachMon.isNotEmpty) {
        debugPrint("Ví dụ môn đầu tiên: ${danhSachMon.first.tenMon}");
      }
    } catch (e) {
      debugPrint("❌ Lỗi fetchMonHoc: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMonHoc(MonHocModel monHoc) async {
    await _repo.create(monHoc);
    await fetchMonHoc();
  }

  Future<void> updateMonHoc(int id, MonHocModel monHoc) async {
    await _repo.update(id, monHoc);
    await fetchMonHoc();
  }

  Future<void> deleteMonHoc(int id) async {
    await _repo.delete(id);
    await fetchMonHoc();
  }

  List<MonHocModel> filterByNganh(int maNganh) {
    return danhSachMon.where((m) => m.maNganh == maNganh).toList();
  }

  List<MonHocModel> filterByTinChi(int soTinChi) {
    return danhSachMon.where((m) => m.soTinChi == soTinChi).toList();
  }

  List<MonHocModel> search(String keyword) {
    return danhSachMon
        .where((m) =>
    m.tenMon.toLowerCase().contains(keyword.toLowerCase()) ||
        m.maSoMon.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }
}
