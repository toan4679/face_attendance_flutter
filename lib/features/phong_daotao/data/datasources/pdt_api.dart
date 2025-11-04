import 'package:dio/dio.dart';
import 'package:face_attendance_flutter/core/network/api_constants.dart';
import 'package:face_attendance_flutter/core/network/token_storage.dart';
import '../models/dashboard_stats_model.dart';

class PdtApi {
  final Dio dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<DashboardStats> fetchDashboardStats() async {
    final token = await TokenStorage.getToken();
    final response = await dio.get(
      '/v1/pdt/dashboard/stats',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return DashboardStats.fromJson(response.data);
  }

  Future<List<Map<String, dynamic>>> fetchBuoiHoc() async {
    final token = await TokenStorage.getToken();
    final response = await dio.get(
      '/v1/pdt/buoihoc',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return List<Map<String, dynamic>>.from(response.data);
  }
}
