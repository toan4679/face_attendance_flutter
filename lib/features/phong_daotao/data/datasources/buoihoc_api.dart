import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class BuoiHocApi {
  Dio get _dio => ApiClient.instance.dio;

  Future<Response> getList({int? maLopHP}) {
    final qp = maLopHP != null ? {'maLopHP': maLopHP} : null;
    print('[DEBUG] 📡 GET /v1/pdt/buoihoc  params=$qp');
    return _dio.get('/v1/pdt/buoihoc', queryParameters: qp);
  }

  Future<Response> create(Map<String, dynamic> body) {
    print('[DEBUG] 📤 POST /v1/pdt/buoihoc  body=$body');
    return _dio.post('/v1/pdt/buoihoc', data: body);
  }

  Future<Response> createMultiple(List<Map<String, dynamic>> list) {
    print('[DEBUG] 📤 POST /v1/pdt/buoihoc/multiple  list=${list.length} items');
    return _dio.post('/v1/pdt/buoihoc/multiple', data: {'list': list});
  }

  Future<Response> update(int id, Map<String, dynamic> body) {
    print('[DEBUG] 🛠 PATCH /v1/pdt/buoihoc/$id  body=$body');
    return _dio.patch('/v1/pdt/buoihoc/$id', data: body);
  }

  Future<Response> delete(int id) {
    print('[DEBUG] 🗑 DELETE /v1/pdt/buoihoc/$id');
    return _dio.delete('/v1/pdt/buoihoc/$id');
  }
}
