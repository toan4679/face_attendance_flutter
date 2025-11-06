import 'package:flutter/material.dart';
import '../../data/models/giangvien_model.dart';

class EditProfileForm extends StatefulWidget {
  final GiangVien gv;
  final Function(GiangVien updatedGV) onSave;

  const EditProfileForm({super.key, required this.gv, required this.onSave});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late TextEditingController tenController;
  late TextEditingController emailController;
  late TextEditingController sdtController;
  late TextEditingController hocViController;
  late TextEditingController chuyenNganhController;
  late TextEditingController gioiThieuController;

  @override
  void initState() {
    super.initState();
    tenController = TextEditingController(text: widget.gv.ten);
    emailController = TextEditingController(text: widget.gv.email);
    sdtController = TextEditingController(text: widget.gv.sdt);
    hocViController = TextEditingController(text: widget.gv.hocVi);
    chuyenNganhController = TextEditingController(text: widget.gv.chuyenNganh);
    gioiThieuController = TextEditingController(text: widget.gv.gioiThieu);
  }

  @override
  void dispose() {
    tenController.dispose();
    emailController.dispose();
    sdtController.dispose();
    hocViController.dispose();
    chuyenNganhController.dispose();
    gioiThieuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Chỉnh sửa thông tin",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildTextField("SĐT", sdtController),
            _buildTextField("Học vị", hocViController),
            _buildTextField("Chuyên ngành", chuyenNganhController),
            _buildTextField("Giới thiệu", gioiThieuController, maxLines: 3),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  final updatedGV = GiangVien(
                    maGV: widget.gv.maGV,
                    ten: tenController.text,
                    email: emailController.text,
                    sdt: sdtController.text,
                    khoa: widget.gv.khoa,
                    hocVi: hocViController.text,
                    chuyenNganh: chuyenNganhController.text,
                    gioiThieu: gioiThieuController.text,
                    avatarPath: widget.gv.avatarPath,
                  );
                  widget.onSave(updatedGV);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Lưu",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
