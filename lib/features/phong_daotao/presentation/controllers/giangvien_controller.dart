import 'package:flutter/material.dart';
import '../../data/models/giangvien_model.dart';
import '../../data/repositories/giangvien_repository.dart';

class GiangVienController extends ChangeNotifier {
  final GiangVienRepository repository;
  GiangVienController({required this.repository});

  bool isLoading = false;
  List<GiangVienModel> giangVienList = [];

  Future<void> fetchGiangVienList() async {
    try {
      isLoading = true; notifyListeners();
      print('[DEBUG] 📡 Fetching giảng viên...');
      giangVienList = await repository.getAll();
      print('[DEBUG] ✅ Loaded ${giangVienList.length} giảng viên');
    } catch (e) {
      print('[ERROR] ❌ fetchGiangVienList: $e');
    } finally {
      isLoading = false; notifyListeners();
    }
  }
}
