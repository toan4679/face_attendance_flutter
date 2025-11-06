import 'package:flutter/material.dart';

class SinhVienTable extends StatelessWidget {
  final List<dynamic> sinhVienList;
  final void Function(BuildContext context, int maSV) onUpdatePhoto;

  const SinhVienTable({
    super.key,
    required this.sinhVienList,
    required this.onUpdatePhoto,
  });

  @override
  Widget build(BuildContext context) {
    if (sinhVienList.isEmpty) {
      return Center(
        child: Text(
          'Chưa có sinh viên trong lớp này.\nBạn có thể bấm "Import Excel" để thêm nhanh.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[700], fontSize: 16),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.deepPurple.shade50),
        columns: const [
          DataColumn(label: Text('Mã SV')),
          DataColumn(label: Text('Họ tên')),
          DataColumn(label: Text('Lớp')),
          DataColumn(label: Text('Khoa')),
          DataColumn(label: Text('Ảnh')),
          DataColumn(label: Text('Thao tác')),
        ],
        rows: sinhVienList.map((sv) {
          final maSV = sv['maSV'] ?? sv['id'] ?? 0;
          final maSo = sv['maSo'] ?? sv['maSoSV'] ?? '';
          final hoTen = sv['hoTen'] ?? '';
          final tenLop = sv['tenLop'] ?? sv['lop'] ?? '';
          final tenKhoa = sv['tenKhoa'] ?? sv['khoa'] ?? '';
          final anh = sv['duongDanAnh'] ?? sv['anh'] ?? null;

          return DataRow(cells: [
            DataCell(Text(maSo.toString())),
            DataCell(Text(hoTen)),
            DataCell(Text(tenLop)),
            DataCell(Text(tenKhoa)),
            DataCell(
              SizedBox(
                width: 56,
                height: 56,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: anh != null && anh.toString().isNotEmpty
                      ? Image.network(anh, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
                    return const Icon(Icons.broken_image_outlined, size: 36);
                  })
                      : Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.person_outline, size: 36),
                  ),
                ),
              ),
            ),
            DataCell(
              ElevatedButton.icon(
                onPressed: () => onUpdatePhoto(context, int.tryParse(maSV.toString()) ?? 0),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Cập nhật ảnh'),
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }
}
