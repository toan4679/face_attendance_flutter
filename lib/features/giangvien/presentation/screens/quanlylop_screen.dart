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
  String? _error;
  List<LopHocPhan> dsLop = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    if (widget.giangVien?.maGV == null) {
      setState(() {
        loading = false;
        _error = "Giảng viên không hợp lệ";
      });
      return;
    }

    try {
      final repo = LopHocPhanRepository(LopHocPhanRemoteDataSource());
      final data = await repo.getLopHocPhan(widget.giangVien!.maGV);
      if (mounted) {
        setState(() {
          dsLop = data;
          loading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
          _error = e.toString();
        });
      }
    }
  }

  void _clearError() => setState(() => _error = null);

  void _retryLoadData() {
    setState(() => loading = true);
    _loadData();
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
        elevation: 0,
        title: const Text(
          "QUẢN LÝ LỚP HỌC",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withOpacity(0.3),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          loading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF154B71)))
              : SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: const Color(0xFF154B71),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 32, color: Color(0xFF154B71)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.giangVien?.hoTen ?? "Đang tải...",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Mã GV: ${widget.giangVien?.maGV ?? '--'}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Lớp học phần",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF154B71),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Tìm kiếm lớp...",
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[100],
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF154B71)),
                          suffixIcon: searchText.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () => setState(() => searchText = ''),
                          )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (v) => setState(() => searchText = v),
                      ),
                    ],
                  ),
                ),
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.class_, size: 48, color: Colors.grey[300]),
                        const SizedBox(height: 12),
                        Text(
                          "Không tìm thấy lớp học",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final lop = filtered[index];
                        final attendancePercent = (lop.tiLeDiemDanh * 100).toInt();

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ThongTinLopScreen(lop: lop),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            lop.monHoc.tenMon,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color(0xFF154B71),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            lop.maSoLopHP,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF154B71).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "$attendancePercent%",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF154B71),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    lop.thongTinLichHoc,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Điểm danh: ${lop.diemDanhHienTai}/${lop.tongSoBuoi}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: attendancePercent >= 80
                                            ? Colors.green.withOpacity(0.1)
                                            : attendancePercent >= 60
                                            ? Colors.orange.withOpacity(0.1)
                                            : Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        attendancePercent >= 80
                                            ? "Tốt"
                                            : attendancePercent >= 60
                                            ? "Trung bình"
                                            : "Cần cải thiện",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: attendancePercent >= 80
                                              ? Colors.green
                                              : attendancePercent >= 60
                                              ? Colors.orange
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: lop.tiLeDiemDanh,
                                    backgroundColor: Colors.grey[200],
                                    color: attendancePercent >= 80
                                        ? Colors.green
                                        : attendancePercent >= 60
                                        ? Colors.orange
                                        : Colors.red,
                                    minHeight: 6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          if (_error != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 5) _clearError();
                },
                child: Container(
                  color: Colors.red.withOpacity(0.95),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Lỗi tải dữ liệu",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _error!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _clearError,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.2),
                              ),
                              child: const Text(
                                "Đóng",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _retryLoadData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              child: const Text(
                                "Thử lại",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: GiangVienBottomNav(currentIndex: _selectedIndex),
    );
  }
}
