import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/khuonmat_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ManageKhuonMatScreen extends StatelessWidget {
  const ManageKhuonMatScreen({super.key});

  Future<void> _openImageUrl(BuildContext context, String url) async {
    if (url.isEmpty || url == 'null') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sinh viên này chưa có ảnh để xem.')),
      );
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể mở ảnh tại: $url')),
      );
    }
  }

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
                            DataColumn(label: Text('Trạng thái ảnh')),
                            DataColumn(label: Text('Thao tác')),
                          ],
                          rows: c.sinhVienList.map((sv) {
                            final photoUrl = sv['duongDanAnh'] ?? '';
                            final hasPhoto =
                                photoUrl.isNotEmpty && photoUrl != 'null';

                            final statusText =
                            hasPhoto ? "✅ Đã cập nhật" : "⚪ Chưa cập nhật";
                            final statusColor =
                            hasPhoto ? Colors.green : Colors.orange;

                            return DataRow(cells: [
                              DataCell(Text(sv['maSo'] ?? '—')),
                              DataCell(Text(sv['hoTen'] ?? '—')),
                              DataCell(
                                Row(
                                  children: [
                                    Icon(
                                      hasPhoto
                                          ? Icons.check_circle
                                          : Icons.info_outline,
                                      color: statusColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(statusText,
                                        style: TextStyle(color: statusColor)),
                                  ],
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                          c.updatePhoto(context, sv['maSV']),
                                      icon: const Icon(Icons.camera_alt,
                                          size: 18, color: Colors.white),
                                      label: const Text('Cập nhật',
                                          style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        Colors.deepPurpleAccent,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 8),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton.icon(
                                      onPressed: () => _openImageUrl(
                                          context, photoUrl.toString()),
                                      icon: const Icon(Icons.visibility,
                                          size: 18, color: Colors.deepPurple),
                                      label: const Text('Xem ảnh',
                                          style: TextStyle(
                                              color: Colors.deepPurple)),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Colors.deepPurpleAccent),
                                      ),
                                    ),
                                  ],
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
