import 'package:flutter/cupertino.dart';

import '../../../../core/network/api_service.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/nganh_model.dart';

class NganhRepository {
  final ApiService _api = ApiService();

  Future<List<NganhModel>> getAll() async {
    final response = await _api.get(ApiEndpoints.pdtNganh);
    debugPrint('📥 Response ngành: $response');

    // ✅ Kiểm tra xem response có chứa trường 'data' (khi Laravel paginate)
    if (response is Map && response.containsKey('data')) {
      final list = response['data'] as List;
      return list.map((e) => NganhModel.fromJson(e)).toList();
    }

    // ✅ Trường hợp API trả thẳng danh sách
    if (response is List) {
      return response.map((e) => NganhModel.fromJson(e)).toList();
    }

    debugPrint('⚠️ Response không phải List hoặc Map chứa data');
    return [];
  }



  Future<NganhModel> create(NganhModel nganh) async {
    final response = await _api.post(ApiEndpoints.pdtNganh, nganh.toJson());
    return NganhModel.fromJson(response);
  }

  Future<NganhModel> update(int id, NganhModel nganh) async {
    final response = await _api.put('${ApiEndpoints.pdtNganh}/$id', nganh.toJson());
    return NganhModel.fromJson(response);
  }

  Future<void> delete(int id) async {
    await _api.delete('${ApiEndpoints.pdtNganh}/$id');
  }
}
