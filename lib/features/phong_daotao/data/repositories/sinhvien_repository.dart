import 'dart:typed_data';
import '../datasources/sinhvien_api.dart';

class SinhVienRepository {
  final SinhVienApi api;
  SinhVienRepository({required this.api});

  Future<List<dynamic>> getKhoaList() => api.getKhoaList();
  Future<List<dynamic>> getNganhByKhoa(String maKhoa) => api.getNganhByKhoa(maKhoa);
  Future<List<dynamic>> getLopByNganh(String maNganh) => api.getLopByNganh(maNganh);
  Future<List<dynamic>> getSinhVienByLop(String maLop) => api.getSinhVienByLop(maLop);

  Future<void> importSinhVienExcel({
    required String maLop,
    required String fileName,
    Uint8List? webBytes,
    String? filePath,
  }) async =>
      api.importSinhVienExcel(maLop: maLop, fileName: fileName, bytes: webBytes, filePath: filePath);

  Future<void> uploadFacePhoto({
    required int maSV,
    required String fileName,
    Uint8List? webBytes,
    String? filePath,
  }) async =>
      api.uploadFacePhoto(maSV: maSV, fileName: fileName, bytes: webBytes, filePath: filePath);
}
