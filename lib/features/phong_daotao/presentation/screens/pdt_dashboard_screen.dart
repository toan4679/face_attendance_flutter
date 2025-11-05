import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/network/token_storage.dart';
import '../controllers/pdt_dashboard_controller.dart';
import '../../data/models/lop_hoc_phan_model.dart';
import '../widgets/pdt_dashboard_card.dart';
import 'package:face_attendance_flutter/features/phong_daotao/presentation/screens/manage_nganh_screen.dart';

import 'manage_lophocphan_screen.dart';



class PdtDashboardScreen extends StatefulWidget {
  const PdtDashboardScreen({super.key});

  @override
  State<PdtDashboardScreen> createState() => _PdtDashboardScreenState();
}

class _PdtDashboardScreenState extends State<PdtDashboardScreen> {
  String currentPage = 'Dashboard';

  @override
  Widget build(BuildContext context) {
    final controller = context.read<PdtDashboardController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text('Phòng Đào Tạo Dashboard'),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),

      // 🧭 Drawer có hiển thị user info + trạng thái active
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // 🟣 Header hiển thị thông tin người dùng
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepPurpleAccent),
              child: FutureBuilder<Map<String, String?>>(
                future: TokenStorage.getUserInfo(),
                builder: (context, snapshot) {
                  final user = snapshot.data ?? {};
                  final name = user['name'] ?? 'Phòng Đào Tạo';
                  final email = user['email'] ?? 'pdt@university.edu.vn';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'PHÒNG ĐÀO TẠO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 26,
                            backgroundImage: AssetImage('assets/images/admin_avatar.png'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16)),
                                Text(email,
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),

            // 🧭 Các menu điều hướng
            _buildDrawerItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              isActive: currentPage == 'Dashboard',
              onTap: () {
                setState(() => currentPage = 'Dashboard');
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.school,
              title: 'Quản lý Khoa',
              isActive: currentPage == 'Khoa',
              onTap: () {
                setState(() => currentPage = 'Khoa');
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pdt/khoa');
              },
            ),


            _buildDrawerItem(
              icon: Icons.category,
              title: 'Quản lý Ngành',
              isActive: currentPage == 'Ngành',
              onTap: () {
                setState(() => currentPage = 'Ngành');
                Navigator.pop(context);
                controller.gotoNganh(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.book,
              title: 'Quản lý Môn học',
              isActive: currentPage == 'Môn học',
              onTap: () {
                setState(() => currentPage = 'Môn học');
                Navigator.pop(context);
                controller.gotoMonHoc(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.meeting_room,
              title: 'Quản lý Lớp hành chính',
              isActive: currentPage == 'Lớp hành chính',
              onTap: () {
                setState(() => currentPage = 'Lớp hành chính');
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pdt/lop');
              },
            ),
            _buildDrawerItem(
              icon: Icons.meeting_room,
              title: 'Quản lý Lớp học phần',
              isActive: currentPage == 'Lớp học phần',
              onTap: () {
                setState(() => currentPage = 'Lớp học phần');
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pdt/lophocphan'); // ✅ sử dụng route name chuẩn
              },
            ),

            _buildDrawerItem(
              icon: Icons.event_note,
              title: 'Quản lý Buổi học',
              isActive: currentPage == 'Buổi học',
              onTap: () {
                setState(() => currentPage = 'Buổi học');
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pdt/buoihoc'); // ✅ route mới
              },
            ),
            _buildDrawerItem(
              icon: Icons.schedule,
              title: 'Gán lịch dạy',
              isActive: currentPage == 'Gán lịch',
              onTap: () {
                setState(() => currentPage = 'Gán lịch');
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pdt/assign_schedule');
              },
            ),

            _buildDrawerItem(
              icon: Icons.people,
              title: 'Quản lý Sinh viên',
              isActive: currentPage == 'Sinh viên',
              onTap: () {
                setState(() => currentPage = 'Sinh viên');
                Navigator.pop(context);
                controller.gotoSinhVien(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.image,
              title: 'Quản lý Ảnh sinh viên',
              isActive: currentPage == 'Ảnh sinh viên',
              onTap: () {
                setState(() => currentPage = 'Ảnh sinh viên');
                Navigator.pop(context);
                controller.gotoAnhSinhVien(context);
              },
            ),

            const Divider(),

            // 🚪 Đăng xuất
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Đăng xuất',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Xác nhận đăng xuất'),
                    content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Hủy')),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent),
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Đăng xuất')),
                    ],
                  ),
                );
                if (confirm == true) {
                  await TokenStorage.clearToken();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                          (route) => false,
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),


      // 🧩 Nội dung chính (dashboard + bảng lớp học phần)
      body: FutureBuilder(
        future: Future.wait([
          controller.fetchDashboardStats(),
          controller.fetchLopHocPhanList(),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = snapshot.data![0] as Map<String, dynamic>;
          final lopList = snapshot.data![1] as List<LopHocPhanModel>;

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        _buildStatCard('Môn học', stats['tongMonHoc'].toString(),
                            Colors.purple, width),
                        _buildStatCard('Lớp học phần',
                            stats['tongLopHocPhan'].toString(), Colors.blue, width),
                        _buildStatCard('Giảng viên',
                            stats['tongGiangVien'].toString(), Colors.green, width),
                        _buildStatCard('Sinh viên',
                            stats['tongSinhVien'].toString(), Colors.orange, width),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Danh sách Lớp học phần mới nhất',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints:
                              BoxConstraints(minWidth: constraints.maxWidth - 40),
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(
                                    Colors.deepPurple.shade50),
                                columnSpacing: 20,
                                columns: const [
                                  DataColumn(label: Text('Mã lớp HP')),
                                  DataColumn(label: Text('Môn học')),
                                  DataColumn(label: Text('Ngày bắt đầu')),
                                  DataColumn(label: Text('Ngày kết thúc')),
                                  DataColumn(label: Text('Học kỳ')),
                                  DataColumn(label: Text('Năm học')),
                                ],
                                rows: lopList.map((lop) {
                                  return DataRow(cells: [
                                    DataCell(Text(lop.maSoLopHP)),
                                    DataCell(Text(lop.tenMon ?? '—')),
                                    DataCell(Text(lop.ngayBatDau ?? '—')),
                                    DataCell(Text(lop.ngayKetThuc ?? '—')),
                                    DataCell(Text(lop.hocKy)),
                                    DataCell(Text(lop.namHoc)),
                                  ]);
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // 🟣 Thẻ thống kê responsive
  Widget _buildStatCard(
      String title, String value, Color color, double screenWidth) {
    double cardWidth;
    if (screenWidth >= 1200) {
      cardWidth = (screenWidth - 100) / 4;
    } else if (screenWidth >= 800) {
      cardWidth = (screenWidth - 80) / 2;
    } else {
      cardWidth = screenWidth - 40;
    }
    return SizedBox(
      width: cardWidth,
      child: PdtDashboardCard(title: title, value: value, color: color),
    );
  }

  // 🟢 DrawerItem có trạng thái active
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      color: isActive ? Colors.deepPurple.withOpacity(0.1) : Colors.transparent,
      child: ListTile(
        leading: Icon(icon,
            color: isActive ? Colors.deepPurpleAccent : Colors.black54),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.deepPurpleAccent : Colors.black87,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
