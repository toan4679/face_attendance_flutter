import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuoiHocFormDialog extends StatefulWidget {
  final int maLopHP;
  final int? maGV;
  final Map<String, dynamic>? buoi; // ✅ thêm tham số buoi
  final Function(List<Map<String, dynamic>>) onSubmit;

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
  final _phongController = TextEditingController();

  DateTime? ngayBatDau;
  DateTime? ngayKetThuc;
  String? thu;
  int? tietBatDau;
  int? tietKetThuc;
  String? gioBatDau;
  String? gioKetThuc;
  List<String> selectedThu = [];

  final List<String> thuList = [
    'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7', 'Chủ nhật'
  ];
  List<int> tietList = List.generate(12, (i) => i + 1);

  @override
  void initState() {
    super.initState();
    if (widget.buoi != null) {
      // ✅ chế độ SỬA
      thu = widget.buoi!['thu'];
      tietBatDau = widget.buoi!['tietBatDau'];
      tietKetThuc = widget.buoi!['tietKetThuc'];
      _phongController.text = widget.buoi!['phongHoc'] ?? '';
      gioBatDau = widget.buoi!['gioBatDau'];
      gioKetThuc = widget.buoi!['gioKetThuc'];
    }
  }

  /// ✅ Tính giờ học
  void _tinhGioHoc() {
    if (tietBatDau == null || tietKetThuc == null) return;
    DateTime startTime = DateTime(2025, 1, 1, 7, 0);
    Duration tietDuration = const Duration(minutes: 50);
    Duration breakTime = const Duration(minutes: 5);

    DateTime gioBD = startTime.add(Duration(minutes: (tietBatDau! - 1) * 55));
    DateTime gioKT =
    gioBD.add(Duration(minutes: (tietKetThuc! - tietBatDau! + 1) * 55 - 5));

    final format = DateFormat('HH:mm');
    gioBatDau = format.format(gioBD);
    gioKetThuc = format.format(gioKT);
  }

  /// ✅ Tạo danh sách ngày học theo thứ
  List<DateTime> _sinhNgayHoc() {
    if (ngayBatDau == null || ngayKetThuc == null || selectedThu.isEmpty) return [];
    List<DateTime> result = [];
    DateTime current = ngayBatDau!;
    while (!current.isAfter(ngayKetThuc!)) {
      String weekday = _thuTuSo(current.weekday);
      if (selectedThu.contains(weekday)) result.add(current);
      current = current.add(const Duration(days: 1));
    }
    return result;
  }

  String _thuTuSo(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Thứ 2';
      case DateTime.tuesday:
        return 'Thứ 3';
      case DateTime.wednesday:
        return 'Thứ 4';
      case DateTime.thursday:
        return 'Thứ 5';
      case DateTime.friday:
        return 'Thứ 6';
      case DateTime.saturday:
        return 'Thứ 7';
      default:
        return 'Chủ nhật';
    }
  }

  /// ✅ Gửi dữ liệu
  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _tinhGioHoc();

    if (widget.buoi != null) {
      // ✅ SỬA 1 BUỔI
      final body = {
        'maLopHP': widget.maLopHP,
        'maGV': widget.maGV,
        'thu': thu,
        'tietBatDau': tietBatDau,
        'tietKetThuc': tietKetThuc,
        'phongHoc': _phongController.text.trim(),
        'gioBatDau': gioBatDau,
        'gioKetThuc': gioKetThuc,
      };
      widget.onSubmit([body]);
      Navigator.pop(context);
      return;
    }

    // ✅ TẠO NHIỀU BUỔI HỌC
    if (ngayBatDau == null || ngayKetThuc == null || selectedThu.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Chọn ngày và thứ học hợp lệ')),
      );
      return;
    }

    final ngayList = _sinhNgayHoc();
    final List<Map<String, dynamic>> buoiList = ngayList.map((ngay) {
      return {
        'maLopHP': widget.maLopHP,
        'maGV': widget.maGV,
        'thu': _thuTuSo(ngay.weekday),
        'ngayHoc': DateFormat('yyyy-MM-dd').format(ngay),
        'tietBatDau': tietBatDau,
        'tietKetThuc': tietKetThuc,
        'phongHoc': _phongController.text.trim(),
        'gioBatDau': gioBatDau,
        'gioKetThuc': gioKetThuc,
      };
    }).toList();

    widget.onSubmit(buoiList);
    Navigator.pop(context);
  }

  /// ✅ Chọn ngày
  Future<void> _chonNgay(BuildContext context, bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      locale: const Locale('vi', 'VN'),
    );
    if (picked != null) {
      setState(() {
        if (isStart) ngayBatDau = picked;
        else ngayKetThuc = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.buoi != null;
    return AlertDialog(
      title: Text(isEdit ? 'Chỉnh sửa buổi học' : 'Tạo nhiều buổi học tự động'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            if (!isEdit) ...[
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(ngayBatDau == null
                        ? 'Ngày bắt đầu'
                        : DateFormat('dd/MM/yyyy').format(ngayBatDau!)),
                    onPressed: () => _chonNgay(context, true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(ngayKetThuc == null
                        ? 'Ngày kết thúc'
                        : DateFormat('dd/MM/yyyy').format(ngayKetThuc!)),
                    onPressed: () => _chonNgay(context, false),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: thuList.map((t) {
                  final isSelected = selectedThu.contains(t);
                  return ChoiceChip(
                    label: Text(t),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        if (isSelected) selectedThu.remove(t);
                        else selectedThu.add(t);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],

            // ✅ nếu sửa thì chỉ chọn thứ
            if (isEdit)
              DropdownButtonFormField<String>(
                value: thu,
                items: thuList.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => thu = v),
                decoration: const InputDecoration(
                    labelText: 'Thứ', border: OutlineInputBorder()),
                validator: (v) => v == null ? 'Chọn thứ' : null,
              ),

            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: tietBatDau,
                    items: tietList.map((e) =>
                        DropdownMenuItem(value: e, child: Text('Tiết $e'))).toList(),
                    onChanged: (v) => setState(() => tietBatDau = v),
                    decoration: const InputDecoration(
                        labelText: 'Tiết bắt đầu', border: OutlineInputBorder()),
                    validator: (v) => v == null ? 'Chọn tiết bắt đầu' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: tietKetThuc,
                    items: tietList.map((e) =>
                        DropdownMenuItem(value: e, child: Text('Tiết $e'))).toList(),
                    onChanged: (v) => setState(() => tietKetThuc = v),
                    decoration: const InputDecoration(
                        labelText: 'Tiết kết thúc', border: OutlineInputBorder()),
                    validator: (v) => v == null ? 'Chọn tiết kết thúc' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _phongController,
              decoration: const InputDecoration(
                labelText: 'Phòng học',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              (v == null || v.isEmpty) ? 'Nhập phòng học' : null,
            ),
            const SizedBox(height: 8),
            if (gioBatDau != null && gioKetThuc != null)
              Text('🕒 $gioBatDau - $gioKetThuc'),
          ]),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
          onPressed: _submit,
          child: Text(isEdit ? 'Cập nhật' : 'Tạo buổi học'),
        ),
      ],
    );
  }
}
