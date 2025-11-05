import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/khoa_controller.dart';
import '../../data/models/khoa_model.dart';

class KhoaFormDialog extends StatefulWidget {
  final KhoaModel? khoa;
  const KhoaFormDialog({super.key, this.khoa});

  @override
  State<KhoaFormDialog> createState() => _KhoaFormDialogState();
}

class _KhoaFormDialogState extends State<KhoaFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tenKhoaCtrl;
  late TextEditingController _moTaCtrl;

  @override
  void initState() {
    super.initState();
    _tenKhoaCtrl = TextEditingController(text: widget.khoa?.tenKhoa ?? '');
    _moTaCtrl = TextEditingController(text: widget.khoa?.moTa ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<KhoaController>();
    return AlertDialog(
      title: Text(widget.khoa == null ? 'Thêm Khoa' : 'Sửa Khoa'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _tenKhoaCtrl,
              decoration: const InputDecoration(labelText: 'Tên khoa'),
              validator: (v) => v == null || v.isEmpty ? 'Nhập tên khoa' : null,
            ),
            TextFormField(
              controller: _moTaCtrl,
              decoration: const InputDecoration(labelText: 'Mô tả'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if (widget.khoa == null) {
                await controller.addKhoa(_tenKhoaCtrl.text, _moTaCtrl.text);
              } else {
                await controller.updateKhoa(
                    widget.khoa!.maKhoa!, _tenKhoaCtrl.text, _moTaCtrl.text);
              }
              if (context.mounted) Navigator.pop(context);
            }
          },
          child: const Text('Lưu'),
        )
      ],
    );
  }
}
