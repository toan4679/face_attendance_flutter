import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/models/sinhvien_model.dart';

class LopSinhVienDialog extends StatelessWidget {
  final String tenLop;
  final List<SinhVienModel> sinhVienList;
  final Future<void> Function(dynamic) onImport;

  const LopSinhVienDialog({
    super.key,
    required this.tenLop,
    required this.sinhVienList,
    required this.onImport,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFF8F6FC),
      title: Text(
        'Danh sách sinh viên – $tenLop',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 450, minWidth: 700),
        child: sinhVienList.isEmpty
            ? const Center(child: Text('Chưa có sinh viên nào trong lớp này.'))
            : Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 800),
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                      Colors.deepPurple.shade50),
                  columnSpacing: 50,
                  border: TableBorder.all(
                      color: Colors.grey.shade300, width: 1),
                  columns: const [
                    DataColumn(
                        label: Text('Mã số',
                            style:
                            TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Họ và tên',
                            style:
                            TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Email',
                            style:
                            TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: sinhVienList.map((sv) {
                    return DataRow(cells: [
                      DataCell(Text(sv.maSo ?? '-')),
                      DataCell(Text(sv.hoTen ?? '-')),
                      DataCell(Text(sv.email ?? '-')),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['xlsx', 'xls'],
              withData: true,
            );

            if (result != null && result.files.isNotEmpty) {
              final file = result.files.first;
              debugPrint("📁 File chọn: ${file.name}");
              if (kIsWeb) {
                debugPrint("🌐 Upload file bằng bytes (${file.bytes?.length})");
                await onImport(file.bytes);
              } else {
                debugPrint("📂 Upload file từ path: ${file.path}");
                await onImport(file.path);
              }
            }
          },
          icon: const Icon(Icons.file_upload),
          label: const Text('Import danh sách từ Excel'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            padding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
      ],
    );
  }
}
