import '../../data/models/giangvien_model.dart';
import '../../data/repositories/giangvien_repository.dart';
import '../../data/datasources/giangvien_api.dart';

class GiangVienController {
  static final GiangVienController _instance = GiangVienController._internal();
  factory GiangVienController() => _instance;
  GiangVienController._internal();

  GiangVien? currentGiangVien;
  final GiangVienApi _api = GiangVienApi();
  final GiangVienRepository _repo = GiangVienRepository(GiangVienApi());

  Future<void> loadCurrentGiangVien() async {
    currentGiangVien = await _api.fetchCurrentGiangVien();
  }

  GiangVien? get giangVien => currentGiangVien;
}
