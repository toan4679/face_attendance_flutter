import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/lophocphan_controller.dart';
import '../widgets/lophocphan_form_dialog.dart';
import '../widgets/lophocphan_table.dart';

class ManageLopHocPhanScreen extends StatefulWidget {
  const ManageLopHocPhanScreen({super.key});

  @override
  State<ManageLopHocPhanScreen> createState() => _ManageLopHocPhanScreenState();
}

class _ManageLopHocPhanScreenState extends State<ManageLopHocPhanScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchKeyword = '';

  @override
  void initState() {
    super.initState();
    context.read<LopHocPhanController>().fetchLopHocPhanList();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LopHocPhanController>();

    final filteredList = controller.lopHocPhanList.where((lop) {
      final keyword = searchKeyword.toLowerCase();
      return lop.maSoLopHP.toLowerCase().contains(keyword) ||
          (lop.tenMon ?? '').toLowerCase().contains(keyword);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text(
          'Quản lý Lớp học phần',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Thanh tìm kiếm + nút thêm lớp học phần
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText:
                      'Tìm kiếm lớp học phần, mã hoặc tên môn học...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                    ),
                    onChanged: (value) =>
                        setState(() => searchKeyword = value),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm lớp học phần'),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => LopHocPhanFormDialog(
                      onSubmit: (data) =>
                          controller.addLopHocPhan(data, context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 📋 Bảng danh sách lớp học phần
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: LopHocPhanTable(
                  lopList: filteredList,
                  onEdit: (lop) => showDialog(
                    context: context,
                    builder: (context) => LopHocPhanFormDialog(
                      lop: lop,
                      onSubmit: (data) => controller.updateLopHocPhan(
                          lop.maLopHP, data, context),
                    ),
                  ),
                  onDelete: (lop) => controller.deleteLopHocPhan(
                      lop.maLopHP, context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
