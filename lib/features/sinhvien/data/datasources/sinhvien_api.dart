import 'package:dio/dio.dart';
import 'package:face_attendance_flutter/core/network/api_constants.dart';
import 'package:face_attendance_flutter/core/network/token_storage.dart';
import '../models/class_schedule_model.dart';

class SinhVienApi {
  final Dio dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<List<ClassSchedule>> fetchDashboard() async {
    final token = await TokenStorage.getToken();
    final response = await dio.get(
      '/v1/sinhvien/dashboard',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    // 🟢 Debug dữ liệu thực tế
    print("🟢 [DEBUG] Dashboard response: ${response.data}");

    final data = response.data;
    final today = data['today'];
    final classes = data['classes'] as List;

    // Truyền today cho từng class
    return classes.map((c) {
      return ClassSchedule.fromJson({
        ...c,
        'ngayHoc': today, // ✅ thêm ngày học
      });
    }).toList();
  }
}
