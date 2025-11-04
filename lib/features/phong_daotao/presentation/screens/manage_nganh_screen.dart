import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../controllers/nganh_controller.dart';
import '../widgets/nganh_form_dialog.dart';

class ManageNganhScreen extends StatefulWidget {
  const ManageNganhScreen({super.key});

  @override
  State<ManageNganhScreen> createState() => _ManageNganhScreenState();
}

class _ManageNganhScreenState extends State<ManageNganhScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NganhController>().fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<NganhController>();

    // 🔍 Lọc danh sách theo tên ngành
    final filteredList = controller.danhSach.where((nganh) {
      final query = _searchController.text.toLowerCase();
      return query.isEmpty ||
          nganh.tenNganh.toLowerCase().contains(query) ||
          nganh.maSo.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý Ngành"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      backgroundColor: const Color(0xFFF8F9FC),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔎 Thanh tìm kiếm + nút thêm
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm ngành theo tên hoặc mã số...",
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("Thêm ngành",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    final added = await showDialog<bool>(
                      context: context,
                      builder: (_) => const NganhFormDialog(),
                    );
                    if (added == true && context.mounted) {
                      controller.fetchAll();
                      _showSnack(context, "✅ Thêm ngành thành công!");
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🧩 Khu vực bảng hiển thị
            Expanded(
              child: controller.isLoading
                  ? const Center(child: LoadingIndicator())
                  : filteredList.isEmpty
                  ? const Center(child: Text("Không có dữ liệu ngành."))
                  : Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    // ✅ bỏ ConstrainedBox và bọc DataTable trong Container full width
                    child: Container(
                      width: MediaQuery.of(context).size.width, // ✅ FULL chiều rộng
                      padding: const EdgeInsets.all(8),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                            Colors.deepPurple.shade50),
                        columnSpacing: 24,
                        columns: const [
                          DataColumn(label: Text("Mã ngành")),
                          DataColumn(label: Text("Mã số")),
                          DataColumn(label: Text("Tên ngành")),
                          DataColumn(label: Text("Mô tả")),
                          DataColumn(label: Text("Hành động")),
                        ],
                        rows: filteredList.map((nganh) {
                          return DataRow(cells: [
                            DataCell(Text(nganh.maNganh.toString())),
                            DataCell(Text(nganh.maSo)),
                            DataCell(Text(nganh.tenNganh)),
                            DataCell(Text(nganh.moTa ?? '')),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blueAccent),
                                  onPressed: () async {
                                    final updated = await showDialog<bool>(
                                      context: context,
                                      builder: (_) =>
                                          NganhFormDialog(nganh: nganh),
                                    );
                                    if (updated == true && context.mounted) {
                                      controller.fetchAll();
                                      _showSnack(context,
                                          "✏️ Cập nhật ngành thành công!");
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () async {
                                    final confirm =
                                    await _confirmDelete(context);
                                    if (confirm == true && context.mounted) {
                                      await controller
                                          .deleteNganh(nganh.maNganh);
                                      controller.fetchAll();
                                      _showSnack(context,
                                          "🗑️ Xóa ngành thành công!");
                                    }
                                  },
                                ),
                              ],
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: const Text("Bạn có chắc muốn xóa ngành này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style:
            ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("Xóa"),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
