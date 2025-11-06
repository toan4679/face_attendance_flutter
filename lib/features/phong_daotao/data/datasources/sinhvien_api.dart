import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../../../core/network/token_storage.dart';
import 'package:flutter/foundation.dart'; // cần cho kIsWeb

class SinhVienApi {
  // 🌐 Địa chỉ backend VPS
  final String baseUrl = 'http://104.145.210.69/api/v1/pdt';

  // 🧩 Header kèm token
  Future<Map<String, String>> _headers() async {
    final token = await TokenStorage.getToken();
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // ======================== DANH MỤC ========================

  Future<List<dynamic>> getKhoaList() async {
    final res = await http.get(Uri.parse('$baseUrl/khoa'), headers: await _headers());
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      return decoded is List ? decoded : decoded['data'] ?? [];
    }
    throw Exception('Lỗi tải danh sách Khoa: ${res.body}');
  }

  Future<List<dynamic>> getNganhByKhoa(String maKhoa) async {
    final res = await http.get(Uri.parse('$baseUrl/nganh?maKhoa=$maKhoa'), headers: await _headers());
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      return decoded is List ? decoded : decoded['data'] ?? [];
    }
    throw Exception('Lỗi tải danh sách Ngành: ${res.body}');
  }

  Future<List<dynamic>> getLopByNganh(String maNganh) async {
    final res = await http.get(Uri.parse('$baseUrl/lop?maNganh=$maNganh'), headers: await _headers());
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      return decoded is List ? decoded : decoded['data'] ?? [];
    }
    throw Exception('Lỗi tải danh sách Lớp: ${res.body}');
  }

  Future<List<dynamic>> getSinhVienByLop(String maLop) async {
    final res = await http.get(Uri.parse('$baseUrl/lop/$maLop/sinhvien'), headers: await _headers());
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      return decoded is List ? decoded : decoded['data'] ?? [];
    }
    throw Exception('Lỗi tải danh sách Sinh viên: ${res.body}');
  }

  // ======================== IMPORT EXCEL ========================

  Future<void> importSinhVienExcel({
    required String maLop,
    required String fileName,
    Uint8List? bytes,
    String? filePath,
  }) async {
    final uri = Uri.parse('$baseUrl/lop/$maLop/import-sinhvien');
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(await _headers());

    try {
      if (kIsWeb) {
        if (bytes == null) throw Exception('⚠️ Không có bytes để upload (web)');
        debugPrint("🌐 Web upload file: $fileName (${bytes.lengthInBytes} bytes)");
        request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: fileName));
      } else {
        if (filePath != null && filePath.isNotEmpty) {
          debugPrint("📱 Mobile upload từ path: $filePath");
          request.files.add(await http.MultipartFile.fromPath('file', filePath, filename: fileName));
        } else if (bytes != null) {
          debugPrint("📱 Mobile upload từ bytes: $fileName");
          request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: fileName));
        } else {
          throw Exception('❌ Không có file hợp lệ để upload.');
        }
      }

      final response = await request.send();
      final body = await response.stream.bytesToString();
      debugPrint("📦 Import Excel response: $body");

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('❌ Import thất bại (${response.statusCode}): $body');
      } else {
        debugPrint('✅ Import Excel thành công!');
      }
    } catch (e) {
      debugPrint('💥 Lỗi import Excel: $e');
      rethrow;
    }
  }

  // ======================== UPLOAD ẢNH SINH VIÊN ========================

  Future<void> uploadFacePhoto({
    required int maSV,
    required String fileName,
    Uint8List? bytes,
    String? filePath,
  }) async {
    final uri = Uri.parse('$baseUrl/khuonmat/upload');
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(await _headers())
      ..fields['maSV'] = maSV.toString();

    try {
      if (kIsWeb) {
        if (bytes == null) throw Exception('⚠️ Không có bytes ảnh để upload (web)');
        debugPrint("🌐 Web upload ảnh: $fileName (${bytes.lengthInBytes} bytes)");
        request.files.add(http.MultipartFile.fromBytes('photo', bytes, filename: fileName));
      } else {
        if (filePath != null && filePath.isNotEmpty) {
          debugPrint("📱 Mobile upload ảnh từ path: $filePath");
          request.files.add(await http.MultipartFile.fromPath('photo', filePath, filename: fileName));
        } else if (bytes != null) {
          debugPrint("📱 Mobile upload ảnh từ bytes: $fileName");
          request.files.add(http.MultipartFile.fromBytes('photo', bytes, filename: fileName));
        } else {
          throw Exception('❌ Không có ảnh hợp lệ để upload');
        }
      }

      final response = await request.send();
      final body = await response.stream.bytesToString();
      debugPrint("📤 Upload Face response: $body");

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('❌ Upload ảnh thất bại (${response.statusCode}): $body');
      } else {
        debugPrint('✅ Upload ảnh khuôn mặt thành công!');
      }
    } catch (e) {
      debugPrint('💥 Lỗi upload ảnh khuôn mặt: $e');
      rethrow;
    }
  }
}
