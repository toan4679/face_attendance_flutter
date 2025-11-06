import 'package:flutter/material.dart';
import '../../data/models/lophocphan_model.dart';
import '../../data/repositories/lophocphan_repository.dart';
import '../../data/datasources/lophocphan_remote_datasource.dart';
import '../../data/models/giangvien_model.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../widgets/gv_side_menu.dart';
import 'thongtinlop_screen.dart';

class QuanLyLopScreen extends StatefulWidget {
  final GiangVien? giangVien;

  const QuanLyLopScreen({super.key, this.giangVien});

  @override
  State<QuanLyLopScreen> createState() => _QuanLyLopScreenState();
}

class _QuanLyLopScreenState extends State<QuanLyLopScreen> {
  final int _selectedIndex = 3;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String searchText = '';
  bool loading = true;
  List<LopHocPhan> dsLop = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final repo = LopHocPhanRepository(LopHocPhanRemoteDataSource());
      final data = await repo.getLopHocPhan();
      setState(() {
        dsLop = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi tải dữ liệu lớp: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = dsLop.where((lop) {
      return lop.maSoLopHP.toLowerCase().contains(searchText.toLowerCase()) ||
          lop.monHoc.tenMon.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: GVSideMenu(
        giangVienId: widget.giangVien?.maGV.toString() ?? '',
        onClose: () => Navigator.pop(context),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF154B71),
        title: const Text(
          "QUẢN LÝ LỚP HỌC",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/images/teacher.jpg'),
                ),
                const SizedBox(width: 12),
                Text(
                  widget.giangVien?.hoTen ?? "Đang tải...",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius:
                BorderRadius.only(topLeft: Radius.circular(45)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            "Lớp học phần",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Tìm kiếm lớp...",
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (v) =>
                                setState(() => searchText = v),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final lop = filtered[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ThongTinLopScreen(lop: lop),
                              ),
                            );
                          },
                          child: Container(
                            margin:
                            const EdgeInsets.symmetric(vertical: 8),
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
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${lop.monHoc.tenMon} - ${lop.maSoLopHP}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  lop.thongTinLichHoc,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Điểm danh: ${lop.diemDanhHienTai}/${lop.tongSoBuoi}",
                                      style:
                                      const TextStyle(fontSize: 13),
                                    ),
                                    Text(
                                      "${(lop.tiLeDiemDanh * 100).toStringAsFixed(1)}%",
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: lop.tiLeDiemDanh,
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
      bottomNavigationBar: GiangVienBottomNav(currentIndex: _selectedIndex),
    );
  }
}
