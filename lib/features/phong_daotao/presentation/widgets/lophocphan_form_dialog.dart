import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/lop_hoc_phan_model.dart';

class LopHocPhanFormDialog extends StatefulWidget {
  final LopHocPhanModel? lop;
  final Function(Map<String, dynamic>) onSubmit;

  const LopHocPhanFormDialog({
    super.key,
    this.lop,
    required this.onSubmit,
  });

  @override
  State<LopHocPhanFormDialog> createState() => _LopHocPhanFormDialogState();
}

class _LopHocPhanFormDialogState extends State<LopHocPhanFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> formData = {};
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  List<Map<String, dynamic>> monHocList = [];
  int? selectedMaMon;

  @override
  void initState() {
    super.initState();
    _prefillIfEdit();
    _fetchMonHoc();
  }

  void _prefillIfEdit() {
    if (widget.lop == null) return;

    formData.addAll({
      'maSoLopHP': widget.lop!.maSoLopHP,
      'hocKy': widget.lop!.hocKy,
      'namHoc': widget.lop!.namHoc,
    });
    _startController.text = widget.lop!.ngayBatDau ?? '';
    _endController.text = widget.lop!.ngayKetThuc ?? '';
  }

  Future<void> _fetchMonHoc() async {
    try {
      print('[DEBUG] 📡 Fetching môn học...');
      final res = await ApiClient.instance.dio.get('/v1/pdt/monhoc');

      List<Map<String, dynamic>> fetchedList = [];

      if (res.data is List) {
        fetchedList = List<Map<String, dynamic>>.from(res.data);
      } else if (res.data is Map && res.data['data'] is List) {
        fetchedList = List<Map<String, dynamic>>.from(res.data['data']);
      }

      setState(() {
        monHocList = fetchedList;
      });

      print('[DEBUG] ✅ Loaded ${monHocList.length} môn học');

      // 🟣 Nếu đang sửa -> tự động chọn môn học trùng ID
      if (widget.lop != null && widget.lop!.maMon != null) {
        final existing = monHocList.firstWhere(
              (m) => m['maMon'] == widget.lop!.maMon,
          orElse: () => {},
        );
        if (existing.isNotEmpty) {
          setState(() {
            selectedMaMon = existing['maMon'];
          });
          print('[DEBUG] 🎯 Prefilled selectedMon: ${existing['tenMon']}');
        } else {
          print('[WARN] ⚠️ Không tìm thấy môn học có maMon=${widget.lop!.maMon}');
        }
      }
    } on DioException catch (e) {
      print('[ERROR] ❌ _fetchMonHoc Dio: ${e.response?.statusCode} ${e.response?.data}');
    } catch (e) {
      print('[ERROR] ❌ _fetchMonHoc: $e');
    }
  }


  Future<void> _pickDate(BuildContext context, TextEditingController c) async {
    final now = DateTime.now();
    final initial = (c.text.isNotEmpty)
        ? DateFormat('yyyy-MM-dd').parse(c.text)
        : now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 3),
      lastDate: DateTime(now.year + 3),
      locale: const Locale('vi', 'VN'),
    );
    if (picked != null) {
      c.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.lop == null ? 'Thêm Lớp học phần' : 'Sửa Lớp học phần'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // ====== CHỌN MÔN HỌC ======
            DropdownButtonFormField<int>(
              value: selectedMaMon,
              items: monHocList
                  .map((e) => DropdownMenuItem<int>(
                value: e['maMon'] as int?,
                child: Text('${e['maSoMon']} - ${e['tenMon']}'),
              ))
                  .toList(),
              onChanged: (val) => setState(() => selectedMaMon = val),
              decoration: const InputDecoration(
                labelText: 'Môn học',
                border: OutlineInputBorder(),
              ),
              validator: (val) => val == null ? 'Chọn môn học' : null,
            ),
            const SizedBox(height: 8),

            _textField('Mã lớp HP', 'maSoLopHP'),
            _textField('Học kỳ', 'hocKy'),
            _textField('Năm học', 'namHoc'),
            _dateField('Ngày bắt đầu', _startController),
            _dateField('Ngày kết thúc', _endController),
          ]),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Huỷ'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              final body = <String, dynamic>{
                'maMon': selectedMaMon,
                'maSoLopHP': formData['maSoLopHP'] ?? '',
                'hocKy': formData['hocKy'] ?? '',
                'namHoc': formData['namHoc'] ?? '',
                'ngayBatDau': _startController.text.trim().isEmpty
                    ? null
                    : _startController.text.trim(),
                'ngayKetThuc': _endController.text.trim().isEmpty
                    ? null
                    : _endController.text.trim(),
              };

              print('[DEBUG] 📨 SUBMIT LHP BODY: $body');
              widget.onSubmit(body);
              Navigator.pop(context);
            }
          },
          child: const Text('Lưu'),
        ),
      ],
    );
  }

  Widget _textField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        initialValue: formData[key] ?? '',
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onSaved: (v) => formData[key] = (v ?? '').trim(),
        validator: (v) => (v == null || v.isEmpty) ? 'Không được để trống' : null,
      ),
    );
  }

  Widget _dateField(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: c,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
        ),
        onTap: () => _pickDate(context, c),
      ),
    );
  }
}
