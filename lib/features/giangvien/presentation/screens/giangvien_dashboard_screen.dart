// lib/features/giangvien/presentation/screens/giangvien_dashboard_screen.dart
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
  const GiangVienDashboardScreen({super.key});

  @override
  State<GiangVienDashboardScreen> createState() =>
      _GiangVienDashboardScreenState();
}

class _GiangVienDashboardScreenState extends State<GiangVienDashboardScreen> {
  final int _selectedIndex = 0;
  GiangVien? gvHienTai;
  List<BuoiHoc> lichDayHomNay = [];
  Timer? _timer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();

    // Timer cập nhật trạng thái realtime
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _loadData() async {
    try {
      await GiangVienController().loadCurrentGiangVien();
      gvHienTai = GiangVienController().giangVien;

      if (gvHienTai != null) {
        final lichList = await GiangVienController().getLichDayHomNay();
        setState(() {
          lichDayHomNay = lichList;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("❌ Lỗi load data: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- Hàm parse giờ ---
  List<DateTime> _parseTimeRange(String thoiGian, DateTime ngay) {
    try {
      final startParts = thoiGian.split('-')[0].split(':').map(int.parse).toList();
      final endParts = thoiGian.split('-')[1].split(':').map(int.parse).toList();
      final start = DateTime(ngay.year, ngay.month, ngay.day, startParts[0], startParts[1]);
      final end = DateTime(ngay.year, ngay.month, ngay.day, endParts[0], endParts[1]);
      return [start, end];
    } catch (_) {
      return [];
    }
  }

  // --- Xác định màu trạng thái buổi học ---
  Color _getStatusColor(BuoiHoc buoi) {
    final times = _parseTimeRange("${buoi.gioBatDau} - ${buoi.gioKetThuc}", buoi.ngayHoc);
    if (times.isEmpty) return Colors.grey;
    final now = DateTime.now();
    final start = times[0];
    final end = times[1];
    if (now.isBefore(start)) return Colors.yellow; // sắp diễn ra
    if (now.isAfter(end)) return Colors.red; // đã kết thúc
    return Colors.green; // đang diễn ra
  }

  // --- APPBAR ---
  PreferredSizeWidget _buildHomeAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF154B71),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Builder(
              builder: (context) => GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Image.asset(
                  'assets/images/login_illustration.png',
                  height: 36,
                ),
              ),
            ),
          ),
          const Center(
            child: Text(
              "TRANG CHỦ",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
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
    );
  }

  // --- Thông tin giảng viên ---
  Widget _buildTeacherInfo() {
    if (gvHienTai == null) return const SizedBox.shrink();

    String initials = gvHienTai!.hoTen.isNotEmpty
        ? gvHienTai!.hoTen.trim().split(" ").map((e) => e[0]).take(2).join()
        : "GV";

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF154B71),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Text(
              initials,
              style: const TextStyle(
                color: Color(0xFF154B71),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              gvHienTai!.hoTen,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Lịch dạy hôm nay ---
  Widget _buildTodaySchedule() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final today = DateTime.now();
    final lichHomNay = lichDayHomNay.where((b) =>
    b.ngayHoc.year == today.year &&
        b.ngayHoc.month == today.month &&
        b.ngayHoc.day == today.day
    ).toList();

    const double itemHeight = 77.0;
    const double maxVisibleItems = 3;

    final formattedDate =
        "${today.day.toString().padLeft(2, '0')}/"
        "${today.month.toString().padLeft(2, '0')}/"
        "${today.year}";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF154B71),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Lịch dạy hôm nay",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(10),
            height: itemHeight * maxVisibleItems,
            child: lichHomNay.isEmpty
                ? const Center(child: Text("Hôm nay không có lịch dạy"))
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: lichHomNay.map((buoi) {
                  final statusColor = _getStatusColor(buoi);
                  String statusText;
                  if (statusColor == Colors.green) {
                    statusText = "Đang diễn ra";
                  } else if (statusColor == Colors.red) {
                    statusText = "Đã kết thúc";
                  } else if (statusColor == Colors.yellow) {
                    statusText = "Sắp diễn ra";
                  } else {
                    statusText = "Chưa xác định";
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${buoi.tenMon} - ${buoi.maSoLopHP}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  margin:
                                  const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text(
                                  statusText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text("${buoi.gioBatDau} - ${buoi.gioKetThuc}",
                            style: const TextStyle(fontSize: 13)),
                        const SizedBox(height: 4),
                        Text("Phòng ${buoi.phongHoc}",
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Grid chức năng ---
  Widget _buildFeatureGrid(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {
        "icon": Icons.qr_code_2,
        "title": "Điểm danh",
        "buttonText": "Bắt đầu điểm danh",
      },
      {
        "icon": Icons.calendar_today_outlined,
        "title": "Lịch dạy",
        "buttonText": "Xem lịch dạy",
        "screen": LichDayScreen(giangVien: gvHienTai),
      },
      {
        "icon": Icons.people_outline,
        "title": "Quản lý lớp",
        "buttonText": "Chi tiết lớp học",
      },
      {
        "icon": Icons.bar_chart_outlined,
        "title": "Thống kê",
        "buttonText": "Xem thống kê",
        // "screen": ThongKeScreen(giangVienId: gvHienTai?.maGV ?? 0),
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: features.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (context, index) {
        final item = features[index];
        return _featureCard(
          context,
          item["icon"],
          item["title"],
          item["buttonText"],
        );
      },
    );
  }

  Widget _featureCard(
      BuildContext context, IconData icon, String title, String buttonText) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: const Color(0xFF154B71), size: 40),
          Text(title,
              textAlign: TextAlign.center,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: xử lý navigation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF154B71),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(buttonText,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final BuoiHoc buoiHienTaiDrawer = lichDayHomNay.isNotEmpty
        ? lichDayHomNay.first
        : BuoiHoc(
      maBuoi: 0,
      tenMon: "Không có lớp diễn ra",
      maSoLopHP: "N/A",
      ngayHoc: DateTime.now(),
      gioBatDau: "N/A",
      gioKetThuc: "N/A",
      phongHoc: "N/A",
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: _buildHomeAppBar(),
      drawer: GVSideMenu(
        giangVienId: gvHienTai?.maGV.toString() ?? '',
        buoiHoc: buoiHienTaiDrawer,
        onClose: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTeacherInfo(),
            const SizedBox(height: 12),
            _buildTodaySchedule(),
            const SizedBox(height: 12),
            _buildFeatureGrid(context),
          ],
        ),
      ),
      bottomNavigationBar: GiangVienBottomNav(currentIndex: _selectedIndex),
    );
  }
}
