import 'package:flutter/material.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../../data/models/sinhvien_model.dart'; // model + dữ liệu
import '../../data/models/buoihoc_model.dart'; // model BuoiHoc

class KetQuaDiemDanhScreen extends StatefulWidget {
  final BuoiHoc buoiHoc; // Buổi học từ trang DiemDanhScreen

  const KetQuaDiemDanhScreen({super.key, required this.buoiHoc});

  @override
  State<KetQuaDiemDanhScreen> createState() => _KetQuaDiemDanhScreenState();
}

class _KetQuaDiemDanhScreenState extends State<KetQuaDiemDanhScreen> {
  late List<SinhVien> danhSachSV;

  @override
  void initState() {
    super.initState();
    // Lấy danh sách sinh viên từ buổi học
    danhSachSV = widget.buoiHoc.danhSachSinhVien;
  }

  @override
  Widget build(BuildContext context) {
    int totalSV = danhSachSV.length;
    int coMat = danhSachSV
        .where((sv) => sv.trangThai == 'present' || sv.trangThai == 'late')
        .length;
    int vang = danhSachSV.where((sv) => sv.trangThai == 'absent').length;

    return Scaffold(
      backgroundColor: Colors.white,

      // ===== APPBAR =====
      appBar: AppBar(
        backgroundColor: const Color(0xFF154B71),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "KẾT QUẢ ĐIỂM DANH",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Chức năng thông báo đang được phát triển..."),
                ),
              );
            },
          ),
        ],
      ),

      // ===== BODY =====
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // THÔNG TIN LỚP
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Môn học: ${widget.buoiHoc.tenMon}",
                      style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 10),
                  Text("Lớp: ${widget.buoiHoc.lop}",
                      style: const TextStyle(color: Colors.black87, fontSize: 14)),
                  const SizedBox(height: 10),
                  Text("Thời gian: ${widget.buoiHoc.thoiGian ?? 'Chưa có'}",
                      style: const TextStyle(color: Colors.black87, fontSize: 14)),
                  const SizedBox(height: 10),
                  Text("Phòng học: ${widget.buoiHoc.phong}",
                      style: const TextStyle(color: Colors.black87, fontSize: 14)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==== Ô tóm tắt số sinh viên ====
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Có mặt",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "$coMat / $totalSV",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Vắng",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "$vang / $totalSV",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Trạng thái điểm danh",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),

            // ==== Danh sách sinh viên ====
            Expanded(
              child: ListView.builder(
                itemCount: danhSachSV.length,
                itemBuilder: (context, index) {
                  final sv = danhSachSV[index];
                  return _buildStudentCard(
                    sv,
                        (newStatus) {
                      setState(() {
                        sv.trangThai = newStatus;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ===== BOTTOM NAV =====
      bottomNavigationBar: const GiangVienBottomNav(
        currentIndex: 2, // tab Điểm danh
      ),
    );
  }

  // WIDGET: THẺ SINH VIÊN
  Widget _buildStudentCard(SinhVien sv, Function(String) onStatusChanged) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (sv.trangThai) {
      case "present":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = "Đúng giờ";
        break;
      case "absent":
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = "Vắng";
        break;
      case "late":
        statusColor = Colors.orange;
        statusIcon = Icons.error;
        statusText = "Đi muộn";
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        statusText = "Không rõ";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(
              sv.avatarOrDefault,
            ),
          ),
          const SizedBox(width: 12),

          // Thông tin sinh viên
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sv.ten,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(sv.lop,
                    style:
                    const TextStyle(color: Colors.black54, fontSize: 13)),
                Text("Mã SV: ${sv.ma}",
                    style:
                    const TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ),

          // Trạng thái + dropdown
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 20),
              const SizedBox(width: 4),
              Text(
                statusText,
                style: TextStyle(
                    color: statusColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 6),
              PopupMenuButton<String>(
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                onSelected: (value) {
                  onStatusChanged(value);
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: "present", child: Text("Đúng giờ")),
                  PopupMenuItem(value: "absent", child: Text("Vắng")),
                  PopupMenuItem(value: "late", child: Text("Đi muộn")),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
