import 'package:flutter/material.dart';
import '../../data/models/mon_hoc_model.dart';

class MonHocTable extends StatelessWidget {
  final List<MonHocModel> monHocs;
  final Function(MonHocModel) onEdit;
  final Function(MonHocModel) onDelete;

  const MonHocTable({
    super.key,
    required this.monHocs,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowColor: WidgetStateProperty.all(Colors.deepPurple.shade50),
      columns: const [
        DataColumn(label: Text('Mã môn')),
        DataColumn(label: Text('Tên môn học')),
        DataColumn(label: Text('Số tín chỉ')),
        DataColumn(label: Text('Mô tả')),
        DataColumn(label: Text('Hành động')),
      ],
      rows: monHocs
          .map(
            (m) => DataRow(cells: [
          DataCell(Text(m.maSoMon)),
          DataCell(Text(m.tenMon)),
          DataCell(Text(m.soTinChi.toString())),
          DataCell(Text(m.moTa ?? '—')),
          DataCell(Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(m),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(m),
              ),
            ],
          )),
        ]),
      )
          .toList(),
    );
  }
}
