import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network/token_storage.dart';
import '../../../../core/constants/api_endpoints.dart';

class SinhVienApi {
  final String base = '${ApiEndpoints.baseUrl}/api/v1';

  Future<List<dynamic>> getKhoaList() async {
    final token = await TokenStorage.getToken();
    final res = await http.get(
      Uri.parse('$base/pdt/khoa'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) throw Exception('Không tải được danh sách Khoa');
    final json = jsonDecode(res.body);
    return (json is List) ? json : (json['data'] ?? []);
  }

  Future<List<dynamic>> getNganhByKhoa(String maKhoa) async {
    final token = await TokenStorage.getToken();
    final uri = Uri.parse('$base/pdt/nganh').replace(queryParameters: {
      'maKhoa': maKhoa,
    });
    final res = await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    if (res.statusCode != 200) throw Exception('Không tải được danh sách Ngành');
    final json = jsonDecode(res.body);
    return (json is List) ? json : (json['data'] ?? []);
  }

  Future<List<dynamic>> getLopByNganh(String maNganh) async {
    final token = await TokenStorage.getToken();
    final uri = Uri.parse('$base/pdt/lop').replace(queryParameters: {
      'maNganh': maNganh,
    });
    final res = await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    if (res.statusCode != 200) throw Exception('Không tải được danh sách Lớp');
    final json = jsonDecode(res.body);
    return (json is List) ? json : (json['data'] ?? []);
  }

  Future<List<dynamic>> getSinhVienByLop(String maLop) async {
    final token = await TokenStorage.getToken();
    final res = await http.get(
      Uri.parse('$base/pdt/lop/$maLop/sinhvien'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) throw Exception('Không tải được danh sách sinh viên');
    final json = jsonDecode(res.body);
    return (json is List) ? json : (json['data'] ?? []);
  }

  Future<void> importSinhVienExcel({
    required String maLop,
    required String fileName,
    Uint8List? bytes,        // kIsWeb
    String? filePath,        // mobile/desktop
  }) async {
    final token = await TokenStorage.getToken();
    final req = http.MultipartRequest(
      'POST',
      Uri.parse('$base/pdt/lop/$maLop/import-sinhvien'),
    );
    req.headers['Authorization'] = 'Bearer $token';

    if (kIsWeb) {
      if (bytes == null) throw Exception('Không có dữ liệu tệp để upload');
      req.files.add(http.MultipartFile.fromBytes('file', bytes, filename: fileName));
    } else {
      if (filePath == null) throw Exception('Thiếu đường dẫn file để upload');
      req.files.add(await http.MultipartFile.fromPath('file', filePath));
    }

    final res = await req.send();
    if (res.statusCode != 200) {
      final body = await res.stream.bytesToString();
      throw Exception('Import thất bại: $body');
    }
  }

  Future<void> uploadFacePhoto({
    required int maSV,
    required String fileName,
    Uint8List? bytes,        // kIsWeb
    String? filePath,        // mobile/desktop
  }) async {
    final token = await TokenStorage.getToken();
    final req = http.MultipartRequest(
      'POST',
      Uri.parse('$base/pdt/khuonmat/$maSV'),
    );
    req.headers['Authorization'] = 'Bearer $token';

    if (kIsWeb) {
      if (bytes == null) throw Exception('Không có dữ liệu ảnh để upload');
      req.files.add(http.MultipartFile.fromBytes('photo', bytes, filename: fileName));
    } else {
      if (filePath == null) throw Exception('Thiếu đường dẫn ảnh để upload');
      req.files.add(await http.MultipartFile.fromPath('photo', filePath));
    }

    final res = await req.send();
    if (res.statusCode != 200) {
      final body = await res.stream.bytesToString();
      throw Exception('Cập nhật ảnh thất bại: $body');
    }
  }
}
