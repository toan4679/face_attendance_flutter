// sinhvien_model.dart
import 'chitiet_sv_diemdanh_model.dart';

class SinhVien {
  final String ma;
  final String ten;
  final String lop;
  String trangThai;
  String? avatar;
  int soBuoiDiemDanh;
  List<DiemDanhBuoiHocChiTiet> diemDanhChiTiet;

  SinhVien({
    required this.ma,
    required this.ten,
    required this.lop,
    this.trangThai = "unknown",
    this.avatar,
    this.soBuoiDiemDanh = 0,
    List<DiemDanhBuoiHocChiTiet>? diemDanhChiTiet,
  }) : diemDanhChiTiet = diemDanhChiTiet ?? [];

  String get avatarOrDefault => avatar ?? 'assets/images/toandeptrai.jpg';

  factory SinhVien.fromJson(Map<String, dynamic> json) {
    String _asString(dynamic v, [String def = '']) => v == null ? def : v.toString();
    int _asInt(dynamic v, [int def = 0]) {
      if (v == null) return def;
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? def;
      if (v is double) return v.toInt();
      return def;
    }

    List<DiemDanhBuoiHocChiTiet> _asList(dynamic v) {
      if (v is List) {
        return v
            .where((e) => e is Map<String, dynamic>)
            .map((e) => DiemDanhBuoiHocChiTiet.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return <DiemDanhBuoiHocChiTiet>[];
    }

    return SinhVien(
      ma: _asString(json['ma'] ?? json['maSV']),
      ten: _asString(json['ten'] ?? json['tenSV']),
      lop: _asString(json['lop']),
      trangThai: _asString(json['trangThai'], 'unknown'),
      avatar: json['avatar'] == null ? null : _asString(json['avatar']),
      soBuoiDiemDanh: _asInt(json['soBuoiDiemDanh']),
      diemDanhChiTiet: _asList(json['diemDanhChiTiet']),
    );
  }
}

// (Lưu ý: Nếu bạn đang dùng lớp DiemDanhBuoiHocChiTiet thứ hai bên dưới file này thì giữ nguyên,
// nhưng nên đảm bảo nơi parse DateTime sử dụng tryParse như đã làm ở file chitiet_sv_diemdanh_model.dart.)