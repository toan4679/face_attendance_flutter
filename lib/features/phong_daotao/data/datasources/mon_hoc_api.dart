import '../../../../core/network/api_service.dart';
import '../../../../core/constants/api_endpoints.dart';

class MonHocApi {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> fetchAll() async {
    final response = await _apiService.get(ApiEndpoints.pdtMonHoc);
    // 🔹 Laravel trả về List, không có "data"
    if (response is List) {
      return response;
    } else if (response['data'] is List) {
      return response['data'];
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    return await _apiService.post(ApiEndpoints.pdtMonHoc, data);
  }

  Future<Map<String, dynamic>> update(int id, Map<String, dynamic> data) async {
    return await _apiService.put('${ApiEndpoints.pdtMonHoc}/$id', data);
  }

  Future<void> delete(int id) async {
    await _apiService.delete('${ApiEndpoints.pdtMonHoc}/$id');
  }
}
