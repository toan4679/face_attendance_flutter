import 'package:flutter/material.dart';
import '../../data/models/lop_model.dart';
import 'package:provider/provider.dart';

import '../controllers/lop_controller.dart';

class LopFormDialog extends StatefulWidget {
  final LopModel? lop;
  const LopFormDialog({super.key, this.lop});

  @override
  State<LopFormDialog> createState() => _LopFormDialogState();
}

class _LopFormDialogState extends State<LopFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController maLopCtrl;
  late TextEditingController tenLopCtrl;
  late TextEditingController maNganhCtrl;
  late TextEditingController siSoCtrl;

  @override
  void initState() {
    super.initState();
    maLopCtrl = TextEditingController(text: widget.lop?.maLop ?? '');
    tenLopCtrl = TextEditingController(text: widget.lop?.tenLop ?? '');
    maNganhCtrl = TextEditingController(text: widget.lop?.maNganh ?? '');
    siSoCtrl = TextEditingController(text: widget.lop?.siSo.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<LopController>();
    return AlertDialog(
      title: Text(widget.lop == null ? 'Thêm Lớp học' : 'Cập nhật Lớp học'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: maLopCtrl,
              decoration: const InputDecoration(labelText: 'Mã lớp'),
              validator: (v) => v == null || v.isEmpty ? 'Nhập mã lớp' : null,
            ),
            TextFormField(
              controller: tenLopCtrl,
              decoration: const InputDecoration(labelText: 'Tên lớp'),
              validator: (v) => v == null || v.isEmpty ? 'Nhập tên lớp' : null,
            ),
            TextFormField(
              controller: maNganhCtrl,
              decoration: const InputDecoration(labelText: 'Mã ngành'),
            ),
            TextFormField(
              controller: siSoCtrl,
              decoration: const InputDecoration(labelText: 'Sĩ số'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final newLop = LopModel(
                maLop: maLopCtrl.text,
                tenLop: tenLopCtrl.text,
                maNganh: maNganhCtrl.text,
                siSo: int.tryParse(siSoCtrl.text) ?? 0,
              );

              if (widget.lop == null) {
                await controller.addLop(newLop);
              } else {
                await controller.updateLop(newLop);
              }
              if (mounted) Navigator.pop(context, true);
            }
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}
