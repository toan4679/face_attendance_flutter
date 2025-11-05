import 'package:flutter/material.dart';
import '../../data/models/lop_model.dart';
import '../../data/models/nganh_model.dart';


class LopFormDialog extends StatefulWidget {
  final LopModel? lop;
  final List<NganhModel> danhSachNganh;
  final Future<void> Function(Map<String, dynamic>) onSubmit;

  const LopFormDialog({
    super.key,
    this.lop,
    required this.danhSachNganh,
    required this.onSubmit,
  });

  @override
  State<LopFormDialog> createState() => _LopFormDialogState();
}

class _LopFormDialogState extends State<LopFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tenLopCtl = TextEditingController();
  final _khoaHocCtl = TextEditingController();
  final _coVanCtl = TextEditingController();
  int? _maNganh;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final lop = widget.lop;
    if (lop != null) {
      _tenLopCtl.text = lop.tenLop;
      _khoaHocCtl.text = lop.khoaHoc;
      _coVanCtl.text = lop.coVan ?? '';
      _maNganh = lop.maNganh;
      debugPrint('✏️ Edit lớp: ${lop.toJson()}');
    } else {
      debugPrint('➕ Add lớp mới (auto-generate maSoLop ở frontend)');
    }
  }

  @override
  void dispose() {
    _tenLopCtl.dispose();
    _khoaHocCtl.dispose();
    _coVanCtl.dispose();
    super.dispose();
  }

  /// 🧠 Sinh mã số lớp tự động theo năm + ngành + số
  String _generateMaSoLop() {
    final khoaHoc = _khoaHocCtl.text.trim();
    final tenLop = _tenLopCtl.text.trim().toUpperCase();
    final nganh = widget.danhSachNganh.firstWhere(
          (n) => n.maNganh == _maNganh,
      orElse: () => NganhModel(
        maNganh: 0,
        maSo: '',
        tenNganh: '',
        maKhoa: 0,
      ),
    );
    // Năm bắt đầu (VD: 2021–2025 => 21)
    final yearPrefix = khoaHoc.length >= 4 ? khoaHoc.substring(2, 4) : "XX";

    // Lấy chữ cái đầu của từng từ trong tên ngành, bỏ dấu cách
    final words = nganh.tenNganh.split(RegExp(r'\s+'));
    final abbr = words.map((w) => w.isNotEmpty ? w[0].toUpperCase() : '').join();

    // Tìm số cuối trong tên lớp (nếu có)
    final numberMatch = RegExp(r'\d+$').firstMatch(tenLop);
    final suffix = numberMatch != null ? numberMatch.group(0) : "1";

    final maSo = "D$yearPrefix$abbr$suffix";
    debugPrint('🎯 [AutoGenerate] maSoLop = $maSo');
    return maSo;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    String maSoLop = widget.lop?.maSoLop ?? _generateMaSoLop();

    final payload = {
      'maSoLop': maSoLop,
      'tenLop': _tenLopCtl.text.trim(),
      'khoaHoc': _khoaHocCtl.text.trim(),
      'maNganh': _maNganh,
      'coVan': _coVanCtl.text.trim().isEmpty ? null : _coVanCtl.text.trim(),
    };

    debugPrint('📤 [LopFormDialog] Payload gửi lên: $payload');

    setState(() => _submitting = true);
    try {
      await widget.onSubmit(payload);
      if (mounted) Navigator.pop(context, true);
    } catch (e, st) {
      debugPrint('❌ [LopFormDialog] Lưu lỗi: $e');
      debugPrintStack(stackTrace: st);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('❌ Lưu thất bại: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.lop == null ? 'Thêm lớp học' : 'Sửa lớp học'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _tenLopCtl,
                  decoration: const InputDecoration(labelText: 'Tên lớp học'),
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Vui lòng nhập tên lớp' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _khoaHocCtl,
                  decoration:
                  const InputDecoration(labelText: 'Khóa học (VD: 2021–2025)'),
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Vui lòng nhập khóa học' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: _maNganh,
                  decoration: const InputDecoration(labelText: 'Ngành'),
                  items: widget.danhSachNganh.map((n) {
                    return DropdownMenuItem<int>(
                      value: n.maNganh,
                      child: Text(n.tenNganh),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _maNganh = val),
                  validator: (val) => val == null ? 'Vui lòng chọn ngành' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _coVanCtl,
                  decoration: const InputDecoration(labelText: 'Cố vấn học tập (tuỳ chọn)'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.pop(context, false),
          child: const Text('Hủy'),
        ),
        ElevatedButton.icon(
          onPressed: _submitting ? null : _handleSubmit,
          icon: _submitting
              ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Icon(Icons.save),
          label: Text(_submitting ? 'Đang lưu...' : 'Lưu'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
          ),
        ),
      ],
    );
  }
}
