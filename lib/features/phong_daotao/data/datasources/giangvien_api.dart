import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class GiangVienApi {
  final Dio dio = ApiClient.instance.dio;

  Future<Response> getAll() async {
    print('[DEBUG] 📡 Fetching danh sách giảng viên...');
    return await dio.get('/v1/pdt/giangvien');
  }
}
