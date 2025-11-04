import 'package:flutter/material.dart';
import '../../data/models/nganh_model.dart';
import '../../data/repositories/nganh_repository.dart';

class NganhController with ChangeNotifier {
  final _repo = NganhRepository();
  List<NganhModel> danhSach = [];
  bool isLoading = false;

  Future<void> fetchAll() async {
    isLoading = true;
    notifyListeners();
    try {
      danhSach = await _repo.getAll();
    } catch (e) {
      debugPrint('❌ Lỗi fetch ngành: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNganh(NganhModel nganh) async {
    await _repo.create(nganh);
    await fetchAll();
  }

  Future<void> updateNganh(int id, NganhModel nganh) async {
    await _repo.update(id, nganh);
    await fetchAll();
  }

  Future<void> deleteNganh(int id) async {
    await _repo.delete(id);
    await fetchAll();
  }
}
