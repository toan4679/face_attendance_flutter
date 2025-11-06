import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:face_attendance_flutter/core/network/api_constants.dart';
import 'package:face_attendance_flutter/core/network/token_storage.dart';
import '../../data/models/lop_hoc_phan_model.dart';
import '../screens/manage_lophocphan_screen.dart';
import '../screens/manage_monhoc_screen.dart';
import '../screens/manage_lop_screen.dart';


class PdtDashboardController extends ChangeNotifier {

  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<Map<String, dynamic>> fetchDashboardStats() async {
    final token = await TokenStorage.getToken();
    final response = await _dio.get(
      '/v1/pdt/dashboard/stats',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<List<LopHocPhanModel>> fetchLopHocPhanList() async {
    final token = await TokenStorage.getToken();
    final response = await _dio.get(
      '/v1/pdt/lophocphan',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((e) => LopHocPhanModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Không thể tải danh sách lớp học phần');
    }
  }

  void gotoNganh(BuildContext context) =>
      Navigator.pushNamed(context, '/pdt/nganh');

  void gotoMonHoc(BuildContext context) =>
      Navigator.pushNamed(context, '/pdt/monhoc');

  void gotoGiangVien(BuildContext context) =>
      Navigator.pushNamed(context, '/pdt/giangvien');

  void gotoSinhVien(BuildContext context) =>
      Navigator.pushNamed(context, '/pdt/sinhvien');

  void gotoLop(BuildContext context) =>
      Navigator.pushNamed(context, '/pdt/lop');

  void gotoLopHocPhan(BuildContext context) {
    Navigator.pushNamed(context, '/pdt/lophocphan');
  }

  void gotoBuoiHoc(BuildContext context) =>
      Navigator.pushNamed(context, '/pdt/buoihoc');

  void gotoGanLich(BuildContext context) =>
      Navigator.pushNamed(context, '/pdt/ganlich');

  void gotoAnhSinhVien(BuildContext context) {
    Navigator.pushNamed(context, '/pdt/khuonmat');
  }
}
