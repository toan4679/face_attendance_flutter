import 'package:flutter/material.dart';
import '../../data/models/buoi_hoc_model.dart';

class BuoiHocFormDialog extends StatefulWidget {
  final int maLopHP; // bắt buộc
  final int? maGV;   // nếu muốn cố định theo giảng viên đã chọn ngoài màn hình
  final BuoiHocModel? buoi;
  final void Function(Map<String, dynamic>) onSubmit;

  const BuoiHocFormDialog({
    super.key,
    required this.maLopHP,
    this.maGV,
    this.buoi,
    required this.onSubmit,
  });

  @override
  State<BuoiHocFormDialog> createState() => _BuoiHocFormDialogState();
}

class _BuoiHocFormDialogState extends State<BuoiHocFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final _thuList = const ['Thứ 2','Thứ 3','Thứ 4','Thứ 5','Thứ 6','Thứ 7','Chủ nhật'];
  String? _thu;
  int? _tietStart;
  int? _tietEnd;
  final _phong = TextEditingController();
  final _tiets = List<int>.generate(12, (i) => i + 1);

  @override
  void initState() {
    super.initState();
    if (widget.buoi != null) {
      _thu = widget.buoi!.thu;
      _tietStart = widget.buoi!.tietBatDau;
      _tietEnd = widget.buoi!.tietKetThuc;
      _phong.text = widget.buoi!.phongHoc;
    }
  }

  @override
  void dispose() {
    _phong.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.buoi == null ? 'Thêm buổi học' : 'Sửa buổi học'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<String>(
              value: _thu,
              items: _thuList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _thu = v),
              decoration: const InputDecoration(labelText: 'Thứ', border: OutlineInputBorder()),
              validator: (v) => v == null ? 'Chọn thứ' : null,
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _tietStart,
                  items: _tiets.map((e) => DropdownMenuItem(value: e, child: Text('Tiết $e'))).toList(),
                  onChanged: (v) => setState(() => _tietStart = v),
                  decoration: const InputDecoration(labelText: 'Tiết bắt đầu', border: OutlineInputBorder()),
                  validator: (v) => v == null ? 'Chọn tiết bắt đầu' : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _tietEnd,
                  items: _tiets.map((e) => DropdownMenuItem(value: e, child: Text('Tiết $e'))).toList(),
                  onChanged: (v) => setState(() => _tietEnd = v),
                  decoration: const InputDecoration(labelText: 'Tiết kết thúc', border: OutlineInputBorder()),
                  validator: (v) {
                    if (v == null) return 'Chọn tiết kết thúc';
                    if (_tietStart != null && v < _tietStart!) return 'Phải ≥ tiết bắt đầu';
                    return null;
                  },
                ),
              ),
            ]),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phong,
              decoration: const InputDecoration(labelText: 'Phòng học', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Nhập phòng học' : null,
            ),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final body = {
              'maLopHP': widget.maLopHP,
              if (widget.maGV != null) 'maGV': widget.maGV,
              'thu': _thu!,
              'tietBatDau': _tietStart!,
              'tietKetThuc': _tietEnd!,
              'phongHoc': _phong.text.trim(),
            };
            print('[DEBUG] 📨 SUBMIT BUOIHOC BODY: $body');
            widget.onSubmit(body);
            Navigator.pop(context);
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}
