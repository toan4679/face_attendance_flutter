import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/khuonmat_controller.dart';

class ManageKhuonMatScreen extends StatelessWidget {
  const ManageKhuonMatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => KhuonMatController(),
      child: Consumer<KhuonMatController>(
        builder: (context, c, _) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FC),
            appBar: AppBar(
              backgroundColor: Colors.deepPurpleAccent,
              title: const Text('Quản lý ảnh sinh viên'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 🔽 Dropdown chọn Khoa / Ngành / Lớp
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: c.selectedKhoa,
                          decoration: const InputDecoration(labelText: 'Chọn Khoa'),
                          items: c.khoaList.map<DropdownMenuItem<String>>((k) {
                            return DropdownMenuItem<String>(
                              value: k['maKhoa'].toString(),
                              child: Text(k['tenKhoa']),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) c.onSelectKhoa(v);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: c.selectedNganh,
                          decoration: const InputDecoration(labelText: 'Chọn Ngành'),
                          items: c.nganhList.map<DropdownMenuItem<String>>((n) {
                            return DropdownMenuItem<String>(
                              value: n['maNganh'].toString(),
                              child: Text(n['tenNganh']),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) c.onSelectNganh(v);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: c.selectedLop,
                          decoration: const InputDecoration(labelText: 'Chọn Lớp'),
                          items: c.lopList.map<DropdownMenuItem<String>>((l) {
                            return DropdownMenuItem<String>(
                              value: l['maLop'].toString(),
                              child: Text('${l['tenLop']} (${l['maSoLop']})'),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v != null) c.onSelectLop(v);
                          },
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        ),
                        icon: const Icon(Icons.upload_file, color: Colors.white),
                        label: const Text('Import Excel', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          c.importExcel(context);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🧮 Danh sách sinh viên
                  Expanded(
                    child: c.loading
                        ? const Center(child: CircularProgressIndicator())
                        : c.sinhVienList.isEmpty
                        ? Center(
                      child: Text(
                        c.selectedLop == null
                            ? 'Vui lòng chọn lớp để xem danh sách sinh viên'
                            : 'Chưa có sinh viên trong lớp này.\nHãy import danh sách Excel.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                        : Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3))
                        ],
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(Colors.deepPurple.shade50),
                          columnSpacing: 20,
                          columns: const [
                            DataColumn(label: Text('Mã SV')),
                            DataColumn(label: Text('Họ tên')),
                            DataColumn(label: Text('Lớp')),
                            DataColumn(label: Text('Khoa')),
                            DataColumn(label: Text('Ảnh')),
                            DataColumn(label: Text('Thao tác')),
                          ],
                          rows: c.sinhVienList.map((sv) {
                            return DataRow(cells: [
                              DataCell(Text(sv['maSo'] ?? '')),
                              DataCell(Text(sv['hoTen'] ?? '')),
                              DataCell(Text(sv['tenLop'] ?? '')),
                              DataCell(Text(sv['tenKhoa'] ?? '')),
                              DataCell(
                                sv['anh'] != null && sv['anh'] != ''
                                    ? CircleAvatar(
                                  backgroundImage: NetworkImage(sv['anh']),
                                  radius: 20,
                                )
                                    : const Icon(Icons.person_outline, color: Colors.grey),
                              ),
                              DataCell(
                                ElevatedButton.icon(
                                  onPressed: () => c.updatePhoto(context, sv['maSV']),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  ),
                                  icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                                  label: const Text('Cập nhật', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
