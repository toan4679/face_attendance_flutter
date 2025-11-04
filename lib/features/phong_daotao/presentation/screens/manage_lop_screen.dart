import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/lop_controller.dart';
import '../widgets/lop_table.dart';
import '../widgets/lop_form_dialog.dart';

class ManageLopScreen extends StatefulWidget {
  const ManageLopScreen({super.key});

  @override
  State<ManageLopScreen> createState() => _ManageLopScreenState();
}

class _ManageLopScreenState extends State<ManageLopScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    context.read<LopController>().fetchLop();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LopController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Lớp học'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Tìm kiếm lớp học...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => setState(() => searchText = v),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm lớp'),
                  onPressed: () async {
                    final success = await showDialog(
                      context: context,
                      builder: (_) => const LopFormDialog(),
                    );
                    if (success == true) {
                      _showDialog(context, 'Thêm lớp học thành công!');
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width),
                    child: LopTable(
                      lops: controller.search(searchText),
                      onEdit: (lop) async {
                        final success = await showDialog(
                          context: context,
                          builder: (_) => LopFormDialog(lop: lop),
                        );
                        if (success == true) {
                          _showDialog(
                              context, 'Cập nhật lớp học thành công!');
                        }
                      },
                      onDelete: (lop) async {
                        final confirm = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Xác nhận xóa'),
                            content: Text(
                                'Bạn có chắc muốn xóa lớp "${lop.tenLop}" không?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text('Hủy'),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text('Xóa'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await controller.deleteLop(lop.maLop);
                          _showDialog(
                              context, 'Xóa lớp học thành công!');
                        }
                      },
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

  void _showDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Thông báo'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
