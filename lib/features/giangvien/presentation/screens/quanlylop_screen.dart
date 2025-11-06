import 'package:flutter/material.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../widgets/gv_side_menu.dart';
import '../../data/models/buoihoc_model.dart';
import 'thongtinlop_screen.dart'; // import màn hình thông tin lớp

class QuanLyLopScreen extends StatefulWidget {
  const QuanLyLopScreen({super.key, required this.giangVienId});

  final String giangVienId;

  @override
  State<QuanLyLopScreen> createState() => _QuanLyLopScreenState();
}

class _QuanLyLopScreenState extends State<QuanLyLopScreen> {
  final int _selectedIndex = 3;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách lớp theo từ khóa tìm kiếm
    final filteredClasses = BuoiHoc.buoiHocMau.where((buoi) {
      return buoi.lop.toLowerCase().contains(searchText.toLowerCase()) ||
          buoi.tenMon.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: GVSideMenu(
        giangVienId: widget.giangVienId,
        onClose: () => Navigator.pop(context),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF154B71),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            ),
            const Center(
              child: Text(
                "QUẢN LÝ LỚP HỌC",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Avatar + tên giáo viên =====
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/images/teacher.jpg'),
                ),
                const SizedBox(width: 12),
                const Text(
                  "GV. Nguyễn Văn A",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ],
            ),
          ),
          // ===== Danh sách lớp =====
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(45)),
              ),
              child: Column(
                children: [
                  // Thanh tìm kiếm
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            "Lớp học",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Tìm kiếm lớp...",
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              suffixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchText = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // List lớp
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredClasses.length,
                      itemBuilder: (context, index) {
                        final buoi = filteredClasses[index];
                        return GestureDetector(
                          onTap: () {
                            // Điều hướng sang màn hình Thông tin lớp
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ThongTinLopScreen(lop: buoi),
                              ),
                            );
                          },
                          child: Container(
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
                                Text(
                                  "${buoi.tenMon} - ${buoi.lop}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Phòng: ${buoi.phong}",
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black54),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Điểm danh: ${buoi.diemDanhHienTai ?? 0}/${buoi.tongSoBuoi ?? 0}",
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    Text(
                                      "${(buoi.tiLeDiemDanh * 100).toStringAsFixed(1)}%",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: buoi.tiLeDiemDanh,
                                    backgroundColor: Colors.grey[300],
                                    color: const Color(0xFF154B71),
                                    minHeight: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: GiangVienBottomNav(
        currentIndex: _selectedIndex,
      ),
    );
  }
}
