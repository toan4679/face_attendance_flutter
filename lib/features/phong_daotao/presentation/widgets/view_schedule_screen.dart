import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/buoi_hoc_model.dart';
import '../../data/models/giangvien_model.dart';
import '../controllers/assign_schedule_controller.dart';

class ViewScheduleScreen extends StatefulWidget {
  final GiangVienModel giangVien;

  const ViewScheduleScreen({super.key, required this.giangVien});

  @override
  State<ViewScheduleScreen> createState() => _ViewScheduleScreenState();
}

class _ViewScheduleScreenState extends State<ViewScheduleScreen> {
  List<BuoiHocModel> buoiHocList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final controller = context.read<AssignScheduleController>();
    final all = await controller.buoiHocRepo.getList();

    setState(() {
      buoiHocList = all.where((b) => b.maGV == widget.giangVien.maGV).toList();
      isLoading = false;
    });
  }

  /// 🧱 Hàm hiển thị hộp xác nhận gỡ lịch
  Future<void> _confirmRemove(BuildContext context, BuoiHocModel buoiHoc) async {
    final controller = context.read<AssignScheduleController>();

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận gỡ lịch dạy'),
        content: Text(
          'Bạn có chắc muốn gỡ buổi học "${buoiHoc.lopHocPhan?['maSoLopHP'] ?? 'Không rõ'}" '
              'ra khỏi giảng viên ${widget.giangVien.hoTen} không?',
        ),
        actions: [
          TextButton(
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        // 🧩 Gỡ lịch bằng cách set maGV = null
        await controller.buoiHocRepo.update(buoiHoc.maBuoi, {
          'maGV': null,
        });

        setState(() {
          buoiHocList.removeWhere((b) => b.maBuoi == buoiHoc.maBuoi);
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Đã gỡ buổi học khỏi giảng viên.'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Lỗi khi gỡ buổi học: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FC),
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text('Lịch dạy - ${widget.giangVien.hoTen}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: buoiHocList.isEmpty
            ? const Center(
          child: Text(
            '⛔ Giảng viên này chưa được gán buổi học nào.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh sách buổi học (${buoiHocList.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                        Colors.deepPurple.shade50),
                    columns: const [
                      DataColumn(label: Text('Lớp học phần')),
                      DataColumn(label: Text('Môn học')),
                      DataColumn(label: Text('Thứ')),
                      DataColumn(label: Text('Tiết bắt đầu')),
                      DataColumn(label: Text('Tiết kết thúc')),
                      DataColumn(label: Text('Phòng học')),
                      DataColumn(label: Text('Hành động')),
                    ],
                    rows: buoiHocList.map((b) {
                      final lopHP =
                          b.lopHocPhan?['maSoLopHP'] ?? '—';
                      final tenMon =
                          b.lopHocPhan?['mon_hoc']?['tenMon'] ??
                              '—';
                      return DataRow(cells: [
                        DataCell(Text(lopHP)),
                        DataCell(Text(tenMon)),
                        DataCell(Text(b.thu)),
                        DataCell(Text('${b.tietBatDau}')),
                        DataCell(Text('${b.tietKetThuc}')),
                        DataCell(Text(b.phongHoc)),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            tooltip: 'Gỡ buổi học này',
                            onPressed: () =>
                                _confirmRemove(context, b),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
