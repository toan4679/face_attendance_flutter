import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/giangvien_controller.dart';
import '../../data/models/buoihoc_model.dart';

class LichDayScreen extends StatefulWidget {
  final dynamic giangVien; // truyền cả object hoặc null
  final int? maGV;         // truyền trực tiếp id nếu muốn
  const LichDayScreen({super.key, this.giangVien, this.maGV});

  @override
  State<LichDayScreen> createState() => _LichDayScreenState();
}

class _LichDayScreenState extends State<LichDayScreen> {
  late final GiangVienController controller;

  @override
  void initState() {
    super.initState();
    controller = GiangVienController();
    final maGV = widget.maGV ?? widget.giangVien?.maGV ?? 0;
    controller.fetchLichDayHomNay(maGV);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<GiangVienController>(
        builder: (context, controller, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Lịch dạy hôm nay'),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: _buildBody(controller),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(GiangVienController controller) {
    if (controller.loadingLichDay) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorLichDay != null) {
      return Center(
        child: Text(
          'Lỗi: ${controller.errorLichDay}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (controller.lichDayHomNay.isEmpty) {
      return const Center(
        child: Text(
          'Hôm nay không có lịch dạy',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      itemCount: controller.lichDayHomNay.length,
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final BuoiHoc b = controller.lichDayHomNay[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent.withOpacity(0.2),
              child: const Icon(Icons.class_outlined, color: Colors.blue),
            ),
            title: Text(
              b.tenMon,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Lớp học phần: ${b.maSoLopHP}'),
                Text('Phòng: ${b.phongHoc}'),
                Text('Thời gian: ${b.gioBatDau} - ${b.gioKetThuc}'),
                Text('Ngày: ${b.ngayHoc}'),
              ],
            ),
          ),
        );
      },
    );
  }
}