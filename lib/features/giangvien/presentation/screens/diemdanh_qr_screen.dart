import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../../data/models/buoihoc_model.dart';
import '../../data/models/sinhvien_model.dart';

class DiemDanhQRScreen extends StatefulWidget {
  final BuoiHoc buoiHoc;

  const DiemDanhQRScreen({super.key, required this.buoiHoc});

  @override
  State<DiemDanhQRScreen> createState() => _DiemDanhQRScreenState();
}

class _DiemDanhQRScreenState extends State<DiemDanhQRScreen> {
  bool diemDanhDangMo = false;
  bool hienThiDanhSach = false;
  bool showQR = true;

  @override
  void initState() {
    super.initState();
    diemDanhDangMo = false;
    hienThiDanhSach = false;
    showQR = true; // Mở màn hình lần đầu luôn hiển thị QR
  }

  @override
  Widget build(BuildContext context) {
    final monHoc = widget.buoiHoc;

    // Tính số lượng sinh viên theo trạng thái
    int tongSV = monHoc.danhSachSinhVien.length;
    int diDungGio = monHoc.danhSachSinhVien
        .where((sv) => sv.trangThai == "Đúng giờ")
        .length;
    int diMuon = monHoc.danhSachSinhVien
        .where((sv) => sv.trangThai == "Đi muộn")
        .length;
    int vang = tongSV - diDungGio - diMuon;

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
          "Điểm danh: ${monHoc.tenMon} - ${monHoc.lop}",
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thông tin lớp học
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF154B71),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Môn: ${monHoc.tenMon}",
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 4),
                Text("Lớp: ${monHoc.lop} | Phòng: ${monHoc.phong}",
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                Text("Thời gian: ${monHoc.thoiGian ?? 'Chưa có'}",
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // QR CODE chỉ hiển thị khi showQR = true
          if (showQR)
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF154B71),
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    // child: QrImageView(
                    //   data:
                    //   "https://diemdanh.poly.edu.vn/qr/${monHoc.lop}_${monHoc.tenMon}",
                    //   version: QrVersions.auto,
                    //   size: 200,
                    //   backgroundColor: Colors.white,
                    //   gapless: true,
                    // ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    diemDanhDangMo
                        ? "Sinh viên quét mã QR để điểm danh"
                        : "QR chưa kích hoạt, nhấn 'Bắt đầu điểm danh'",
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
                  itemCount: monHoc.danhSachSinhVien.length,
                  itemBuilder: (context, index) {
                    final sv = monHoc.danhSachSinhVien[index];
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
                                backgroundImage:
                                AssetImage(sv.avatarOrDefault),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(sv.ten,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                  Text(sv.ma,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black54)),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            sv.trangThai,
                            style: TextStyle(
                                fontSize: 13,
                                color: statusColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

          // Nút bắt đầu / kết thúc + Thống kê
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Thống kê khi điểm danh kết thúc
                if (!diemDanhDangMo && hienThiDanhSach)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildThongKeCard(
                          "Đúng giờ", diDungGio, tongSV, Colors.green),
                      _buildThongKeCard("Đi muộn", diMuon, tongSV, Colors.orange),
                      _buildThongKeCard("Vắng", vang, tongSV, Colors.red),
                    ],
                  ),
                const SizedBox(height: 12),

                // Nút bắt đầu điểm danh
                if (!diemDanhDangMo)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF154B71),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                      ),
                      onPressed: () {
                        setState(() {
                          diemDanhDangMo = true;
                          hienThiDanhSach = true;
                          showQR = true; // Bật QR khi bắt đầu
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Đã bắt đầu điểm danh, sinh viên quét QR")),
                        );
                      },
                      child: const Text(
                        "Bắt đầu điểm danh",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                // Nút kết thúc điểm danh
                if (diemDanhDangMo)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFEBEB),
                        foregroundColor: const Color(0xFFB71C1C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xFFB71C1C)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        setState(() {
                          diemDanhDangMo = false; // QR tạm ẩn
                          hienThiDanhSach = true;
                          showQR = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Đã kết thúc điểm danh")),
                        );
                      },
                      child: const Text(
                        "KẾT THÚC ĐIỂM DANH",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFFB71C1C)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: GiangVienBottomNav(
        currentIndex: 2,
        onTap: (index) {
          print("Chuyển tab: $index");
        },
      ),
    );
  }

  Widget _buildThongKeCard(String title, int soLuong, int tong, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            "$soLuong / $tong",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
