import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/repositories/sinhvien_repository.dart';
import '../../data/datasources/sinhvien_api.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:typed_data';

class KhuonMatController extends ChangeNotifier {
  final repo = SinhVienRepository(api: SinhVienApi());
  bool isLoading = false;

  // Danh sách dropdown
  List<Map<String, dynamic>> khoaList = [];
  List<Map<String, dynamic>> nganhList = [];
  List<Map<String, dynamic>> lopList = [];

  // Lựa chọn hiện tại
  String? selectedKhoa;
  String? selectedNganh;
  String? selectedLop;

  // Danh sách sinh viên
  List<Map<String, dynamic>> sinhVienList = [];

  KhuonMatController() {
    loadKhoa();
  }

  // 🔹 Load danh sách khoa
  Future<void> loadKhoa() async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await repo.getKhoaList();
      khoaList = data.map<Map<String, dynamic>>((e) => {
        'maKhoa': e['maKhoa'].toString(),
        'tenKhoa': e['tenKhoa'] ?? '',
      }).toList();
      debugPrint("✅ Đã load ${khoaList.length} khoa.");
    } catch (e) {
      debugPrint('❌ Lỗi load khoa: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  // 🔹 Chọn Khoa
  Future<void> onSelectKhoa(String maKhoa) async {
    selectedKhoa = maKhoa;
    selectedNganh = null;
    selectedLop = null;
    nganhList = [];
    lopList = [];
    sinhVienList = [];
    notifyListeners();

    try {
      final data = await repo.getNganhByKhoa(maKhoa);
      nganhList = data.map<Map<String, dynamic>>((e) => {
        'maNganh': e['maNganh'].toString(),
        'tenNganh': e['tenNganh'] ?? '',
      }).toList();
      debugPrint("📘 Đã load ${nganhList.length} ngành cho Khoa $maKhoa");
    } catch (e) {
      debugPrint('❌ Lỗi load ngành: $e');
    }
    notifyListeners();
  }

  // 🔹 Chọn Ngành
  Future<void> onSelectNganh(String maNganh) async {
    selectedNganh = maNganh;
    selectedLop = null;
    lopList = [];
    sinhVienList = [];
    notifyListeners();

    try {
      final data = await repo.getLopByNganh(maNganh);
      lopList = data.map<Map<String, dynamic>>((e) => {
        'maLop': e['maLop'].toString(),
        'tenLop': e['tenLop'] ?? '',
        'maSoLop': e['maSoLop'] ?? '',
      }).toList();
      debugPrint("🏫 Đã load ${lopList.length} lớp cho Ngành $maNganh");
    } catch (e) {
      debugPrint('❌ Lỗi load lớp: $e');
    }
    notifyListeners();
  }

  // 🔹 Chọn Lớp → Lấy danh sách sinh viên
  Future<void> onSelectLop(String maLop) async {
    selectedLop = maLop;
    sinhVienList = [];
    notifyListeners();

    debugPrint("🔄 Đang tải sinh viên của lớp $maLop ...");

    try {
      final data = await repo.getSinhVienByLop(maLop);
      sinhVienList = data.map<Map<String, dynamic>>((e) => {
        'maSV': e['maSV'] ?? e['id'] ?? '',
        'maSo': e['maSo'] ?? e['maSoSV'] ?? '',
        'hoTen': e['hoTen'] ?? '',
        'email': e['email'] ?? '',
        'maLop': e['maLop'] ?? '',
        'duongDanAnh': e['duongDanAnh'] ?? '',
      }).toList();

      debugPrint("📸 Sinh viên data (${sinhVienList.length}):");
      for (var sv in sinhVienList) {
        debugPrint("➡ ${sv['maSo']} | ${sv['hoTen']} | ${sv['duongDanAnh']}");
      }
    } catch (e) {
      debugPrint('❌ Lỗi load sinh viên: $e');
    }
    notifyListeners();
  }

  // 📤 Import Excel danh sách sinh viên
  Future<void> importExcel(BuildContext context) async {
    if (selectedLop == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn lớp trước khi import')),
      );
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result == null) return;
    final file = result.files.first;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đang import danh sách...')),
    );

    try {
      await repo.importSinhVienExcel(
        maLop: selectedLop!,
        fileName: file.name,
        webBytes: file.bytes,
        filePath: file.path,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Import thành công!')),
      );
      await onSelectLop(selectedLop!);
    } catch (e) {
      debugPrint('❌ Lỗi khi import Excel: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi import: $e')),
      );
    }
  }

  // 📸 Cập nhật ảnh khuôn mặt
  Future<void> updatePhoto(BuildContext context, dynamic maSV) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;

    final file = result.files.first;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đang cập nhật ảnh...')),
    );

    try {
      debugPrint("📤 Upload ảnh cho sinh viên $maSV ...");
      await repo.uploadFacePhoto(
        maSV: int.parse(maSV.toString()),
        fileName: file.name,
        webBytes: file.bytes,
        filePath: file.path,
      );

      debugPrint("✅ Upload ảnh thành công, reload lại danh sách...");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật ảnh thành công!')),
      );

      await onSelectLop(selectedLop!);
    } catch (e) {
      debugPrint("❌ Lỗi upload ảnh: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi upload ảnh: $e')),
      );
    }
  }
}
