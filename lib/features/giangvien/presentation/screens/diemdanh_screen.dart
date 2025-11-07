import 'package:flutter/material.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../widgets/gv_side_menu.dart';
import '../../data/models/buoihoc_model.dart';
import '../controllers/giangvien_controller.dart';
import 'diemdanh_qr_screen.dart';
import 'kq_diemdanh_screen.dart';

enum TrangThaiBuoiHoc { chuaDenGio, dangDienRa, ketThuc }

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLichDayHomNay();
    });
  }

  Future<void> _loadLichDayHomNay() async {
    try {
      await _controller.fetchLichDayHomNayCurrent();
      if (mounted) {
        setState(() {
          _lichDay = _controller.lichDayHomNay;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: GVSideMenu(
        giangVienId:
        _controller.currentGiangVien?.maGV.toString() ?? 'Chưa có ID',
        onClose: () => Navigator.pop(context),
      ),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF154B71), Color(0xFF0D2A47)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          "ĐIỂM DANH BUỔI HỌC",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF154B71),
        ),
      )
          : _error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              "Lỗi tải dữ liệu",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? "",
              textAlign: TextAlign.center,
              style:
              const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      )
          : _lichDay.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today,
                color: Colors.grey[400], size: 64),
            const SizedBox(height: 16),
            Text(
              "Hôm nay bạn không có buổi học nào",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _lichDay.length,
        itemBuilder: (context, index) {
          final buoi = _lichDay[index];
          return _buildSessionCard(context, buoi, index);
        },
      ),
      bottomNavigationBar:
      const GiangVienBottomNav(currentIndex: _selectedIndex),
    );
  }

  Widget _buildSessionCard(
      BuildContext context, BuoiHoc buoi, int index) {
    final trangThai = buoi.trangThai;
    final statusColor = _getStatusColor(trangThai);
    final statusLabel = _getStatusLabel(trangThai);
    final statusIcon = _getStatusIcon(trangThai);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          left: BorderSide(color: statusColor, width: 5),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [statusColor.withOpacity(0.1), statusColor.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        buoi.tenMon,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF154B71),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        buoi.maSoLopHP,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  Icons.calendar_today_outlined,
                  "${getThu(buoi.ngayHoc)}, ${formatNgay(buoi.ngayHoc)}",
                  Colors.blue[700]!,
                ),
                const SizedBox(height: 10),
                _buildDetailRow(
                  Icons.access_time,
                  buoi.thoiGian,
                  Colors.orange[700]!,
                ),
                const SizedBox(height: 10),
                _buildDetailRow(
                  Icons.meeting_room,
                  "Phòng ${buoi.phongHoc}",
                  Colors.green[700]!,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: _buildActionButton(context, buoi),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(TrangThaiBuoiHoc trangThai) {
    switch (trangThai) {
      case TrangThaiBuoiHoc.chuaDenGio:
        return Colors.grey;
      case TrangThaiBuoiHoc.dangDienRa:
        return Colors.green;
      case TrangThaiBuoiHoc.ketThuc:
        return Colors.blue[900]!;
    }
  }

  String _getStatusLabel(TrangThaiBuoiHoc trangThai) {
    switch (trangThai) {
      case TrangThaiBuoiHoc.chuaDenGio:
        return "Chưa đến giờ";
      case TrangThaiBuoiHoc.dangDienRa:
        return "Đang diễn ra";
      case TrangThaiBuoiHoc.ketThuc:
        return "Kết thúc";
    }
  }

  IconData _getStatusIcon(TrangThaiBuoiHoc trangThai) {
    switch (trangThai) {
      case TrangThaiBuoiHoc.chuaDenGio:
        return Icons.schedule;
      case TrangThaiBuoiHoc.dangDienRa:
        return Icons.play_circle_filled;
      case TrangThaiBuoiHoc.ketThuc:
        return Icons.check_circle;
    }
  }

  Widget _buildActionButton(BuildContext context, BuoiHoc buoi) {
    final trangThai = buoi.trangThai;

    switch (trangThai) {
      case TrangThaiBuoiHoc.chuaDenGio:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.grey[700],
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.lock, size: 18),
            label: const Text(
              "Chưa đến giờ điểm danh",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            onPressed: null,
          ),
        );

      case TrangThaiBuoiHoc.dangDienRa:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.qr_code_2, size: 18),
            label: const Text(
              "Bắt đầu điểm danh",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            onPressed: () async {
              final ketThuc = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiemDanhQRScreen(buoiHoc: buoi),
                ),
              );
              if (ketThuc == true) _loadLichDayHomNay();
            },
          ),
        );

      case TrangThaiBuoiHoc.ketThuc:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF154B71),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.description, size: 18),
            label: const Text(
              "Xem kết quả điểm danh",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KetQuaDiemDanhScreen(buoiHoc: buoi),
                ),
              );
            },
          ),
        );
    }
  }
}
