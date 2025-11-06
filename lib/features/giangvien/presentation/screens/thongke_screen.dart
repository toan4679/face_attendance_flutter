import 'package:flutter/material.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../widgets/gv_side_menu.dart';
import '../../data/models/thongke_model.dart';
import '../../data/models/buoihoc_model.dart';
import 'giangvien_dashboard_screen.dart';
import 'diemdanh_qr_screen.dart';
import 'lichday_screen.dart';
import 'quanlylop_screen.dart';
import '../../data/models/giangvien_model.dart';
class ThongKeScreen extends StatefulWidget {
  final GiangVien? giangVien;
  const ThongKeScreen({super.key, this.giangVien});

  @override
  State<ThongKeScreen> createState() => _ThongKeScreenState();
}

class _ThongKeScreenState extends State<ThongKeScreen> {
  int _selectedIndex = 4;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String selectedKhoa = "Tất cả"; // Dropdown mặc định

  // --- Hàm parse giờ bắt đầu/kết thúc ---
  List<DateTime> _parseTimeRange(String thoiGian, DateTime ngay) {
    try {
      final parts = thoiGian.split('-');
      if (parts.length != 2) return [];
      final startParts = parts[0].split(':').map(int.parse).toList();
      final endParts = parts[1].split(':').map(int.parse).toList();
      final start = DateTime(
          ngay.year, ngay.month, ngay.day, startParts[0], startParts[1]);
      final end = DateTime(
          ngay.year, ngay.month, ngay.day, endParts[0], endParts[1]);
      return [start, end];
    } catch (_) {
      return [];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GiangVienDashboardScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => LichDayScreen(giangVien: widget.giangVien)),
        );
        break;
      case 2:
      // Lấy buổi học hiện tại
        final now = DateTime.now();
        final buoiHienTai = BuoiHoc.buoiHocMau.firstWhere(
              (b) {
            if (b.thoiGian == null || b.ngay == null) return false;
            final times = _parseTimeRange(b.thoiGian!, b.ngay!);
            if (times.length < 2) return false;
            return now.isAfter(times[0]) && now.isBefore(times[1]);
          },
          orElse: () => BuoiHoc(
            tenMon: "Không có lớp diễn ra",
            lop: "N/A",
            phong: "N/A",
            thoiGian: "N/A",
            ngay: DateTime.now(),
          ),
        );

        if (buoiHienTai.tenMon == "Không có lớp diễn ra") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Hiện không có lớp nào đang diễn ra.")),
          );
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DiemDanhQRScreen(buoiHoc: buoiHienTai),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => QuanLyLopScreen(giangVien: widget.giangVien)),
        );
        break;
      case 4:
        break; // ở lại màn hình thống kê
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lọc dữ liệu theo dropdown
    final filteredBarData = (selectedKhoa == "Tất cả"
        ? barChartData
        : barChartData
        .where((item) => item.label.contains(selectedKhoa))
        .toList())
      ..sort((a, b) => b.value.compareTo(a.value)); // giảm dần

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF0F0F0),
      drawer: GVSideMenu(
        giangVienId: widget.giangVien?.maGV.toString() ?? '',
        onClose: () => Navigator.pop(context),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF154B71),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          "Thống kê",
          style:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Không có thông báo mới")),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Phần scrollable: dropdown + biểu đồ
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Thống kê tổng quan =====
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: statData
                        .map((e) =>
                        StatCard(title: e.title, value: e.value, icon: e.icon))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // ===== Dropdown chọn môn/kỳ =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Chọn môn/kỳ:",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      DropdownButton<String>(
                        value: selectedKhoa,
                        items: ["Tất cả", "Lập trình", "CSDL", "Web", "Dự án", "Mạng", "AI"]
                            .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedKhoa = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ===== Biểu đồ cột ngang =====
                  Column(
                    children: filteredBarData
                        .map((item) => _InteractiveBar(item: item))
                        .toList(),
                  ),
                  const SizedBox(height: 80), // tạo khoảng trống cho nút ở dưới
                ],
              ),
            ),
          ),

          // ===== Nút xuất báo cáo tổng quan =====
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            "Chức năng xuất báo cáo tổng quan đang được phát triển...")),
                  );
                },
                icon: const Icon(Icons.file_download),
                label: const Text("Xuất báo cáo tổng quan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6FBF73), // xanh lá phù hợp
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: GiangVienBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ===== WIDGET: Ô Thống kê =====
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard(
      {super.key, required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 48) / 2,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF154B71), size: 28),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.black54, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ===== WIDGET: Thanh bar tương tác =====
class _InteractiveBar extends StatefulWidget {
  final BarChartItem item;
  const _InteractiveBar({super.key, required this.item});

  @override
  State<_InteractiveBar> createState() => _InteractiveBarState();
}

class _InteractiveBarState extends State<_InteractiveBar> {
  bool showValue = false;
  double tapPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(widget.item.label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 30,
          child: Text("${widget.item.value.floor()}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              final valuePosition = widget.item.value / 10 * barWidth;

              return GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    tapPosition = details.localPosition.dx;
                    showValue = true;
                  });
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) setState(() => showValue = false);
                  });
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      width: valuePosition,
                      height: 18,
                      decoration: BoxDecoration(
                        color: widget.item.color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Positioned(
                      left: barWidth - 2,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 2,
                        color: Colors.redAccent,
                      ),
                    ),
                    if (showValue)
                      Positioned(
                        left: tapPosition,
                        top: -28,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "${widget.item.value.toStringAsFixed(1)}",
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
