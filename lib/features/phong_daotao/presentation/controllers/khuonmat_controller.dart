import 'package:flutter/material.dart';
import '../../data/repositories/sinhvien_repository.dart';
import '../../data/datasources/sinhvien_api.dart';
import 'package:file_picker/file_picker.dart';

class KhuonMatController extends ChangeNotifier {
  final repo = SinhVienRepository(api: SinhVienApi());

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

  bool loading = false;

  KhuonMatController() {
    loadKhoa(); // tải dữ liệu khoa khi mở màn hình
  }

  Future<void> loadKhoa() async {
    loading = true;
    notifyListeners();
    try {
      final data = await repo.getKhoaList();
      khoaList = data.map<Map<String, dynamic>>((e) => {
        'maKhoa': e['maKhoa'].toString(),
        'tenKhoa': e['tenKhoa'] ?? '',
      }).toList();
    } catch (e) {
      debugPrint('❌ Lỗi load khoa: $e');
    }
    loading = false;
    notifyListeners();
  }

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
    } catch (e) {
      debugPrint('❌ Lỗi load ngành: $e');
    }
    notifyListeners();
  }

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
    } catch (e) {
      debugPrint('❌ Lỗi load lớp: $e');
    }
    notifyListeners();
  }

  Future<void> onSelectLop(String maLop) async {
    selectedLop = maLop;
    sinhVienList = [];
    notifyListeners();

    try {
      final data = await repo.getSinhVienByLop(maLop);
      sinhVienList = data.map<Map<String, dynamic>>((e) => {
        'maSV': e['maSV'] ?? e['id'] ?? '',
        'maSo': e['maSo'] ?? e['maSoSV'] ?? '',
        'hoTen': e['hoTen'] ?? '',
        'tenLop': e['tenLop'] ?? '',
        'tenKhoa': e['tenKhoa'] ?? '',
        'anh': e['duongDanAnh'] ?? '',
      }).toList();
    } catch (e) {
      debugPrint('❌ Lỗi load sinh viên: $e');
    }
    notifyListeners();
  }

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi import: $e')),
      );
    }
  }

  Future<void> updatePhoto(BuildContext context, dynamic maSV) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result == null) return;
    final file = result.files.first;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đang cập nhật ảnh...')),
    );

    try {
      await repo.uploadFacePhoto(
        maSV: int.parse(maSV.toString()),
        fileName: file.name,
        webBytes: file.bytes,
        filePath: file.path,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật ảnh thành công!')),
      );
      await onSelectLop(selectedLop!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi upload ảnh: $e')),
      );
    }
  }
}
