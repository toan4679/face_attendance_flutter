import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../../data/models/chitiet_sv_diemdanh_model.dart';

class BuoiDaDiemDanhScreen extends StatefulWidget {
  final String tenSinhVien;
  final String maSinhVien;
  final String avatarPath;
  final List<DiemDanhBuoiHocChiTiet> diemDanh;

  const BuoiDaDiemDanhScreen({
    super.key,
    required this.tenSinhVien,
    required this.maSinhVien,
    required this.avatarPath,
    required this.diemDanh,
  });

  @override
  State<BuoiDaDiemDanhScreen> createState() => _BuoiDaDiemDanhScreenState();
}

class _BuoiDaDiemDanhScreenState extends State<BuoiDaDiemDanhScreen> {
  int _selectedIndex = 3;
  int _notificationCount = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Chức năng thông báo đang được phát triển...")),
    );
  }

  // Chuẩn hóa trạng thái
  String normalizedStatus(String status) {
    switch (status.toLowerCase()) {
      case 'present':
      case 'đúng giờ':
        return 'Đúng giờ';
      case 'late':
      case 'muộn':
      case 'đi muộn':
        return 'Đi muộn';
      case 'absent':
      case 'vắng':
        return 'Vắng';
      default:
        return 'Đúng giờ'; // mặc định
    }
  }

  // Lấy màu theo trạng thái
  Color getStatusColor(String status) {
    switch (status) {
      case 'Đúng giờ':
        return Colors.green;
      case 'Đi muộn':
        return Colors.orange;
      case 'Vắng':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Lấy icon theo trạng thái
  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Đúng giờ':
        return Icons.check_circle;
      case 'Đi muộn':
        return Icons.error;
      case 'Vắng':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalBuoi = widget.diemDanh.length;
    int coMat = widget.diemDanh
        .where((b) {
      String s = normalizedStatus(b.trangThai);
      return s == 'Đúng giờ' || s == 'Đi muộn';
    })
        .length;
    int vang = widget.diemDanh
        .where((b) => normalizedStatus(b.trangThai) == 'Vắng')
        .length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF154B71),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "CHI TIẾT ĐIỂM DANH",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: _openNotifications,
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                    const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$_notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin sinh viên
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(widget.avatarPath),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tenSinhVien,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "MSV: ${widget.maSinhVien}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Ô tóm tắt số buổi có mặt và vắng
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
                          "$coMat / $totalBuoi",
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
                          "$vang / $totalBuoi",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Text(
              "Chi tiết điểm danh",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),

            // Danh sách buổi điểm danh
            widget.diemDanh.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text("Chưa có buổi điểm danh nào"),
              ),
            )
                : Column(
              children: widget.diemDanh.asMap().entries.map((entry) {
                int index = entry.key;
                var buoi = entry.value;

                String status = normalizedStatus(buoi.trangThai);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Thông tin buổi học
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${buoi.maLopHP} - ${buoi.thu}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            const SizedBox(height: 4),
                            Text(
                              "Ngày: ${DateFormat('dd/MM/yyyy').format(buoi.ngayHoc)}  -  Giờ: ${buoi.gioBatDau != null ? DateFormat('HH:mm').format(buoi.gioBatDau!) : '-'}  -  Phòng: ${buoi.phongHoc}",
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      // Dropdown thay đổi trạng thái
                      Row(
                        children: [
                          Icon(getStatusIcon(status),
                              color: getStatusColor(status)),
                          const SizedBox(width: 6),
                          DropdownButton<String>(
                            value: status,
                            items: const [
                              DropdownMenuItem(
                                  value: 'Đúng giờ',
                                  child: Text('Đúng giờ')),
                              DropdownMenuItem(
                                  value: 'Đi muộn',
                                  child: Text('Đi muộn')),
                              DropdownMenuItem(
                                  value: 'Vắng', child: Text('Vắng')),
                            ],
                            onChanged: (newValue) {
                              setState(() {
                                widget.diemDanh[index].trangThai =
                                newValue!;
                              });
                            },
                            underline: const SizedBox(),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GiangVienBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
