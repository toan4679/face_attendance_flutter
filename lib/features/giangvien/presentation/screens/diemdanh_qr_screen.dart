import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../../data/models/buoihoc_model.dart';
import '../../data/models/sinhvien_model.dart';
import '../../presentation/controllers/giangvien_controller.dart';

class DiemDanhQRScreen extends StatefulWidget {
  final BuoiHoc buoiHoc;
  const DiemDanhQRScreen({super.key, required this.buoiHoc});

  @override
  State<DiemDanhQRScreen> createState() => _DiemDanhQRScreenState();
}

class _DiemDanhQRScreenState extends State<DiemDanhQRScreen> {
  final GiangVienController _controller = GiangVienController();

  bool diemDanhDangMo = false;
  bool hienThiDanhSach = false;
  Timer? _timer;
  List<SinhVien> danhSachSinhVien = [];

  @override
  void initState() {
    super.initState();
    _loadDanhSachSinhVien();

    // Load danh sách sinh viên định kỳ nếu điểm danh đang mở
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (diemDanhDangMo) _loadDanhSachSinhVien();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Load danh sách sinh viên theo buổi học
  Future<void> _loadDanhSachSinhVien() async {
    try {
      final dsMap = await _controller.getDanhSachSinhVien(widget.buoiHoc.maBuoi);
      final ds = dsMap.map((e) => SinhVien.fromJson(e)).toList();
      setState(() {
        danhSachSinhVien = ds;
        hienThiDanhSach = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Lỗi tải danh sách: $e')),
      );
    }
  }

  // Bắt đầu điểm danh, tạo QR mới từ server
  Future<void> _batDauDiemDanh() async {
    try {
      await _controller.startDiemDanh(widget.buoiHoc.maBuoi);
      setState(() {
        diemDanhDangMo = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Đã mở điểm danh, sinh viên có thể quét mã QR")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Lỗi mở điểm danh: $e')),
      );
    }
  }

  // Kết thúc điểm danh, xóa QR
  Future<void> _ketThucDiemDanh() async {
    try {
      await _controller.endDiemDanh(widget.buoiHoc.maBuoi);
      _timer?.cancel(); // hủy timer khi kết thúc
      setState(() {
        diemDanhDangMo = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("📘 Đã kết thúc điểm danh")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Lỗi kết thúc điểm danh: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final buoiHoc = widget.buoiHoc;
    final qrData = _controller.qrCode;
    final tongSV = danhSachSinhVien.length;
    final diDungGio = danhSachSinhVien.where((sv) => sv.trangThai == "Đúng giờ").length;
    final diMuon = danhSachSinhVien.where((sv) => sv.trangThai == "Đi muộn").length;
    final vang = tongSV - diDungGio - diMuon;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF154B71),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, diemDanhDangMo),
        ),
        title: Text(
          "Điểm danh: ${buoiHoc.tenMon}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thông tin buổi học
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF154B71),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Mã buổi học: ${buoiHoc.maBuoi}", style: const TextStyle(color: Colors.white, fontSize: 15)),
                const SizedBox(height: 4),
                Text("Môn: ${buoiHoc.tenMon} | Phòng: ${buoiHoc.phongHoc}", style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                Text("Thời gian: ${buoiHoc.thoiGian}", style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // QR Code
          if (diemDanhDangMo && qrData != null)
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF154B71), width: 3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 200,
                      backgroundColor: Colors.white,
                      gapless: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Sinh viên quét mã QR để điểm danh",
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          // Danh sách sinh viên
          if (hienThiDanhSach)
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40)),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: danhSachSinhVien.length,
                  itemBuilder: (context, index) {
                    final sv = danhSachSinhVien[index];
                    Color statusColor;
                    if (sv.trangThai == "Đúng giờ") {
                      statusColor = Colors.green;
                    } else if (sv.trangThai == "Đi muộn") {
                      statusColor = Colors.orange;
                    } else {
                      statusColor = Colors.red;
                    }
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(sv.avatarOrDefault),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(sv.ten, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                  Text(sv.ma, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            sv.trangThai,
                            style: TextStyle(fontSize: 13, color: statusColor, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          // Nút hành động
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (!diemDanhDangMo)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF154B71),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _batDauDiemDanh,
                    child: const Text("BẮT ĐẦU ĐIỂM DANH", style: TextStyle(color: Colors.white)),
                  ),
                if (diemDanhDangMo)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFEBEB),
                      foregroundColor: const Color(0xFFB71C1C),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _ketThucDiemDanh,
                    child: const Text(
                      "KẾT THÚC ĐIỂM DANH",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const GiangVienBottomNav(currentIndex: 2),
    );
  }
}
