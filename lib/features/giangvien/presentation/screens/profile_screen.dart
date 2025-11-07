import 'package:flutter/material.dart';
import '../../data/models/giangvien_model.dart';
import '../controllers/giangvien_controller.dart';
import '../widgets/giangvien_bottom_nav.dart';
import 'edit_profile_form.dart';
import 'package:face_attendance_flutter/core/network/token_storage.dart';
import '../../data/datasources/lophocphan_remote_datasource.dart'; // để fallback lấy id

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GiangVienController _controller = GiangVienController();
  GiangVien? giangVien;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGiangVien();
  }

  Future<void> _ensureGiangVienId() async {
    final id = await TokenStorage.getGiangVienId();
    if (id != null) return;

    try {
      await LopHocPhanRemoteDataSource().fetchLopHocPhan();
    } catch (_) {}
  }

  Future<void> _loadGiangVien() async {
    try {
      await _ensureGiangVienId();
      await _controller.loadCurrentGiangVien();
      setState(() {
        giangVien = _controller.giangVien;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (giangVien == null) {
      return const Scaffold(
        body: Center(child: Text("Không thể tải thông tin giảng viên.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Hồ sơ giảng viên"),
        backgroundColor: const Color(0xFF154B71),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage('assets/images/teacher.jpg'),
            ),
            const SizedBox(height: 16),
            Text(
              giangVien!.hoTen,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              giangVien!.hocVi ?? '',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // ===== Thông tin cá nhân =====
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(giangVien!.email),
            ),
            if (giangVien!.soDienThoai != null)
              ListTile(
                leading: const Icon(Icons.phone),
                title: Text(giangVien!.soDienThoai!),
              ),

            // ===== Thông tin khoa =====
            if (giangVien!.khoa != null) ...[
              ListTile(
                leading: const Icon(Icons.account_balance),
                title: Text(giangVien!.khoa!.tenKhoa),
                subtitle: Text("Mã khoa: ${giangVien!.khoa!.maKhoa}"),
              ),
              if (giangVien!.khoa!.moTa != null &&
                  giangVien!.khoa!.moTa!.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text("Mô tả khoa"),
                  subtitle: Text(giangVien!.khoa!.moTa!),
                ),
            ],

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfileForm(giangVien: giangVien!),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF154B71),
              ),
              child: const Text("Chỉnh sửa hồ sơ"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const GiangVienBottomNav(currentIndex: 4),
    );
  }
}
