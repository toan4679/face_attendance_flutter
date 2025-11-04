import 'package:flutter/material.dart';
import '../../data/models/lop_model.dart';
import '../../data/repositories/lop_repository.dart';


class LopController extends ChangeNotifier {
  final LopRepository _repo = LopRepository();
  List<LopModel> _lops = [];
  bool _isLoading = false;

  List<LopModel> get lops => _lops;
  bool get isLoading => _isLoading;

  Future<void> fetchLop() async {
    _isLoading = true;
    notifyListeners();
    _lops = await _repo.fetchLop();
    _isLoading = false;
    notifyListeners();
  }

  List<LopModel> search(String text) {
    if (text.isEmpty) return _lops;
    return _lops
        .where((l) =>
    l.tenLop.toLowerCase().contains(text.toLowerCase()) ||
        l.maLop.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  Future<void> addLop(LopModel lop) async {
    await _repo.addLop(lop);
    await fetchLop();
  }

  Future<void> updateLop(LopModel lop) async {
    await _repo.updateLop(lop);
    await fetchLop();
  }

  Future<void> deleteLop(String maLop) async {
    await _repo.deleteLop(maLop);
    await fetchLop();
  }
}
