import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class AssignScheduleApi {
  final Dio dio = ApiClient.instance.dio;

  Future<Response> getByGiangVien(int maGV) async {
    print('[DEBUG] 📡 Fetching lịch dạy của giảng viên $maGV...');
    return await dio.get('/v1/pdt/schedule', queryParameters: {'maGV': maGV});
  }

  Future<Response> assign(Map<String, dynamic> body) async {
    print('[DEBUG] 📨 Gán lịch dạy: $body');
    return await dio.post('/v1/pdt/schedule/assign', data: body);
  }

  Future<Response> update(int id, Map<String, dynamic> body) async {
    print('[DEBUG] 🔧 Update lịch dạy $id: $body');
    return await dio.put('/v1/pdt/schedule/$id', data: body);
  }

  Future<Response> delete(int id) async {
    print('[DEBUG] 🗑 Delete lịch dạy $id...');
    return await dio.delete('/v1/pdt/schedule/$id');
  }
}