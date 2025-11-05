import 'package:flutter/material.dart';
import '../../data/repositories/lophocphan_repository.dart';
import '../../data/models/lop_hoc_phan_model.dart';

class LopHocPhanController extends ChangeNotifier {
  final LopHocPhanRepository repository;

  LopHocPhanController({required this.repository});

  bool isLoading = false;
  List<LopHocPhanModel> lopHocPhanList = [];

  Future<void> fetchLopHocPhanList() async {
    try {
      isLoading = true; notifyListeners();
      print('[DEBUG] 📡 Fetching lớp học phần list...');
      lopHocPhanList = await repository.getAll();
      print('[DEBUG] ✅ Loaded ${lopHocPhanList.length} lớp học phần');
    } catch (e) {
      print('[ERROR] ❌ fetchLopHocPhanList: $e');
    } finally {
      isLoading = false; notifyListeners();
    }
  }

  Future<void> addLopHocPhan(Map<String, dynamic> data, BuildContext context) async {
    try {
      print('[DEBUG] ➕ Adding lớp học phần...');
      await repository.create(data);
      await fetchLopHocPhanList();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('✅ Thêm lớp học phần thành công'),
          backgroundColor: Colors.green, duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
      print('[ERROR] ❌ addLopHocPhan: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('❌ Thêm lớp học phần thất bại'),
          backgroundColor: Colors.redAccent, duration: Duration(seconds: 2),
        ));
      }
    }
  }

  Future<void> updateLopHocPhan(int id, Map<String, dynamic> data, BuildContext context) async {
    try {
      print('[DEBUG] 🔧 Updating lớp học phần...');
      await repository.update(id, data);
      await fetchLopHocPhanList();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('✅ Cập nhật lớp học phần thành công'),
          backgroundColor: Colors.blueAccent, duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
      print('[ERROR] ❌ updateLopHocPhan: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('❌ Cập nhật lớp học phần thất bại'),
          backgroundColor: Colors.redAccent, duration: Duration(seconds: 2),
        ));
      }
    }
  }

  Future<void> deleteLopHocPhan(int id, BuildContext context) async {
    try {
      print('[DEBUG] 🗑 Deleting lớp học phần $id...');
      await repository.delete(id);
      await fetchLopHocPhanList();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('🗑 Xóa lớp học phần thành công'),
          backgroundColor: Colors.orangeAccent, duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
      print('[ERROR] ❌ deleteLopHocPhan: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('❌ Xóa lớp học phần thất bại'),
          backgroundColor: Colors.redAccent, duration: Duration(seconds: 2),
        ));
      }
    }
  }
}
