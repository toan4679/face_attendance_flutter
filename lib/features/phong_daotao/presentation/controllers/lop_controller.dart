import 'package:flutter/material.dart';
import '../../data/models/lop_model.dart';
import '../../data/models/nganh_model.dart';
import '../../data/models/sinhvien_model.dart';
import '../../data/repositories/lop_repository.dart';
import '../../data/repositories/nganh_repository.dart';


class LopController extends ChangeNotifier {
  final LopRepository _repo = LopRepository();
  final NganhRepository _nganhRepo = NganhRepository();

  bool isLoading = false;
  List<LopModel> danhSachLop = [];
  List<LopModel> filteredLop = [];

  // ===== Fetch lớp =====
  Future<void> fetchAll() async {
    try {
      isLoading = true;
      notifyListeners();
      danhSachLop = await _repo.getAll();
      filteredLop = danhSachLop;
      debugPrint('✅ Lấy ${danhSachLop.length} lớp học thành công');
    } catch (e) {
      debugPrint('❌ [Controller] fetchAll lỗi: $e');
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ===== Tìm kiếm =====
  void updateSearch(String keyword) {
    keyword = keyword.toLowerCase();
    filteredLop = danhSachLop.where((lop) {
      return lop.tenLop.toLowerCase().contains(keyword) ||
          lop.tenNganh.toLowerCase().contains(keyword);
    }).toList();
    notifyListeners();
  }

  // ===== Dropdown ngành =====
  Future<List<NganhModel>> fetchDanhSachNganh() async {
    try {
      final list = await _nganhRepo.getAll();
      debugPrint('✅ [Controller] dsNganh=${list.length}');
      return list;
    } catch (e) {
      debugPrint('❌ [Controller] fetchDanhSachNganh lỗi: $e');
      return [];
    }
  }

  // ===== CRUD lớp =====
  Future<void> addLop(Map<String, dynamic> data) async {
    debugPrint('🟢 [Controller] addLop payload: $data');
    await _repo.create(data);
    await fetchAll();
  }

  Future<void> updateLop(int id, Map<String, dynamic> data) async {
    debugPrint('🟠 [Controller] updateLop#$id payload: $data');
    await _repo.update(id, data);
    await fetchAll();
  }

  Future<void> deleteLop(int id) async {
    debugPrint('🔴 [Controller] deleteLop#$id');
    await _repo.delete(id);
    await fetchAll();
  }

  // ===== Sinh viên theo lớp =====
  Future<List<SinhVienModel>> getSinhVienByLop(int maLop) async {
    final list = await _repo.getSinhVienByLop(maLop);
    debugPrint('👥 [Controller] Lớp#$maLop có ${list.length} sinh viên');
    return list;
  }

  // ===== Import Excel =====
  Future<void> importSinhVienExcel(int maLop, dynamic fileInput) async {
    debugPrint('📤 [Controller] Import Excel lớp#$maLop, type=${fileInput.runtimeType}');
    await _repo.importSinhVienExcel(maLop, fileInput);
  }
}
