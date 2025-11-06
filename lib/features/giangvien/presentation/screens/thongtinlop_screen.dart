import 'package:flutter/material.dart';
import '../../data/models/buoihoc_model.dart';
import '../../data/models/giangvien_model.dart';
import '../../data/models/sinhvien_model.dart';
import '../widgets/giangvien_bottom_nav.dart';
import 'chitiet_sv_diemdanh_screen.dart';

class ThongTinLopScreen extends StatefulWidget {
  final BuoiHoc lop; // nhận BuoiHoc từ màn hình trước

  const ThongTinLopScreen({super.key, required this.lop});

  @override
  State<ThongTinLopScreen> createState() => _ThongTinLopScreenState();
}

class _ThongTinLopScreenState extends State<ThongTinLopScreen> {
  int _selectedIndex = 3;
  String _searchQuery = ''; // Từ khóa tìm kiếm

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String getThuFromDate(DateTime? date) {
    if (date == null) return "Chưa có";
    switch (date.weekday) {
      case 1:
        return "2";
      case 2:
        return "3";
      case 3:
        return "4";
      case 4:
        return "5";
      case 5:
        return "6";
      case 6:
        return "7";
      case 7:
        return "CN";
      default:
        return "Chưa có";
    }
  }

  // Tỉ lệ điểm danh từng sinh viên
  double tiLeDiemDanhCuaSinhVien(SinhVien sv, BuoiHoc lop) {
    if (lop.diemDanhHienTai == null || lop.diemDanhHienTai == 0) return 0;
    return (sv.soBuoiDiemDanh / lop.diemDanhHienTai!).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final lop = widget.lop;
    final sinhVienCuaLop = lop.danhSachSinhVien;

    // --- Lọc danh sách sinh viên theo từ khóa ---
    final sinhVienLoc = sinhVienCuaLop
        .where((sv) => sv.ten.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF154B71),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "THÔNG TIN LỚP HỌC",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Chức năng thông báo đang được phát triển..."),
                ),
              );
            },
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF0F0F0),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(45)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== ẢNH + TÊN GIẢNG VIÊN =====
            Container(
              width: double.infinity,
              color: const Color(0xFFEFF5F9),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(currentGV.avatarPath),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    currentGV.ten,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // ===== BODY NỘI DUNG =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- THÔNG TIN LỚP ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${lop.tenMon} - ${lop.lop}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                              "Thứ: ${getThuFromDate(lop.ngay)} - Phòng: ${lop.phong ?? 'Chưa có'}"),
                          const SizedBox(height: 4),
                          Text(
                              "Số buổi đã điểm danh: ${lop.diemDanhHienTai ?? 0}"),
                          const SizedBox(height: 4),
                          Text("Số tiết: ${lop.tongSoBuoi ?? 0}"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // --- TIÊU ĐỀ + NÚT XUẤT EXCEL ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Danh sách sinh viên",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // ✅ Chưa làm gì - chỉ hiển thị thông báo
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Tính năng xuất Excel đang được phát triển...',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.file_download, size: 18),
                          label: const Text(
                            "Xuất Excel",
                            style: TextStyle(fontSize: 13),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFF6FBF73), // ✅ Màu xanh nhạt hơn
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // --- THANH TÌM KIẾM SINH VIÊN ---
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Tìm kiếm sinh viên theo tên...',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    // --- DANH SÁCH SINH VIÊN ---
                    sinhVienLoc.isEmpty
                        ? const Center(
                        child: Text("Không tìm thấy sinh viên nào"))
                        : Column(
                      children: sinhVienLoc.map((sv) {
                        double tiLe = tiLeDiemDanhCuaSinhVien(sv, lop);

                        return InkWell(
                          onTap: () {
                            final buoiThucTe =
                            BuoiHoc.buoiHocMau.firstWhere(
                                  (b) =>
                              b.tenMon == lop.tenMon &&
                                  b.lop == lop.lop,
                              orElse: () => BuoiHoc(
                                tenMon: lop.tenMon,
                                lop: lop.lop,
                                phong: lop.phong,
                                diemDanhHienTai: lop.diemDanhHienTai,
                                tongSoBuoi: lop.tongSoBuoi,
                                danhSachSinhVien: [],
                              ),
                            );

                            final diemDanhSV =
                                buoiThucTe.diemDanhChiTietCuaSV[sv.ma] ??
                                    [];

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BuoiDaDiemDanhScreen(
                                  tenSinhVien: sv.ten,
                                  maSinhVien: sv.ma,
                                  avatarPath: sv.avatarOrDefault,
                                  diemDanh: diemDanhSV,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
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
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                  AssetImage(sv.avatarOrDefault),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sv.ten,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      Text(
                                        "MSV: ${sv.ma}",
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        "Tỉ lệ điểm danh: ${(tiLe * 100).toStringAsFixed(1)}%",
                                        style: const TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GiangVienBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
