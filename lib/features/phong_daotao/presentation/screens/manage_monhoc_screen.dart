import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/mon_hoc_controller.dart';
import '../widgets/monhoc_table.dart';
import '../widgets/monhoc_form_dialog.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../data/models/mon_hoc_model.dart';

class ManageMonHocScreen extends StatefulWidget {
  const ManageMonHocScreen({super.key});

  @override
  State<ManageMonHocScreen> createState() => _ManageMonHocScreenState();
}

class _ManageMonHocScreenState extends State<ManageMonHocScreen> {
  String searchText = '';
  int? filterTinChi;
  int? filterNganh;

  @override
  void initState() {
    super.initState();
    context.read<MonHocController>().fetchMonHoc();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MonHocController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Môn học'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thanh tìm kiếm + nút thêm
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Tìm kiếm môn học...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) =>
                        setState(() => searchText = value),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm môn học'),
                  onPressed: () async {
                    final success = await showDialog(
                      context: context,
                      builder: (_) => const MonHocFormDialog(),
                    );
                    if (success == true) {
                      await controller.fetchMonHoc();
                      _showDialog(context, 'Thêm môn học thành công!');
                    }
                  },
                )
              ],
            ),
            const SizedBox(height: 16),

            // Bảng dữ liệu có thể cuộn và tràn chiều rộng
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width),
                    child: MonHocTable(
                      monHocs: controller.search(searchText),
                      onEdit: (monHoc) async {
                        final success = await showDialog(
                          context: context,
                          builder: (_) =>
                              MonHocFormDialog(monHoc: monHoc),
                        );
                        if (success == true) {
                          _showDialog(
                              context, 'Cập nhật môn học thành công!');
                        }
                      },
                      onDelete: (monHoc) async {
                        final confirm = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Xác nhận xóa'),
                            content: Text(
                                'Bạn có chắc chắn muốn xóa môn "${monHoc.tenMon}" không?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Hủy'),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Xóa'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await controller.deleteMonHoc(monHoc.maMon);
                          _showDialog(
                              context, 'Xóa môn học thành công!');
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
          )
        ],
      ),
    );
  }
}
