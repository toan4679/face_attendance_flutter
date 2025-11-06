import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/buoihoc_model.dart';
import '../../data/models/giangvien_model.dart';
import '../controllers/giangvien_controller.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../widgets/gv_side_menu.dart';
import 'diemdanh_qr_screen.dart';
import 'lichday_screen.dart';
import 'quanlylop_screen.dart';
import 'thongke_screen.dart';

class GiangVienDashboardScreen extends StatefulWidget {
  final GiangVien? giangVien;
  const GiangVienDashboardScreen({super.key, this.giangVien});

  @override
  State<GiangVienDashboardScreen> createState() =>
      _GiangVienDashboardScreenState();
}

class _GiangVienDashboardScreenState extends State<GiangVienDashboardScreen> {
  final int _selectedIndex = 0;
  late final GiangVien? gvHienTai;
  late final List<BuoiHoc> lichDayHomNay;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    gvHienTai = widget.giangVien ?? GiangVienController().giangVien; // ✅
    lichDayHomNay = BuoiHoc.buoiHocMau;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  PreferredSizeWidget _buildHomeAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF154B71),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Center(
        child: Text(
          "TRANG CHỦ",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF154B71),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline, color: Colors.white, size: 28),
          const SizedBox(width: 10),
          Text(
            gvHienTai?.hoTen ?? "Giảng viên",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gv = gvHienTai; // alias để đọc ngắn hơn
    final BuoiHoc buoiHienTaiDrawer = BuoiHoc.buoiHocMau.firstOrNull ??
        BuoiHoc(tenMon: "N/A", lop: "N/A", phong: "N/A");

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: _buildHomeAppBar(),
      drawer: GVSideMenu(
        giangVienId: gv?.maGV.toString() ?? '',
        buoiHoc: buoiHienTaiDrawer,
        onClose: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTeacherInfo(),
            const SizedBox(height: 16),
            // ... các widget khác (lịch dạy, thống kê, v.v.)
          ],
        ),
      ),
      bottomNavigationBar: GiangVienBottomNav(currentIndex: _selectedIndex),
    );
  }
}
