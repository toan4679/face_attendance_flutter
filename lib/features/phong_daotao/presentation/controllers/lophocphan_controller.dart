import 'package:flutter/material.dart';
import '../../data/repositories/lophocphan_repository.dart';
import '../../data/models/lop_hoc_phan_model.dart';

class LopHocPhanController extends ChangeNotifier {
  final LopHocPhanRepository repository;

  LopHocPhanController({required this.repository});

  bool isLoading = false;
  List<LopHocPhanModel> lopHocPhanList = [];

  // 🔹 Lấy danh sách lớp học phần
  Future<void> fetchLopHocPhanList() async {
    try {
      isLoading = true;
      notifyListeners();
      lopHocPhanList = await repository.getAll();
      print('[DEBUG] ✅ Tải ${lopHocPhanList.length} lớp học phần');
    } catch (e) {
      print('[ERROR] ❌ fetchLopHocPhanList: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Thêm lớp học phần
  Future<void> addLopHocPhan(Map<String, dynamic> data, BuildContext context) async {
    try {
      await repository.create(data);
      await fetchLopHocPhanList();
      _showSnack(context, '✅ Thêm lớp học phần thành công', Colors.green);
    } catch (e) {
      print('[ERROR] ❌ addLopHocPhan: $e');
      _showSnack(context, '❌ Thêm lớp học phần thất bại', Colors.redAccent);
    }
  }

  // 🔹 Cập nhật lớp học phần
  Future<void> updateLopHocPhan(int id, Map<String, dynamic> data, BuildContext context) async {
    try {
      await repository.update(id, data);
      await fetchLopHocPhanList();
      _showSnack(context, '✅ Cập nhật lớp học phần thành công', Colors.blueAccent);
    } catch (e) {
      print('[ERROR] ❌ updateLopHocPhan: $e');
      _showSnack(context, '❌ Cập nhật thất bại', Colors.redAccent);
    }
  }

  // 🔹 Xóa lớp học phần
  Future<void> deleteLopHocPhan(int id, BuildContext context) async {
    try {
      await repository.delete(id);
      await fetchLopHocPhanList();
      _showSnack(context, '🗑 Xóa lớp học phần thành công', Colors.orange);
    } catch (e) {
      print('[ERROR] ❌ deleteLopHocPhan: $e');
      _showSnack(context, '❌ Xóa thất bại', Colors.redAccent);
    }
  }

  // 🔹 Lấy danh sách lớp hành chính
  Future<List<Map<String, dynamic>>> fetchDanhSachLopHanhChinh() async {
    try {
      final list = await repository.getDanhSachLopHanhChinh();
      print('[DEBUG] 📘 Có ${list.length} lớp hành chính');
      return list;
    } catch (e) {
      print('[ERROR] ❌ fetchDanhSachLopHanhChinh: $e');
      return [];
    }
  }

  // 🔹 Lấy danh sách lớp hành chính đã gán cho lớp học phần
  Future<List<int>> fetchLopDaGan(int maLopHP) async {
    try {
      final data = await repository.getSinhVienByLopHocPhan(maLopHP);
      final ds = data['dsMaLop'];

      if (ds is List) {
        return ds.map((e) => int.tryParse(e.toString()) ?? 0).where((e) => e > 0).toList();
      }
      if (ds is String) {
        // server trả về "1,2,3"
        return ds
            .split(',')
            .map((e) => int.tryParse(e.trim()) ?? 0)
            .where((e) => e > 0)
            .toList();
      }
      return [];
    } catch (e) {
      print('[ERROR] ❌ fetchLopDaGan: $e');
      return [];
    }
  }

  // 🔹 Gán hoặc gỡ lớp hành chính
  Future<void> ganLopHanhChinh(int maLopHP, List<int> dsMaLop, BuildContext context) async {
    try {
      print('[DEBUG] 🔗 Gán lớp hành chính $dsMaLop cho lớp học phần $maLopHP');
      await repository.ganLopHanhChinh(maLopHP, dsMaLop);
      _showSnack(context, '✅ Cập nhật danh sách lớp hành chính thành công', Colors.green);
    } catch (e) {
      print('[ERROR] ❌ ganLopHanhChinh: $e');
      _showSnack(context, '❌ Gán lớp hành chính thất bại', Colors.redAccent);
    }
  }

  // 🔹 Xem danh sách sinh viên trong lớp học phần
  // 🔹 Xem danh sách sinh viên trong lớp học phần
  Future<void> xemSinhVienLopHocPhan(int maLopHP, BuildContext context) async {
    try {
      final res = await repository.getSinhVienByLopHocPhan(maLopHP);

      // 🧩 Ép kiểu an toàn
      final sinhVienList = (res['sinhVien'] is List)
          ? List<Map<String, dynamic>>.from(
          (res['sinhVien'] as List).map((e) => Map<String, dynamic>.from(e)))
          : [];

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Danh sách sinh viên'),
          content: SizedBox(
            width: 500,
            height: 400,
            child: sinhVienList.isEmpty
                ? const Center(
              child: Text(
                'Lớp học phần chưa có sinh viên',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
                : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('Mã SV')),
                  DataColumn(label: Text('Họ tên')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Mã lớp')),
                ],
                rows: sinhVienList.map((sv) {
                  return DataRow(cells: [
                    DataCell(Text(sv['maSo']?.toString() ?? '—')),
                    DataCell(Text(sv['hoTen'] ?? '—')),
                    DataCell(Text(sv['email'] ?? '—')),
                    DataCell(Text(sv['maLop']?.toString() ?? '—')),
                  ]);
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('[ERROR] ❌ xemSinhVienLopHocPhan: $e');
      _showSnack(context, '❌ Không thể tải danh sách sinh viên', Colors.redAccent);
    }
  }


  // 🔹 Hàm hiển thị snackbar
  void _showSnack(BuildContext context, String msg, Color color) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: color),
      );
    }
  }
}
