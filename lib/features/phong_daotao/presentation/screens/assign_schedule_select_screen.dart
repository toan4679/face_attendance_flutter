import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/giangvien_model.dart';
import '../controllers/assign_schedule_controller.dart';

class AssignScheduleSelectScreen extends StatefulWidget {
  final GiangVienModel giangVien;
  const AssignScheduleSelectScreen({super.key, required this.giangVien});

  @override
  State<AssignScheduleSelectScreen> createState() =>
      _AssignScheduleSelectScreenState();
}

class _AssignScheduleSelectScreenState
    extends State<AssignScheduleSelectScreen> {
  String searchText = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<AssignScheduleController>().loadBuoiHocChuaGan());
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AssignScheduleController>();
    final filteredList = controller.allBuoiHoc
        .where((b) =>
    b.phongHoc.toLowerCase().contains(searchText.toLowerCase()) ||
        b.thu.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gán buổi học - ${widget.giangVien.hoTen}'),
        backgroundColor: const Color(0xFF6A4BBC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 Ô tìm kiếm
            TextField(
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm môn học, lớp, phòng...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => searchText = v),
            ),
            const SizedBox(height: 16),

            // 📋 Danh sách buổi học
            Expanded(
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredList.isEmpty
                  ? const Center(child: Text('Không có buổi học nào khả dụng.'))
                  : ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, i) {
                  final b = filteredList[i];
                  final isSelected =
                  controller.selectedBuoiIds.contains(b.maBuoi);
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Checkbox(
                        value: isSelected,
                        onChanged: (_) =>
                            controller.toggleBuoiHoc(b.maBuoi),
                      ),
                      title: Text(
                          '${b.thu} - Tiết ${b.tietBatDau}-${b.tietKetThuc}'),
                      subtitle: Text(
                          'Phòng: ${b.phongHoc} | LHP: ${b.maLopHP}'),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle,
                          color: Colors.green)
                          : null,
                    ),
                  );
                },
              ),
            ),

            // 🔘 Nút Lưu thay đổi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A4BBC),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Lưu thay đổi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  controller.assignBuoiHocToGiangVien(context, widget.giangVien);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}