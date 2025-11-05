import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../controllers/lop_controller.dart';
import '../widgets/lop_form_dialog.dart';
import '../widgets/lop_sinhvien_dialog.dart';

class ManageLopScreen extends StatefulWidget {
  const ManageLopScreen({super.key});

  @override
  State<ManageLopScreen> createState() => _ManageLopScreenState();
}

class _ManageLopScreenState extends State<ManageLopScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LopController>().fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LopController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Lớp học'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      backgroundColor: const Color(0xFFF8F9FC),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: controller.updateSearch,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tìm kiếm lớp theo tên hoặc ngành...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    final dsNganh = await controller.fetchDanhSachNganh();
                    debugPrint('📥 [UI] dsNganh=${dsNganh.length}');
                    final added = await showDialog<bool>(
                      context: context,
                      builder: (_) => LopFormDialog(
                        danhSachNganh: dsNganh,
                        onSubmit: (data) async {
                          debugPrint('📤 [UI] Gửi thêm lớp: $data');
                          await controller.addLop(data);
                        },
                      ),
                    );
                    if (added == true) {
                      _showSnack('✅ Thêm lớp thành công');
                    }
                  } catch (e) {
                    debugPrint('❌ [UI] Thêm lớp lỗi: $e');
                    _showSnack('❌ Thêm thất bại: $e');
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Thêm lớp học'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: controller.isLoading
                  ? const LoadingIndicator()
                  : controller.filteredLop.isEmpty
                  ? const Center(child: Text('Không có dữ liệu lớp học.'))
                  : Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 1100),
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                            Colors.deepPurple.shade50),
                        columnSpacing: 60,
                        border: TableBorder.all(
                            color: Colors.grey.shade300, width: 1),
                        columns: const [
                          DataColumn(label: Text('Mã lớp')),
                          DataColumn(label: Text('Tên lớp')),
                          DataColumn(label: Text('Khóa học')),
                          DataColumn(label: Text('Ngành')),
                          DataColumn(label: Text('Hành động')),
                        ],
                        rows: controller.filteredLop.map((lop) {
                          return DataRow(
                            cells: [
                              DataCell(Text(lop.maLop.toString())),
                              DataCell(Text(lop.tenLop)),
                              DataCell(Text(lop.khoaHoc)),
                              DataCell(Text(lop.tenNganh)),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.group,
                                        color: Colors.teal),
                                    tooltip: 'Xem sinh viên',
                                    onPressed: () async {
                                      final list = await controller.getSinhVienByLop(lop.maLop);
                                      if (!context.mounted) return;
                                      showDialog(
                                        context: context,
                                        builder: (_) => LopSinhVienDialog(
                                          tenLop: lop.tenLop,
                                          sinhVienList: list,
                                          onImport: (fileInput) async {
                                            await controller.importSinhVienExcel(lop.maLop, fileInput);
                                            _showSnack('📥 Import thành công!');
                                            Navigator.pop(context);
                                            final updated = await controller.getSinhVienByLop(lop.maLop);
                                            showDialog(
                                              context: context,
                                              builder: (_) => LopSinhVienDialog(
                                                tenLop: lop.tenLop,
                                                sinhVienList: updated,
                                                onImport: (f) async {
                                                  await controller.importSinhVienExcel(lop.maLop, f);
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    tooltip: 'Sửa lớp học',
                                    onPressed: () async {
                                      try {
                                        final dsNganh = await controller.fetchDanhSachNganh();
                                        final updated = await showDialog<bool>(
                                          context: context,
                                          builder: (_) => LopFormDialog(
                                            lop: lop,
                                            danhSachNganh: dsNganh,
                                            onSubmit: (data) async {
                                              debugPrint('📤 [UI] Gửi update lớp #${lop.maLop}: $data');
                                              await controller.updateLop(lop.maLop, data);
                                            },
                                          ),
                                        );
                                        if (updated == true) {
                                          _showSnack('✏️ Cập nhật thành công');
                                        }
                                      } catch (e) {
                                        debugPrint('❌ [UI] Sửa lớp lỗi: $e');
                                        _showSnack('❌ Cập nhật thất bại: $e');
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    tooltip: 'Xóa lớp học',
                                    onPressed: () async {
                                      final confirm = await _confirmDelete();
                                      if (confirm == true) {
                                        try {
                                          await controller.deleteLop(lop.maLop);
                                          _showSnack('🗑️ Xóa thành công');
                                        } catch (e) {
                                          _showSnack('❌ Xóa thất bại: $e');
                                        }
                                      }
                                    },
                                  ),
                                ],
                              )),
                            ],
                          );
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

  Future<bool?> _confirmDelete() {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa lớp này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
