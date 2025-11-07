// lib/features/giangvien/data/models/giangvien_model.dart
import 'khoa_model.dart';

class GiangVien {
  final int maGV;
  String hoTen;
  String email;
  String? soDienThoai;
  String? hocVi;
  int? maKhoa;
  Khoa? khoa;
  String? moTa;

  GiangVien({
    required this.maGV,
    required this.hoTen,
    required this.email,
    this.soDienThoai,
    this.hocVi,
    this.maKhoa,
    this.khoa,
    this.moTa,
  });

  factory GiangVien.fromJson(Map<String, dynamic> json) {
    int _asInt(dynamic v, [int def = 0]) {
      if (v == null) return def;
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? def;
      if (v is double) return v.toInt();
      return def;
    }

    String _asString(dynamic v, [String def = '']) {
      if (v == null) return def;
      return v.toString();
    }

    final _maKhoa = json['maKhoa'];
    return GiangVien(
      maGV: _asInt(json['maGV']),
      hoTen: _asString(json['hoTen']),
      email: _asString(json['email']),
      soDienThoai: json['soDienThoai'] != null ? _asString(json['soDienThoai']) : null,
      hocVi: json['hocVi'] != null ? _asString(json['hocVi']) : null,
      maKhoa: _maKhoa == null ? null : _asInt(_maKhoa),
      moTa: json['moTa'] != null ? _asString(json['moTa']) : null,
      khoa: (json['khoa'] is Map<String, dynamic>)
          ? Khoa.fromJson(json['khoa'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'maGV': maGV,
    'hoTen': hoTen,
    'email': email,
    'soDienThoai': soDienThoai,
    'hocVi': hocVi,
    'maKhoa': maKhoa,
    'moTa': moTa,
    'khoa': khoa?.toJson(),
  };
}