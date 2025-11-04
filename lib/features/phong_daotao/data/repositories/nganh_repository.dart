import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../models/nganh_model.dart';

class NganhRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<List<NganhModel>> getAll(String token) async {
    try {
      final response = await _dio.get(
        '/v1/pdt/nganh',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data as List;
      return data.map((e) => NganhModel.fromJson(e)).toList();
    } catch (e) {
      print('❌ Lỗi lấy danh sách ngành: $e');
      return [];
    }
  }
}
