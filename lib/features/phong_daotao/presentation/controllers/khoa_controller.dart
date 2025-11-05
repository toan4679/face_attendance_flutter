import 'package:flutter/material.dart';
import '../../data/models/khoa_model.dart';
import '../../data/repositories/khoa_repository.dart';

class KhoaController extends ChangeNotifier {
  final KhoaRepository repository;
  List<KhoaModel> dsKhoa = [];
  bool isLoading = false;

  KhoaController(this.repository);

  Future<void> fetchKhoa() async {
    isLoading = true;
    notifyListeners();
    try {
      dsKhoa = await repository.getAll();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addKhoa(String tenKhoa, String? moTa) async {
    final newKhoa = KhoaModel(tenKhoa: tenKhoa, moTa: moTa);
    await repository.create(newKhoa);
    await fetchKhoa();
  }

  Future<void> updateKhoa(int id, String tenKhoa, String? moTa) async {
    final updated = KhoaModel(maKhoa: id, tenKhoa: tenKhoa, moTa: moTa);
    await repository.update(id, updated);
    await fetchKhoa();
  }

  Future<void> deleteKhoa(int id) async {
    await repository.delete(id);
    dsKhoa.removeWhere((k) => k.maKhoa == id);
    notifyListeners();
  }
}
