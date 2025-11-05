import 'package:flutter/material.dart';
import '../../data/models/buoi_hoc_model.dart';
import '../../data/repositories/buoihoc_repository.dart';

class BuoiHocController extends ChangeNotifier {
  final BuoiHocRepository repository;
  BuoiHocController({required this.repository});

  bool isLoading = false;
  List<BuoiHocModel> list = [];

  // Lựa chọn filter
  int? selectedMaMon;
  int? selectedMaLopHP;
  int? selectedMaGV;

  Future<void> loadByLopHP(int maLopHP) async {
    try {
      isLoading = true; notifyListeners();
      print('[DEBUG] 📡 Fetch buoihoc by LHP=$maLopHP');
      list = await repository.getList(maLopHP: maLopHP);
      print('[DEBUG] ✅ Loaded ${list.length} buổi học');
    } catch (e) {
      print('[ERROR] ❌ loadByLopHP: $e');
      list = [];
    } finally {
      isLoading = false; notifyListeners();
    }
  }

  Future<void> add(Map<String, dynamic> body, BuildContext context) async {
    try {
      await repository.create(body);
      if (selectedMaLopHP != null) await loadByLopHP(selectedMaLopHP!);
      _snack(context, '✅ Thêm buổi học thành công', Colors.green);
    } catch (e) {
      print('[ERROR] ❌ add buoihoc: $e');
      _snack(context, '❌ Thêm buổi học thất bại', Colors.redAccent);
    }
  }

  Future<void> update(int id, Map<String, dynamic> body, BuildContext context) async {
    try {
      await repository.update(id, body);
      if (selectedMaLopHP != null) await loadByLopHP(selectedMaLopHP!);
      _snack(context, '✅ Cập nhật buổi học thành công', Colors.blueAccent);
    } catch (e) {
      print('[ERROR] ❌ update buoihoc: $e');
      _snack(context, '❌ Cập nhật buổi học thất bại', Colors.redAccent);
    }
  }

  Future<void> remove(int id, BuildContext context) async {
    try {
      await repository.delete(id);
      if (selectedMaLopHP != null) await loadByLopHP(selectedMaLopHP!);
      _snack(context, '🗑 Xóa buổi học thành công', Colors.orangeAccent);
    } catch (e) {
      print('[ERROR] ❌ delete buoihoc: $e');
      _snack(context, '❌ Xóa buổi học thất bại', Colors.redAccent);
    }
  }

  void _snack(BuildContext ctx, String msg, Color c) {
    if (!ctx.mounted) return;
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: c, duration: const Duration(seconds: 2)),
    );
  }
}
