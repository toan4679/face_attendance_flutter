import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/giangvien_model.dart';
import '../../data/models/khoa_model.dart';
import '../controllers/assign_schedule_controller.dart';
import '../widgets/view_schedule_screen.dart';
import 'assign_schedule_select_screen.dart';

class AssignScheduleScreen extends StatefulWidget {
  const AssignScheduleScreen({super.key});

  @override
  State<AssignScheduleScreen> createState() => _AssignScheduleScreenState();
}

class _AssignScheduleScreenState extends State<AssignScheduleScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final controller = context.read<AssignScheduleController>();
    controller.loadKhoa(); // Tải danh sách khoa khi vào màn
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AssignScheduleController>();

    // Lọc giảng viên theo tên
    final filteredGVList = controller.giangVienList
        .where((gv) =>
        gv.hoTen.toLowerCase().contains(_searchController.text.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FC),
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          'Gán lịch giảng dạy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Chọn Khoa
            DropdownButtonFormField<KhoaModel>(
              decoration: const InputDecoration(
                labelText: 'Chọn Khoa',
                border: OutlineInputBorder(),
              ),
              value: (controller.selectedKhoaId == null ||
                  controller.khoaList.isEmpty)
                  ? null
                  : controller.khoaList.firstWhere(
                    (k) => k.maKhoa == controller.selectedKhoaId,
                orElse: () => controller.khoaList.isNotEmpty
                    ? controller.khoaList.first
                    : KhoaModel(maKhoa: 0, tenKhoa: 'Chưa có dữ liệu'),
              ),
              items: controller.khoaList
                  .map<DropdownMenuItem<KhoaModel>>(
                    (k) => DropdownMenuItem<KhoaModel>(
                  value: k,
                  child: Text(k.tenKhoa),
                ),
              )
                  .toList(),
              onChanged: (khoa) {
                if (khoa != null) {
                  debugPrint('🟣 Đã chọn khoa: ${khoa.tenKhoa}');
                  controller.loadGiangVienTheoKhoa(khoa.maKhoa!);
                }
              },
            ),
            const SizedBox(height: 20),

            /// 🔹 Ô tìm kiếm
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm giảng viên theo tên...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),

            /// 🔹 Danh sách giảng viên
            Expanded(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredGVList.isEmpty
                  ? const Center(
                child: Text(
                  'Không có giảng viên nào trong khoa này.',
                  style:
                  TextStyle(color: Colors.black54, fontSize: 16),
                ),
              )
                  : Scrollbar(
                thumbVisibility: true,
                radius: const Radius.circular(8),
                child: ListView.separated(
                  itemCount: filteredGVList.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final gv = filteredGVList[index];
                    return _buildGiangVienCard(context, gv);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🧱 Card hiển thị thông tin giảng viên
  Widget _buildGiangVienCard(BuildContext context, GiangVienModel gv) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFFDDE3F0),
              child: Icon(Icons.person, size: 32, color: Colors.black54),
            ),
            const SizedBox(width: 16),

            /// Thông tin giảng viên
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gv.hoTen,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Text('ID: ${gv.maGV}',
                      style: const TextStyle(color: Colors.black54)),
                  Text('Email: ${gv.email ?? 'Không có'}',
                      style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),

            /// Hành động
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.event_note, size: 18),
                  label: const Text('GÁN LỊCH DẠY'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AssignScheduleSelectScreen(giangVien: gv),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.schedule, size: 18),
                  label: const Text('XEM LỊCH DẠY'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewScheduleScreen(giangVien: gv),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}