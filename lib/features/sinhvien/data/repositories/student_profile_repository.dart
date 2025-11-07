import 'package:dio/dio.dart';
import 'package:face_attendance_flutter/core/network/api_constants.dart';
import 'package:face_attendance_flutter/core/network/token_storage.dart';
import '../models/student_profile_model.dart';

class StudentProfileRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  // 📌 Lấy thông tin sinh viên
  Future<StudentProfile> fetchProfile() async {
    final token = await TokenStorage.getToken();
    try {
      print("📡 [DEBUG] Gọi API fetchProfile()...");

      final response = await _dio.get(
        '/v1/sinhvien/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print("📡 [DEBUG] Response fetchProfile: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data']; // ✅ lấy từ key 'data'
        final profile = StudentProfile.fromJson(data);
        print("✅ [DEBUG] Nhận dữ liệu sinh viên: ${profile.toJson()}");
        return profile;
      } else {
        throw Exception("Phản hồi không hợp lệ từ server");
      }
    } catch (e) {
      print("❌ [DEBUG] Lỗi fetchProfile(): $e");
      rethrow;
    }
  }

  // 📌 Cập nhật thông tin sinh viên
  Future<StudentProfile> updateProfile({
    String? hoTen,
    String? soDienThoai,
  }) async {
    final token = await TokenStorage.getToken();
    try {
      print("📡 [DEBUG] Gọi API updateProfile()...");

      final response = await _dio.put(
        '/v1/sinhvien/profile',
        data: {
          if (hoTen != null) 'hoTen': hoTen,
          if (soDienThoai != null) 'soDienThoai': soDienThoai,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print("📡 [DEBUG] Response updateProfile: ${response.data}");

      final data = response.data['data'];
      final profile = StudentProfile.fromJson(data);
      print("✅ [DEBUG] Cập nhật sinh viên thành công: ${profile.toJson()}");
      return profile;
    } catch (e) {
      print("❌ [DEBUG] Lỗi updateProfile(): $e");
      rethrow;
    }
  }

  // 📌 Upload ảnh đại diện
  Future<String> uploadAvatar(String imagePath) async {
    final token = await TokenStorage.getToken();
    try {
      print("📤 [DEBUG] Upload avatar: $imagePath");

      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(imagePath, filename: 'avatar.jpg'),
      });

      final response = await _dio.post(
        '/v1/sinhvien/profile/avatar',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print("📡 [DEBUG] Response uploadAvatar: ${response.data}");
      final avatarUrl = response.data['avatar_url'] ?? response.data['data']?['avatar_url'];
      print("✅ [DEBUG] Ảnh mới: $avatarUrl");
      return avatarUrl;
    } catch (e) {
      print("❌ [DEBUG] Lỗi uploadAvatar(): $e");
      rethrow;
    }
  }

  // 📌 Đăng xuất
  Future<void> logout() async {
    final token = await TokenStorage.getToken();
    try {
      print("📤 [DEBUG] Gọi API logout()");
      await _dio.post(
        '/v1/sinhvien/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      await TokenStorage.clearToken();
      print("✅ [DEBUG] Đã xóa token và đăng xuất thành công");
    } catch (e) {
      print("❌ [DEBUG] Lỗi logout(): $e");
      rethrow;
    }
  }
}
