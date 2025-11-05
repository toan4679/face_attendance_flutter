import 'package:flutter/material.dart';
import '../../data/models/lichday_model.dart';

class AssignScheduleTable extends StatelessWidget {
  final List<LichDayModel> lichList;
  final Function(LichDayModel) onEdit;
  final Function(LichDayModel) onDelete;

  const AssignScheduleTable({
    super.key,
    required this.lichList,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      headingRowColor: WidgetStateProperty.all(Colors.deepPurple.shade50),
      columns: const [
        DataColumn(label: Text('Thứ')),
        DataColumn(label: Text('Tiết bắt đầu')),
        DataColumn(label: Text('Tiết kết thúc')),
        DataColumn(label: Text('Phòng học')),
        DataColumn(label: Text('Môn học')),
        DataColumn(label: Text('Hành động')),
      ],
      rows: lichList.map((lich) {
        return DataRow(cells: [
          DataCell(Text(lich.thu)),
          DataCell(Text(lich.tietBatDau)),
          DataCell(Text(lich.tietKetThuc)),
          DataCell(Text(lich.phongHoc)),
          DataCell(Text(lich.tenMon ?? '—')),
          DataCell(Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: () => onEdit(lich),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => onDelete(lich),
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }
}
