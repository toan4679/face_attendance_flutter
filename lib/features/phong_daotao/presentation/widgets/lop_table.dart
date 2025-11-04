import 'package:flutter/material.dart';
import '../../data/models/lop_model.dart';

class LopTable extends StatelessWidget {
  final List<LopModel> lops;
  final Function(LopModel) onEdit;
  final Function(LopModel) onDelete;

  const LopTable({
    super.key,
    required this.lops,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Mã lớp')),
        DataColumn(label: Text('Tên lớp')),
        DataColumn(label: Text('Mã ngành')),
        DataColumn(label: Text('Sĩ số')),
        DataColumn(label: Text('Thao tác')),
      ],
      rows: lops.map((lop) {
        return DataRow(cells: [
          DataCell(Text(lop.maLop)),
          DataCell(Text(lop.tenLop)),
          DataCell(Text(lop.maNganh)),
          DataCell(Text('${lop.siSo}')),
          DataCell(Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () => onEdit(lop),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(lop),
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }
}
