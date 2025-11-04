import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/nganh_controller.dart';
import '../../data/models/nganh_model.dart';

class NganhFormDialog extends StatefulWidget {
  final NganhModel? nganh;
  const NganhFormDialog({super.key, this.nganh});

  @override
  State<NganhFormDialog> createState() => _NganhFormDialogState();
}

class _NganhFormDialogState extends State<NganhFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController maSoCtrl;
  late TextEditingController tenCtrl;
  late TextEditingController moTaCtrl;

  @override
  void initState() {
    super.initState();
    // 🔹 Khởi tạo controller an toàn (dùng late để không thể null)
    maSoCtrl = TextEditingController(text: widget.nganh?.maSo ?? '');
    tenCtrl = TextEditingController(text: widget.nganh?.tenNganh ?? '');
    moTaCtrl = TextEditingController(text: widget.nganh?.moTa ?? '');
  }

  @override
  void dispose() {
    // 🔹 Giải phóng bộ nhớ khi dialog đóng
    maSoCtrl.dispose();
    tenCtrl.dispose();
    moTaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<NganhController>();

    return AlertDialog(
      title: Text(widget.nganh == null ? 'Thêm Ngành' : 'Chỉnh sửa Ngành'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: maSoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Mã số ngành',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Không được để trống' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: tenCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tên ngành',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Không được để trống' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: moTaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.only(right: 12, bottom: 8),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
          child: const Text('Hủy'),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.save, size: 18),
          label: const Text('Lưu'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            final newNganh = NganhModel(
              maNganh: widget.nganh?.maNganh ?? 0,
              maSo: maSoCtrl.text.trim(),
              tenNganh: tenCtrl.text.trim(),
              maKhoa: 1, // 🟣 sau này bạn có thể chọn khoa từ dropdown
              moTa: moTaCtrl.text.trim(),
            );

            try {
              if (widget.nganh == null) {
                await controller.addNganh(newNganh);
              } else {
                await controller.updateNganh(widget.nganh!.maNganh, newNganh);
              }

              if (context.mounted) Navigator.pop(context, true);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('❌ Lỗi lưu ngành: $e')),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
