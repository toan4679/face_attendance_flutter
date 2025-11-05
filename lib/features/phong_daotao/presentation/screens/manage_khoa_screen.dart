import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/khoa_controller.dart';
import '../widgets/khoa_form_dialog.dart';

class ManageKhoaScreen extends StatefulWidget {
  const ManageKhoaScreen({super.key});

  @override
  State<ManageKhoaScreen> createState() => _ManageKhoaScreenState();
}

class _ManageKhoaScreenState extends State<ManageKhoaScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<KhoaController>().fetchKhoa());
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<KhoaController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Khoa'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const KhoaFormDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            scrollDirection: Axis.horizontal, // ⬅️ Cho phép kéo ngang
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical, // ⬅️ Cho phép kéo dọc nếu dữ liệu nhiều
                child: DataTable(
                  headingRowColor:
                  WidgetStateProperty.all(Colors.deepPurple.shade50),
                  columns: const [
                    DataColumn(label: Text('Mã Khoa')),
                    DataColumn(label: Text('Tên Khoa')),
                    DataColumn(label: Text('Mô tả')),
                    DataColumn(label: Text('Hành động')),
                  ],
                  rows: controller.dsKhoa.map((khoa) {
                    return DataRow(cells: [
                      DataCell(Text(khoa.maKhoa?.toString() ?? '')),
                      DataCell(Text(khoa.tenKhoa)),
                      DataCell(Text(khoa.moTa ?? '—')),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blueAccent),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => KhoaFormDialog(khoa: khoa),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Xác nhận xóa Khoa'),
                                  content: Text('Bạn có chắc muốn xóa "${khoa.tenKhoa}" không?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: const Text('Hủy')),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent),
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text('Xóa')),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await controller.deleteKhoa(khoa.maKhoa!);
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
          );
        },
      ),

    );
  }
}
