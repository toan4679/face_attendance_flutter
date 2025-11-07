import 'package:flutter/material.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../widgets/gv_side_menu.dart';
import '../../data/models/buoihoc_model.dart';
import '../controllers/giangvien_controller.dart';
import 'diemdanh_qr_screen.dart';
import 'kq_diemdanh_screen.dart';

// ===== ENUM TRẠNG THÁI BUỔI HỌC =====
enum TrangThaiBuoiHoc { chuaDenGio, dangDienRa, ketThuc }

// ===== EXTENSION CHO BuoiHoc =====
extension BuoiHocStatus on BuoiHoc {
  TrangThaiBuoiHoc get trangThai {
    final now = DateTime.now();
    final parts = thoiGian.split('-');
    if (parts.length != 2) return TrangThaiBuoiHoc.chuaDenGio;

    final startParts = parts[0].trim().split(':');
    final endParts = parts[1].trim().split(':');

    final startTime = DateTime(
      ngayHoc.year,
      ngayHoc.month,
      ngayHoc.day,
      int.parse(startParts[0]),
      int.parse(startParts[1]),
    );
    final endTime = DateTime(
      ngayHoc.year,
      ngayHoc.month,
      ngayHoc.day,
      int.parse(endParts[0]),
      int.parse(endParts[1]),
    );

    if (now.isBefore(startTime)) return TrangThaiBuoiHoc.chuaDenGio;
    if (now.isAfter(endTime)) return TrangThaiBuoiHoc.ketThuc;
    return TrangThaiBuoiHoc.dangDienRa;
  }
}

// ===== Helper =====
String getThu(DateTime ngay) {
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

String formatNgay(DateTime ngay) =>
    "${ngay.day.toString().padLeft(2, '0')}/${ngay.month.toString().padLeft(2, '0')}/${ngay.year}";

class DiemDanhScreen extends StatefulWidget {
  const DiemDanhScreen({super.key});

  @override
  State<DiemDanhScreen> createState() => _DiemDanhScreenState();
}

class _DiemDanhScreenState extends State<DiemDanhScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const int _selectedIndex = 2;
  final GiangVienController _controller = GiangVienController();

  bool _isLoading = true;
  String? _error;
  List<BuoiHoc> _lichDay = [];

  @override
  void initState() {
    super.initState();
    _loadLichDayHomNay();
  }

  Future<void> _loadLichDayHomNay() async {
    try {
      await _controller.fetchLichDayHomNayCurrent();
      setState(() {
        _lichDay = _controller.lichDayHomNay;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: GVSideMenu(
        giangVienId:
        _controller.currentGiangVien?.maGV.toString() ?? 'Chưa có ID',
        onClose: () => Navigator.pop(context),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF154B71),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "ĐIỂM DANH BUỔI HỌC",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
        child: Text(
          "❌ Lỗi load dữ liệu: $_error",
          style: const TextStyle(color: Colors.red),
        ),
      )
          : _lichDay.isEmpty
          ? const Center(
        child: Text(
          "Hôm nay bạn không có buổi học nào.",
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _lichDay.length,
        itemBuilder: (context, index) {
          final mon = _lichDay[index];
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
                Text("${mon.tenMon} - ${mon.maSoLopHP}",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(
                  "Thời gian: ${getThu(mon.ngayHoc)}, ${formatNgay(mon.ngayHoc)} | ${mon.thoiGian}",
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 6),
                Text("Phòng: ${mon.phongHoc}",
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black54)),
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
      bottomNavigationBar:
      const GiangVienBottomNav(currentIndex: _selectedIndex),
    );
  }

  Widget _buildActionButton(BuildContext context, BuoiHoc mon) {
    final trangThai = mon.trangThai;

    switch (trangThai) {
      case TrangThaiBuoiHoc.chuaDenGio:
        return const SizedBox();
      case TrangThaiBuoiHoc.dangDienRa:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF154B71),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: () async {
            final ketThuc = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DiemDanhQRScreen(buoiHoc: mon),
              ),
            );
            if (ketThuc == true) _loadLichDayHomNay();
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
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
