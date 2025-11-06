import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../../../core/network/token_storage.dart';
import 'package:flutter/foundation.dart'; // cần cho kIsWeb


class SinhVienApi {
  // 🌐 Địa chỉ backend VPS của bạn
  final String baseUrl = 'http://104.145.210.69/api/v1/pdt';

  // 🧩 Tạo header có token
  Future<Map<String, String>> _headers() async {
    final token = await TokenStorage.getToken();
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // 🏫 Lấy danh sách khoa
  Future<List<dynamic>> getKhoaList() async {
    final res = await http.get(Uri.parse('$baseUrl/khoa'), headers: await _headers());
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      if (decoded is List) return decoded;
      if (decoded is Map && decoded.containsKey('data')) return decoded['data'];
      throw Exception('Phản hồi không hợp lệ: $decoded');
    } else {
      throw Exception('Lỗi tải danh sách Khoa: ${res.body}');
    }
  }

  // 📚 Lấy danh sách ngành theo mã Khoa
  Future<List<dynamic>> getNganhByKhoa(String maKhoa) async {
    final res = await http.get(Uri.parse('$baseUrl/nganh?maKhoa=$maKhoa'), headers: await _headers());
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      if (decoded is List) return decoded;
      if (decoded is Map && decoded.containsKey('data')) return decoded['data'];
      throw Exception('Phản hồi không hợp lệ: $decoded');
    } else {
      throw Exception('Lỗi tải danh sách Ngành: ${res.body}');
    }
  }

  // 👩‍🏫 Lấy danh sách lớp theo mã Ngành
  Future<List<dynamic>> getLopByNganh(String maNganh) async {
    final res = await http.get(Uri.parse('$baseUrl/lop?maNganh=$maNganh'), headers: await _headers());
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      if (decoded is List) return decoded;
      if (decoded is Map && decoded.containsKey('data')) return decoded['data'];
      throw Exception('Phản hồi không hợp lệ: $decoded');
    } else {
      throw Exception('Lỗi tải danh sách Lớp: ${res.body}');
    }
  }

  // 👨‍🎓 Lấy danh sách sinh viên theo lớp
  Future<List<dynamic>> getSinhVienByLop(String maLop) async {
    final res = await http.get(Uri.parse('$baseUrl/lop/$maLop/sinhvien'), headers: await _headers());
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      if (decoded is List) return decoded;
      if (decoded is Map && decoded.containsKey('data')) return decoded['data'];
      throw Exception('Phản hồi không hợp lệ: $decoded');
    } else {
      throw Exception('Lỗi tải danh sách Sinh viên: ${res.body}');
    }
  }

  // 📤 Import sinh viên từ file Excel
  Future<void> importSinhVienExcel({
    required String maLop,
    required String fileName,
    Uint8List? bytes,
    String? filePath,
  }) async {
    final uri = Uri.parse('$baseUrl/lop/$maLop/import-sinhvien');
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(await _headers());

    // 🧩 Gửi file Excel (hỗ trợ Web + Mobile)
    if (filePath != null && filePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('file', filePath, filename: fileName));
    } else if (bytes != null) {
      request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: fileName));
    } else {
      throw Exception('Không có dữ liệu file Excel để upload.');
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Import thất bại (${response.statusCode}): $body');
    } else {
      print('✅ Import Excel thành công: $body');
    }
  }

  // 📸 Upload ảnh sinh viên (chạy cả Web & Mobile)
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
        // 🌐 Flutter Web: chỉ hỗ trợ bytes
        if (bytes == null) throw Exception('Không có bytes ảnh để upload (web)');
        request.files.add(http.MultipartFile.fromBytes('photo', bytes, filename: fileName));
      } else {
        // 📱 Mobile / Desktop: có thể dùng path
        if (filePath != null && filePath.isNotEmpty) {
          request.files.add(await http.MultipartFile.fromPath('photo', filePath, filename: fileName));
        } else if (bytes != null) {
          request.files.add(http.MultipartFile.fromBytes('photo', bytes, filename: fileName));
        } else {
          throw Exception('Không có file hợp lệ để upload');
        }
      }
    } catch (e) {
      throw Exception('Lỗi xử lý file upload: $e');
    }

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Upload ảnh thất bại (${response.statusCode}): $body');
    } else {
      print('✅ Upload ảnh khuôn mặt thành công: $body');
    }
  }

}
