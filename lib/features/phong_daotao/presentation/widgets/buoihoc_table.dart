import 'package:flutter/material.dart';
import '../../data/models/buoi_hoc_model.dart';

class BuoiHocTable extends StatelessWidget {
  final List<BuoiHocModel> items;
  final void Function(BuoiHocModel) onEdit;
  final void Function(BuoiHocModel) onDelete;

  const BuoiHocTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('Chưa có buổi học nào.'));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.deepPurple.shade50),
        columns: const [
          DataColumn(label: Text('Thứ')),
          DataColumn(label: Text('Tiết bắt đầu')),
          DataColumn(label: Text('Tiết kết thúc')),
          DataColumn(label: Text('Phòng')),
          DataColumn(label: Text('Hành động')),
        ],
        rows: items.map((b) => DataRow(cells: [
          DataCell(Text(b.thu)),
          DataCell(Text(b.tietBatDau.toString())),
          DataCell(Text(b.tietKetThuc.toString())),
          DataCell(Text(b.phongHoc)),
          DataCell(Row(children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.blueAccent), onPressed: () => onEdit(b)),
            IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => onDelete(b)),
          ])),
        ])).toList(),
      ),
    );
  }
}
