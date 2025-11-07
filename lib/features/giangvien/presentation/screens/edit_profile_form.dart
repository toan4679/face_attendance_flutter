import 'package:flutter/material.dart';
import '../../data/models/giangvien_model.dart';
import '../controllers/giangvien_controller.dart';

class EditProfileForm extends StatefulWidget {
  final GiangVien giangVien;

  const EditProfileForm({super.key, required this.giangVien});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final GiangVienController _controller = GiangVienController();

  late TextEditingController _hoTenController;
  late TextEditingController _emailController;
  late TextEditingController _soDienThoaiController;
  late TextEditingController _hocViController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _hoTenController = TextEditingController(text: widget.giangVien.hoTen);
    _emailController = TextEditingController(text: widget.giangVien.email);
    _soDienThoaiController =
        TextEditingController(text: widget.giangVien.soDienThoai ?? '');
    _hocViController = TextEditingController(text: widget.giangVien.hocVi ?? '');
  }

  @override
  void dispose() {
    _hoTenController.dispose();
    _emailController.dispose();
    _soDienThoaiController.dispose();
    _hocViController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // Gọi API cập nhật giảng viên
      final updatedGV = GiangVien(
        maGV: widget.giangVien.maGV,
        hoTen: _hoTenController.text.trim(),
        email: _emailController.text.trim(),
        soDienThoai: _soDienThoaiController.text.trim(),
        hocVi: _hocViController.text.trim(),
        maKhoa: widget.giangVien.maKhoa,
        khoa: widget.giangVien.khoa,
      );

      await _controller.updateGiangVien(updatedGV);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cập nhật hồ sơ thành công!")),
        );
        Navigator.pop(context, true); // trở lại trang hồ sơ
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi khi lưu: $e")),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa hồ sơ"),
        backgroundColor: const Color(0xFF154B71),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ===== Họ tên =====
              TextFormField(
                controller: _hoTenController,
                decoration: const InputDecoration(
                  labelText: "Họ tên",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Vui lòng nhập họ tên" : null,
              ),
              const SizedBox(height: 16),

              // ===== Email =====
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Vui lòng nhập email" : null,
              ),
              const SizedBox(height: 16),

              // ===== Số điện thoại =====
              TextFormField(
                controller: _soDienThoaiController,
                decoration: const InputDecoration(
                  labelText: "Số điện thoại",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // ===== Học vị =====
              TextFormField(
                controller: _hocViController,
                decoration: const InputDecoration(
                  labelText: "Học vị",
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // ===== Tên khoa (chỉ xem) =====
              if (widget.giangVien.khoa != null)
                TextFormField(
                  readOnly: true,
                  initialValue: widget.giangVien.khoa!.tenKhoa,
                  decoration: const InputDecoration(
                    labelText: "Khoa",
                    prefixIcon: Icon(Icons.account_balance),
                    border: OutlineInputBorder(),
                  ),
                ),
              const SizedBox(height: 16),

              // ===== Nút lưu =====
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveProfile,
                icon: _isSaving
                    ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Icon(Icons.save),
                label: Text(_isSaving ? "Đang lưu..." : "Lưu thay đổi"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF154B71),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
