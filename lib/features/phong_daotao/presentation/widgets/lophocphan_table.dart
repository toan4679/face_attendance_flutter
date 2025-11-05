import 'package:flutter/material.dart';
import '../../data/models/lop_hoc_phan_model.dart';

class LopHocPhanTable extends StatelessWidget {
  final List<LopHocPhanModel> lopList;
  final Function(LopHocPhanModel) onEdit;
  final Function(LopHocPhanModel) onDelete;

  const LopHocPhanTable({
    super.key,
    required this.lopList,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (lopList.isEmpty) {
      return const Center(
        child: Text(
          'Chưa có lớp học phần nào.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Mã lớp HP')),
          DataColumn(label: Text('Môn học')),
          DataColumn(label: Text('Ngày bắt đầu')),
          DataColumn(label: Text('Ngày kết thúc')),
          DataColumn(label: Text('Học kỳ')),
          DataColumn(label: Text('Năm học')),
          DataColumn(label: Text('Thao tác')),
        ],
        rows: lopList.map((lop) {
          return DataRow(cells: [
            DataCell(Text(lop.maSoLopHP)),
            DataCell(Text(lop.tenMon ?? '—')),
            DataCell(Text(lop.ngayBatDau ?? '—')),
            DataCell(Text(lop.ngayKetThuc ?? '—')),
            DataCell(Text(lop.hocKy)),
            DataCell(Text(lop.namHoc)),

            // ❌ XÓA DÒNG DƯỚI NẾU CÓ:
            // DataCell(Text(lop.thongTinLichHoc ?? '—')),

            // ✅ Cột Thao tác
            DataCell(Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () => onEdit(lop),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => onDelete(lop),
                ),
              ],
            )),
          ]);
        }).toList(),
      )

    );
  }
}
