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
              padding: const EdgeInsets.all(12),
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
                            return DropdownMenuItem(
                              value: k['maKhoa'].toString(),
                              child: Text(k['tenKhoa']),
                            );
                          }).toList(),
                          onChanged: (v) => v != null ? c.onSelectKhoa(v) : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: c.selectedNganh,
                          decoration: const InputDecoration(labelText: 'Chọn Ngành'),
                          items: c.nganhList.map<DropdownMenuItem<String>>((n) {
                            return DropdownMenuItem(
                              value: n['maNganh'].toString(),
                              child: Text(n['tenNganh']),
                            );
                          }).toList(),
                          onChanged: (v) => v != null ? c.onSelectNganh(v) : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: c.selectedLop,
                          decoration: const InputDecoration(labelText: 'Chọn Lớp'),
                          items: c.lopList.map<DropdownMenuItem<String>>((l) {
                            return DropdownMenuItem(
                              value: l['maLop'].toString(),
                              child: Text('${l['tenLop']} (${l['maSoLop']})'),
                            );
                          }).toList(),
                          onChanged: (v) => v != null ? c.onSelectLop(v) : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                        ),
                        icon: const Icon(Icons.upload_file, color: Colors.white),
                        label: const Text('Import Excel',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () => c.importExcel(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 🧮 Bảng sinh viên
                  Expanded(
                    child: c.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : c.sinhVienList.isEmpty
                        ? const Center(
                      child: Text('Không có dữ liệu sinh viên'),
                    )
                        : Container(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          headingRowColor:
                          WidgetStateProperty.all(Colors.deepPurple.shade50),
                          dataRowHeight: 64,
                          columns: const [
                            DataColumn(label: Text('Mã SV')),
                            DataColumn(label: Text('Họ tên')),
                            DataColumn(label: Text('Ảnh')),
                            DataColumn(label: Text('Thao tác')),
                          ],
                          rows: c.sinhVienList.map((sv) {
                            final photoUrl = sv['duongDanAnh'] ?? '';
                            debugPrint("🖼 Hiển thị ảnh: $photoUrl");

                            final hasPhoto =
                                photoUrl.isNotEmpty && photoUrl != 'null';

                            return DataRow(cells: [
                              DataCell(Text(sv['maSo'] ?? '—')),
                              DataCell(Text(sv['hoTen'] ?? '—')),
                              DataCell(
                                hasPhoto
                                    ? ClipOval(
                                  child: Image.network(
                                    photoUrl,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.error,
                                        size: 40, color: Colors.redAccent),
                                  ),
                                )
                                    : const Icon(Icons.account_circle,
                                    size: 40, color: Colors.grey),
                              ),
                              DataCell(
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      c.updatePhoto(context, sv['maSV']),
                                  icon: const Icon(Icons.camera_alt,
                                      size: 18, color: Colors.white),
                                  label: const Text('Cập nhật',
                                      style: TextStyle(color: Colors.white)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurpleAccent,
                                  ),
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
