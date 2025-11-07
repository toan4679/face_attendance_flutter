import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/buoihoc_model.dart';
import '../../data/models/giangvien_model.dart';
import '../controllers/giangvien_controller.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../widgets/gv_side_menu.dart';
import 'diemdanh_screen.dart';
import 'lichday_screen.dart';
import 'quanlylop_screen.dart';
import 'thongke_screen.dart';
import '../../gv_routes.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  Future<void> _loadData() async {
    try {
      final controller = GiangVienController();
      await controller.loadCurrentGiangVien();
      gvHienTai = controller.giangVien;

      if (gvHienTai != null) {
        await controller.fetchLichDayHomNayCurrent();

        if (mounted) {
          setState(() {
            lichDayHomNay = controller.lichDayHomNay;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint("❌ Lỗi load data: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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

  Color _getStatusColor(BuoiHoc buoi) {
    final times = _parseTimeRange("${buoi.gioBatDau} - ${buoi.gioKetThuc}", buoi.ngayHoc);
    if (times.isEmpty) return Colors.grey;
    final now = DateTime.now();
    final start = times[0];
    final end = times[1];
    if (now.isBefore(start)) return Colors.orange;
    if (now.isAfter(end)) return Colors.red;
    return Colors.green;
  }

  PreferredSizeWidget _buildHomeAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF1e3a5f), const Color(0xFF2d5a8c)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      automaticallyImplyLeading: false,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Builder(
              builder: (context) => GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.menu, color: Colors.white),
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
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Không có thông báo mới"),
                    backgroundColor: Color(0xFF1e3a5f),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherInfo() {
    if (gvHienTai == null) return const SizedBox.shrink();

    String initials = gvHienTai!.hoTen.isNotEmpty
        ? gvHienTai!.hoTen.trim().split(" ").map((e) => e[0]).take(2).join()
        : "GV";

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF1e3a5f), const Color(0xFF2d5a8c)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1e3a5f).withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Color(0xFF1e3a5f),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Xin chào,",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                Text(
                  gvHienTai!.hoTen,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySchedule() {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF1e3a5f),
          ),
        ),
      );
    }

    final today = DateTime.now();
    final lichHomNay = lichDayHomNay.where((b) =>
    b.ngayHoc.year == today.year &&
        b.ngayHoc.month == today.month &&
        b.ngayHoc.day == today.day
    ).toList();

    final formattedDate =
        "Thứ ${['hai', 'ba', 'tư', 'năm', 'sáu', 'bảy', 'chủ nhật'][today.weekday - 1]}, "
        "${today.day.toString().padLeft(2, '0')}/"
        "${today.month.toString().padLeft(2, '0')}/"
        "${today.year}";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1e3a5f).withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFF1e3a5f),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Lịch dạy hôm nay",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          lichHomNay.isEmpty
              ? Center(
            child: Column(
              children: [
                Icon(
                  Icons.event_busy_outlined,
                  size: 40,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 8),
                Text(
                  "Hôm nay không có lịch dạy",
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          )
              : Column(
            children: List.generate(
              lichHomNay.length,
                  (index) {
                final buoi = lichHomNay[index];
                final statusColor = _getStatusColor(buoi);
                String statusText;
                if (statusColor == Colors.green) {
                  statusText = "Đang diễn ra";
                } else if (statusColor == Colors.red) {
                  statusText = "Đã kết thúc";
                } else {
                  statusText = "Sắp diễn ra";
                }

                return Container(
                  margin: EdgeInsets.only(
                    bottom: index < lichHomNay.length - 1 ? 12 : 0,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: statusColor,
                        width: 4,
                      ),
                    ),
                    color: statusColor.withAlpha(13),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${buoi.tenMon} - ${buoi.maSoLopHP}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withAlpha(51),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  statusText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${buoi.gioBatDau} - ${buoi.gioKetThuc}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.room_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Phòng ${buoi.phongHoc}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {
        "icon": Icons.qr_code_2,
        "title": "Điểm danh",
        "description": "Quét QR code",
        "color": const Color(0xFFFF6B6B),
        "route": GvRoutes.diemdanh,
      },
      {
        "icon": Icons.calendar_today_outlined,
        "title": "Lịch dạy",
        "description": "Xem lịch học",
        "color": const Color(0xFF4ECDC4),
        "route": GvRoutes.lichday,
      },
      {
        "icon": Icons.people_outline,
        "title": "Quản lý lớp",
        "description": "Chi tiết lớp",
        "color": const Color(0xFFFFD93D),
        "route": GvRoutes.quanlylop,
      },
      {
        "icon": Icons.bar_chart_outlined,
        "title": "Thống kê",
        "description": "Xem báo cáo",
        "color": const Color(0xFF6BCB77),
        "route": GvRoutes.thongke,
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
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final item = features[index];
        return _buildFeatureCard(
          context,
          item["icon"],
          item["title"],
          item["description"],
          item["color"],
          item["route"],
        );
      },
    );
  }

  Widget _buildFeatureCard(
      BuildContext context,
      IconData icon,
      String title,
      String description,
      Color color,
      String route,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            GvRoutes.navigate(context, route, arguments: {
              "giangVienId": gvHienTai?.maGV.toString() ?? '',
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withAlpha(26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
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
      backgroundColor: const Color(0xFFF8F9FA),
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
            const SizedBox(height: 20),
            _buildTodaySchedule(),
            const SizedBox(height: 20),
            Text(
              "Chức năng chính",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            _buildFeatureGrid(context),
          ],
        ),
      ),
      bottomNavigationBar: GiangVienBottomNav(currentIndex: _selectedIndex),
    );
  }
}