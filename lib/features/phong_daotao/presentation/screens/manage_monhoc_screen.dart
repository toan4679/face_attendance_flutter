import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/nganh_repository.dart';
import '../controllers/mon_hoc_controller.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../data/models/mon_hoc_model.dart';
import '../../data/models/nganh_model.dart';
import '../widgets/monhoc_form_dialog.dart';
import '../widgets/monhoc_table.dart';

class ManageMonHocScreen extends StatefulWidget {
  const ManageMonHocScreen({super.key});

  @override
  State<ManageMonHocScreen> createState() => _ManageMonHocScreenState();
}

class _ManageMonHocScreenState extends State<ManageMonHocScreen> {
  String searchText = '';
  int? filterNganh;
  bool isLoadingNganh = true;
  List<NganhModel> danhSachNganh = [];

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    final controller = context.read<MonHocController>();
    setState(() => isLoadingNganh = true);

    await controller.fetchMonHoc();
    try {
      danhSachNganh = await NganhRepository().getAll();
      debugPrint("✅ Đã tải ${danhSachNganh.length} ngành học");
    } catch (e) {
      debugPrint("❌ Lỗi load ngành: $e");
    } finally {
      setState(() => isLoadingNganh = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MonHocController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Môn học'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: controller.isLoading || isLoadingNganh
          ? const Center(child: LoadingIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== THANH TÌM KIẾM + BỘ LỌC ====================
            Row(
              children: [
                Expanded(
                  flex: 2,
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
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<int>(
                    value: filterNganh,
                    decoration: const InputDecoration(
                      labelText: "Lọc theo ngành",
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem<int>(
                        value: null,
                        child: Text("Tất cả ngành"),
                      ),
                      ...danhSachNganh.map((n) => DropdownMenuItem<int>(
                        value: n.maNganh,
                        child: Text(n.tenNganh),
                      )),
                    ],
                    onChanged: (val) =>
                        setState(() => filterNganh = val),
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
                      _showDialog(context, '✅ Thêm môn học thành công!');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ==================== BẢNG DỮ LIỆU CUỘN NGANG + DỌC ====================
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width),
                    child: MonHocTable(
                      monHocs: _filteredList(controller),
                      onEdit: (monHoc) async {
                        final success = await showDialog(
                          context: context,
                          builder: (_) => MonHocFormDialog(monHoc: monHoc),
                        );
                        if (success == true) {
                          await controller.fetchMonHoc();
                          _showDialog(context, '✏️ Cập nhật thành công!');
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
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent),
                                child: const Text('Xóa'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await controller.deleteMonHoc(monHoc.maMon);
                          _showDialog(context, '🗑️ Xóa thành công!');
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

  /// 📊 Kết hợp tìm kiếm + lọc ngành
  List<MonHocModel> _filteredList(MonHocController controller) {
    var list = controller.search(searchText);
    if (filterNganh != null) {
      list = list.where((m) => m.maNganh == filterNganh).toList();
    }
    return list;
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
