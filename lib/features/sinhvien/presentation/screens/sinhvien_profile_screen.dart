import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/student_profile_model.dart';
import '../../data/repositories/student_profile_repository.dart';
import '../../../auth/presentation/screens/login_screen.dart';

class SinhVienProfileScreen extends StatefulWidget {
  const SinhVienProfileScreen({super.key});

  @override
  State<SinhVienProfileScreen> createState() => _SinhVienProfileScreenState();
}

class _SinhVienProfileScreenState extends State<SinhVienProfileScreen> {
  final StudentProfileRepository _repository = StudentProfileRepository();
  StudentProfile? _profile;
  bool _isLoading = true;
  bool _isUploading = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  /// 🟣 Tải thông tin sinh viên từ API
  Future<void> _loadProfile() async {
    debugPrint("📡 [DEBUG] Gọi API fetchProfile()...");
    try {
      final data = await _repository.fetchProfile();
      debugPrint("✅ [DEBUG] Nhận dữ liệu sinh viên: ${data.toJson()}");
      setState(() {
        _profile = data;
        _nameController.text = data.hoTen;
        _phoneController.text = data.soDienThoai ?? '';
        _isLoading = false;
      });
    } catch (e, stack) {
      debugPrint("❌ [ERROR] Lỗi tải profile: $e");
      debugPrint("📜 [STACKTRACE] $stack");
      setState(() => _isLoading = false);
    }
  }

  /// 🟣 Upload ảnh đại diện
  Future<void> _uploadAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) {
      debugPrint("⚠️ [DEBUG] Người dùng hủy chọn ảnh.");
      return;
    }

    debugPrint("📸 [DEBUG] File ảnh chọn: ${picked.path}");

    setState(() => _isUploading = true);

    try {
      final newUrl = await _repository.uploadAvatar(picked.path);
      debugPrint("✅ [DEBUG] Ảnh upload thành công, URL: $newUrl");
      setState(() {
        _profile = _profile?.copyWith(anhDaiDien: newUrl);
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật ảnh thành công!")),
      );
    } catch (e, stack) {
      debugPrint("❌ [ERROR] Lỗi upload ảnh: $e");
      debugPrint("📜 [STACKTRACE] $stack");
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Lỗi upload ảnh: $e")));
    }
  }

  /// 🟣 Cập nhật thông tin sinh viên (họ tên, số điện thoại)
  Future<void> _updateInfo() async {
    debugPrint("🛠 [DEBUG] Gửi yêu cầu cập nhật thông tin...");
    debugPrint("➡️ Dữ liệu gửi: {hoTen: ${_nameController.text}, soDienThoai: ${_phoneController.text}}");

    try {
      final updated = await _repository.updateProfile(
        hoTen: _nameController.text,
        soDienThoai: _phoneController.text,
      );
      debugPrint("✅ [DEBUG] Cập nhật thành công: ${updated.toJson()}");
      setState(() => _profile = updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật thông tin thành công!")),
      );
    } catch (e, stack) {
      debugPrint("❌ [ERROR] Lỗi cập nhật thông tin: $e");
      debugPrint("📜 [STACKTRACE] $stack");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Lỗi cập nhật thông tin: $e")));
    }
  }

  /// 🟣 Đăng xuất
  Future<void> _logout() async {
    debugPrint("🚪 [DEBUG] Đăng xuất...");
    await _repository.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6C63FF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Thông tin sinh viên"),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Ảnh đại diện
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _profile?.anhDaiDien != null &&
                      _profile!.anhDaiDien!.isNotEmpty
                      ? NetworkImage(_profile!.anhDaiDien!)
                      : const AssetImage('assets/images/default_avatar.png')
                  as ImageProvider,
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: InkWell(
                    onTap: _isUploading ? null : _uploadAvatar,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                      ),
                      child: _isUploading
                          ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Icon(Icons.camera_alt,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Họ tên + lớp
            Text(
              _profile?.hoTen ?? '',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              _profile?.lop ?? '',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // Mã sinh viên (readonly)
            TextField(
              readOnly: true,
              controller:
              TextEditingController(text: _profile?.maSV ?? ''),
              decoration: const InputDecoration(
                labelText: "Mã sinh viên",
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Họ tên (editable)
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Họ tên",
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Email (readonly)
            TextField(
              readOnly: true,
              controller:
              TextEditingController(text: _profile?.email ?? ''),
              decoration: const InputDecoration(
                labelText: "Email (không thể chỉnh sửa)",
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // SĐT (editable)
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: "Số điện thoại",
                border: UnderlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _updateInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Cập nhật thông tin"),
            ),

            const SizedBox(height: 20),

            TextButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                "Đăng xuất",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on StudentProfile {
  StudentProfile copyWith({String? anhDaiDien}) {
    return StudentProfile(
      maSV: maSV,
      hoTen: hoTen,
      email: email,
      lop: lop,
      nganh: nganh,
      soDienThoai: soDienThoai,
      anhDaiDien: anhDaiDien ?? this.anhDaiDien,
    );
  }
}
