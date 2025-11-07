import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/giangvien_controller.dart';
import '../../data/models/buoihoc_model.dart';
import './giangvien_dashboard_screen.dart';
import './diemdanh_screen.dart';
import './quanlylop_screen.dart';
import './profile_screen.dart';

class LichDayScreen extends StatefulWidget {
  final dynamic giangVien;
  final int? maGV;
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

  void _handleNavigationTap(int index) {
    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = GiangVienDashboardScreen();
        break;
      case 1:
        nextScreen = LichDayScreen(giangVien: widget.giangVien, maGV: widget.maGV);
        break;
      case 2:
        nextScreen = const DiemDanhScreen();
        break;
      case 3:
        nextScreen = QuanLyLopScreen(giangVien: widget.giangVien);
        break;
      case 4:
        nextScreen = const ProfileScreen();
        break;
      default:
        nextScreen = GiangVienDashboardScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<GiangVienController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: 1,
              selectedItemColor: const Color(0xFF154B71),
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              onTap: _handleNavigationTap,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Trang chủ',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month_outlined),
                  label: 'Lịch dạy',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code_2, size: 32),
                  label: 'Điểm danh',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_outline),
                  label: 'QL Lớp',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Tôi',
                ),
              ],
            ),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 140,
                  pinned: true,
                  backgroundColor: const Color(0xFF154B71),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF154B71),
                            const Color(0xFF0D2E47),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Lịch Dạy',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Hôm nay - ${DateFormat('EEEE, dd/MM/yyyy', 'vi_VN').format(DateTime.now())}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildBody(controller),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(GiangVienController controller) {
    if (controller.loadingLichDay) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(height: 60),
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải lịch dạy...'),
            SizedBox(height: 60),
          ],
        ),
      );
    }

    if (controller.errorLichDay != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Lỗi: ${controller.errorLichDay}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
          ],
        ),
      );
    }

    if (controller.lichDayHomNay.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today,
                size: 64,
                color: Colors.blue.shade300,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Không có lịch dạy hôm nay',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hãy thư giãn và quay lại ngày khác',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      );
    }

    return Column(
      children: List.generate(
        controller.lichDayHomNay.length,
            (index) {
          final BuoiHoc buoi = controller.lichDayHomNay[index];
          final isLast = index == controller.lichDayHomNay.length - 1;

          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
            child: _buildScheduleCard(buoi, index),
          );
        },
      ),
    );
  }

  Widget _buildScheduleCard(BuoiHoc buoi, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF154B71),
                          const Color(0xFF0D2E47),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          buoi.tenMon,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lớp: ${buoi.maSoLopHP}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 1,
                color: Colors.grey.withOpacity(0.2),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoChip(
                      Icons.access_time,
                      '${buoi.gioBatDau} - ${buoi.gioKetThuc}',
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoChip(
                      Icons.meeting_room,
                      'Phòng ${buoi.phongHoc}',
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoChip(
                Icons.calendar_today,
                DateFormat('EEEE, dd/MM/yyyy', 'vi_VN').format(buoi.ngayHoc),
                Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color.withOpacity(0.8),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}