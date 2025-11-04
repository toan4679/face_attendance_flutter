import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/mon_hoc_model.dart';
import '../controllers/mon_hoc_controller.dart';

class MonHocFormDialog extends StatefulWidget {
  final MonHocModel? monHoc;
  const MonHocFormDialog({super.key, this.monHoc});

  @override
  State<MonHocFormDialog> createState() => _MonHocFormDialogState();
}

class _MonHocFormDialogState extends State<MonHocFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController maSoCtrl;
  late TextEditingController tenCtrl;
  late TextEditingController tinChiCtrl;
  late TextEditingController moTaCtrl;

  @override
  void initState() {
    super.initState();
    maSoCtrl = TextEditingController(text: widget.monHoc?.maSoMon ?? '');
    tenCtrl = TextEditingController(text: widget.monHoc?.tenMon ?? '');
    tinChiCtrl =
        TextEditingController(text: widget.monHoc?.soTinChi.toString() ?? '');
    moTaCtrl = TextEditingController(text: widget.monHoc?.moTa ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<MonHocController>();
    final isEdit = widget.monHoc != null;

    return AlertDialog(
      title: Text(isEdit ? 'Chỉnh sửa Môn học' : 'Thêm Môn học mới'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: maSoCtrl,
                decoration: const InputDecoration(labelText: 'Mã số môn'),
                validator: (v) => v!.isEmpty ? 'Nhập mã môn' : null,
              ),
              TextFormField(
                controller: tenCtrl,
                decoration: const InputDecoration(labelText: 'Tên môn học'),
                validator: (v) => v!.isEmpty ? 'Nhập tên môn học' : null,
              ),
              TextFormField(
                controller: tinChiCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Số tín chỉ'),
              ),
              TextFormField(
                controller: moTaCtrl,
                decoration: const InputDecoration(labelText: 'Mô tả'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy')),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final newMon = MonHocModel(
                maMon: widget.monHoc?.maMon ?? 0,
                maNganh: 1,
                maSoMon: maSoCtrl.text,
                tenMon: tenCtrl.text,
                soTinChi: int.parse(tinChiCtrl.text),
                moTa: moTaCtrl.text,
                tenNganh: widget.monHoc?.tenNganh ?? 'Công nghệ phần mềm',
              );
              if (isEdit) {
                await controller.updateMonHoc(widget.monHoc!.maMon, newMon);
              } else {
                await controller.addMonHoc(newMon);
              }
              if (context.mounted) Navigator.pop(context, true);
            }
          },
          child: Text(isEdit ? 'Cập nhật' : 'Thêm mới'),
        ),
      ],
    );
  }
}
