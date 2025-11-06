import 'package:flutter/material.dart';
import 'diemdanh_qr_screen.dart';
import 'kq_diemdanh_screen.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../widgets/gv_side_menu.dart';
import '../../data/models/buoihoc_model.dart';

// ===== ENUM TRẠNG THÁI BUỔI HỌC =====
enum TrangThaiBuoiHoc { chuaDenGio, dangDienRa, ketThuc }

// ===== EXTENSION CHO BuoiHoc =====
extension BuoiHocStatus on BuoiHoc {
  TrangThaiBuoiHoc get trangThai {
    final now = DateTime.now();
    if (ngay == null || thoiGian == null) return TrangThaiBuoiHoc.chuaDenGio;

    final parts = thoiGian!.split(' - ');
    if (parts.length != 2) return TrangThaiBuoiHoc.chuaDenGio;

    final startParts = parts[0].split(':');
    final endParts = parts[1].split(':');

    final startTime = DateTime(
      ngay!.year,
      ngay!.month,
      ngay!.day,
      int.parse(startParts[0]),
      int.parse(startParts[1]),
    );
    final endTime = DateTime(
      ngay!.year,
      ngay!.month,
      ngay!.day,
      int.parse(endParts[0]),
      int.parse(endParts[1]),
    );

    if (now.isBefore(startTime)) return TrangThaiBuoiHoc.chuaDenGio;
    if (now.isAfter(endTime)) return TrangThaiBuoiHoc.ketThuc;
    return TrangThaiBuoiHoc.dangDienRa;
  }
}

// ===== Hàm helper hiển thị thứ =====
String getThu(DateTime? ngay) {
  if (ngay == null) return "-";
  switch (ngay.weekday) {
    case DateTime.monday:
      return "T2";
    case DateTime.tuesday:
      return "T3";
    case DateTime.wednesday:
      return "T4";
    case DateTime.thursday:
      return "T5";
    case DateTime.friday:
      return "T6";
    case DateTime.saturday:
      return "T7";
    case DateTime.sunday:
      return "CN";
    default:
      return "-";
  }
}

// ===== Helper định dạng ngày =====
String formatNgay(DateTime? ngay) {
  if (ngay == null) return "-";
  return "${ngay.day.toString().padLeft(2, '0')}/${ngay.month.toString().padLeft(2, '0')}/${ngay.year}";
}

class DiemDanhScreen extends StatefulWidget {
  const DiemDanhScreen({super.key});

  @override
  State<DiemDanhScreen> createState() => _DiemDanhScreenState();
}

class _DiemDanhScreenState extends State<DiemDanhScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const int _selectedIndex = 2; // Tab thứ 3 - Điểm danh

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    // Lọc chỉ các môn của hôm nay
    final List<BuoiHoc> monHocHomNay = BuoiHoc.buoiHocMau.where((b) =>
    b.ngay?.year == today.year &&
        b.ngay?.month == today.month &&
        b.ngay?.day == today.day).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: GVSideMenu(
        giangVienId: 'GV001',
        onClose: () => Navigator.pop(context),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF154B71),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            ),
            const Center(
              child: Text(
                "ĐIỂM DANH BUỔI HỌC",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Không có thông báo mới")),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              "Môn hôm nay",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: monHocHomNay.length,
                  itemBuilder: (context, index) {
                    final mon = monHocHomNay[index];
                    final ngayBuoiHoc = mon.ngay;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tên môn - Lớp
                          Text("${mon.tenMon} - ${mon.lop}",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          // Thời gian: Thứ, Ngày, Giờ
                          Text(
                            "Thời gian: ${getThu(ngayBuoiHoc)}, ${formatNgay(ngayBuoiHoc)} | ${mon.thoiGian ?? 'Chưa có'}",
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),
                          const SizedBox(height: 6),
                          // Phòng
                          Text(
                            "Phòng: ${mon.phong}",
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: _buildActionButton(context, mon),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const GiangVienBottomNav(
        currentIndex: _selectedIndex,
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, BuoiHoc mon) {
    final trangThaiBuoiHoc = mon.trangThai;

    switch (trangThaiBuoiHoc) {
      case TrangThaiBuoiHoc.chuaDenGio:
        return const SizedBox();
      case TrangThaiBuoiHoc.dangDienRa:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF154B71),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: () async {
            // Chuyển sang màn hình DiemDanhQRScreen
            final ketThuc = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DiemDanhQRScreen(buoiHoc: mon),
              ),
            );
            // Nếu đã điểm danh xong, refresh danh sách
            if (ketThuc == true) setState(() {});
          },
          child: const Text("Điểm danh",
              style: TextStyle(fontSize: 13, color: Colors.white)),
        );
      case TrangThaiBuoiHoc.ketThuc:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7B7B7B),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KetQuaDiemDanhScreen(buoiHoc: mon),
              ),
            );
          },
          child: const Text("Xem kết quả điểm danh",
              style: TextStyle(fontSize: 13, color: Colors.white)),
        );
    }
  }
}
