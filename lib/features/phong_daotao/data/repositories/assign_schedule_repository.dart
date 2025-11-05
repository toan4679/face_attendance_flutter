import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/buoi_hoc_model.dart';

class AssignScheduleRepository {
  final Dio dio = ApiClient.instance.dio;

  /// 📥 Lấy danh sách buổi học của giảng viên
  Future<List<BuoiHocModel>> getByGiangVien(int maGV) async {
    final res = await dio.get('/v1/giangvien/lichday', queryParameters: {'maGV': maGV});
    final data = res.data;
    List<dynamic> raw = [];

    if (data is List) raw = data;
    else if (data is Map && data['data'] is List) raw = data['data'];

    return raw.map((e) => BuoiHocModel.fromJson(e)).toList();
  }

  /// 📤 Gán buổi học (POST /v1/pdt/schedule/assign)
  Future<void> assignBuoiHoc(int maBuoi, int maGV) async {
    await dio.post('/v1/pdt/schedule/assign', data: {
      'maBuoi': maBuoi,
      'maGV': maGV,
    });
  }

  /// 🛠 Cập nhật buổi học (PATCH /v1/pdt/buoihoc/:id)
  Future<void> updateBuoiHoc(int id, Map<String, dynamic> body) async {
    await dio.patch('/v1/pdt/buoihoc/$id', data: body);
  }

  /// 🗑 Gỡ buổi học khỏi giảng viên (DELETE)
  Future<void> unassign(int maBuoi) async {
    await dio.patch('/v1/pdt/buoihoc/$maBuoi', data: {'maGV': null});
  }
}
