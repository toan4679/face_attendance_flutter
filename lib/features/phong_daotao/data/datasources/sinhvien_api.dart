import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../../../core/network/token_storage.dart';

class SinhVienApi {
  final String baseUrl = 'http://104.145.210.69/api/v1/pdt';

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

  // 📤 Import sinh viên từ Excel
  Future<void> importSinhVienExcel({
    required String maLop,
    required String fileName,
    Uint8List? bytes,
    String? filePath,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/lop/$maLop/import-sinhvien'),
    )
      ..headers.addAll(await _headers())
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        bytes!,
        filename: fileName,
      ));
    final response = await request.send();
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Import thất bại (${response.statusCode})');
    }
  }

  // 📸 Upload ảnh sinh viên
  Future<void> uploadFacePhoto({
    required int maSV,
    required String fileName,
    Uint8List? bytes,
    String? filePath,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/khuonmat/$maSV/approve'),
    )
      ..headers.addAll(await _headers())
      ..files.add(http.MultipartFile.fromBytes('photo', bytes!, filename: fileName));

    final response = await request.send();
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Upload ảnh thất bại (${response.statusCode})');
    }
  }
}
