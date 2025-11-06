import 'package:flutter/material.dart';
import '../../data/models/lop_hoc_phan_model.dart';

class LopHocPhanTable extends StatelessWidget {
  final List<LopHocPhanModel> lopList;
  final Function(LopHocPhanModel) onEdit;
  final Function(LopHocPhanModel) onDelete;
  final Function(LopHocPhanModel)? onView;
  final Function(LopHocPhanModel)? onGanLop;

  const LopHocPhanTable({
    super.key,
    required this.lopList,
    required this.onEdit,
    required this.onDelete,
    this.onView,
    this.onGanLop,
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

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: DataTable(
                    columnSpacing: 40,
                    dataRowMaxHeight: 56, // ✅ thay cho dataRowMinHeight
                    headingRowColor: MaterialStateProperty.all(
                      Colors.deepPurple.withOpacity(0.1),
                    ),
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
                      return DataRow(
                        cells: [
                          DataCell(Text(lop.maSoLopHP)),
                          DataCell(Text(lop.tenMon ?? '—')),
                          DataCell(Text(lop.ngayBatDau ?? '—')),
                          DataCell(Text(lop.ngayKetThuc ?? '—')),
                          DataCell(Text(lop.hocKy)),
                          DataCell(Text(lop.namHoc)),
                          DataCell(Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                tooltip: 'Xem sinh viên',
                                icon: const Icon(Icons.visibility,
                                    color: Colors.deepPurple),
                                onPressed: () => onView?.call(lop),
                              ),
                              IconButton(
                                tooltip: 'Gán lớp hành chính',
                                icon: const Icon(Icons.link, color: Colors.teal),
                                onPressed: () => onGanLop?.call(lop),
                              ),
                              IconButton(
                                tooltip: 'Chỉnh sửa',
                                icon: const Icon(Icons.edit,
                                    color: Colors.blueAccent),
                                onPressed: () => onEdit(lop),
                              ),
                              IconButton(
                                tooltip: 'Xóa',
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () => onDelete(lop),
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
