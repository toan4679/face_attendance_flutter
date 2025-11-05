import 'package:flutter/material.dart';
import '../../data/models/lichday_model.dart';

class AssignScheduleForm extends StatefulWidget {
  final int maGV;
  final LichDayModel? lich;
  final Function(Map<String, dynamic>) onSubmit;

  const AssignScheduleForm({
    super.key,
    required this.maGV,
    this.lich,
    required this.onSubmit,
  });

  @override
  State<AssignScheduleForm> createState() => _AssignScheduleFormState();
}

class _AssignScheduleFormState extends State<AssignScheduleForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> thuList = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
  String? thu;
  String? tietBatDau;
  String? tietKetThuc;
  final TextEditingController _phongController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.lich != null) {
      thu = widget.lich!.thu;
      tietBatDau = widget.lich!.tietBatDau;
      tietKetThuc = widget.lich!.tietKetThuc;
      _phongController.text = widget.lich!.phongHoc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.lich == null ? 'Gán lịch mới' : 'Sửa lịch dạy'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<String>(
              value: thu,
              items: thuList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => thu = v),
              decoration: const InputDecoration(
                labelText: 'Thứ',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v == null ? 'Chọn thứ' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: tietBatDau,
              decoration: const InputDecoration(labelText: 'Tiết bắt đầu', border: OutlineInputBorder()),
              onSaved: (v) => tietBatDau = v,
              validator: (v) => (v == null || v.isEmpty) ? 'Nhập tiết bắt đầu' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: tietKetThuc,
              decoration: const InputDecoration(labelText: 'Tiết kết thúc', border: OutlineInputBorder()),
              onSaved: (v) => tietKetThuc = v,
              validator: (v) => (v == null || v.isEmpty) ? 'Nhập tiết kết thúc' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phongController,
              decoration: const InputDecoration(labelText: 'Phòng học', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.isEmpty) ? 'Nhập phòng học' : null,
            ),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final body = {
                'maGV': widget.maGV,
                'thu': thu,
                'tietBatDau': tietBatDau,
                'tietKetThuc': tietKetThuc,
                'phongHoc': _phongController.text.trim(),
              };
              print('[DEBUG] 📨 SUBMIT LỊCH: $body');
              widget.onSubmit(body);
              Navigator.pop(context);
            }
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}
