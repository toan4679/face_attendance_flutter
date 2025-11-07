import 'package:flutter/material.dart';
import '../../data/models/buoi_hoc_model.dart';

class BuoiHocTable extends StatelessWidget {
  final List<BuoiHocModel> items;
  final Function(BuoiHocModel) onEdit;
  final Function(BuoiHocModel) onDelete;

  const BuoiHocTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final b = items[i];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.deepPurple),
            title: Text(
              'Thứ ${b.thu ?? '—'}: Tiết ${b.tietBatDau}–${b.tietKetThuc}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Phòng: ${b.phongHoc ?? '—'} • Giờ: ${b.gioBatDau ?? '—'}–${b.gioKetThuc ?? '—'}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () => onEdit(b)),
                IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => onDelete(b)),
              ],
            ),
          ),
        );
      },
    );
  }
}
