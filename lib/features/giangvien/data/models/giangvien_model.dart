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
  String? moTa; // 🆕 Thêm trường mô tả giảng viên

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
    return GiangVien(
      maGV: json['maGV'],
      hoTen: json['hoTen'],
      email: json['email'],
      soDienThoai: json['soDienThoai'],
      hocVi: json['hocVi'],
      maKhoa: json['maKhoa'],
      moTa: json['moTa'], // 🆕 map thêm trường moTa
      khoa: json['khoa'] != null ? Khoa.fromJson(json['khoa']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maGV': maGV,
      'hoTen': hoTen,
      'email': email,
      'soDienThoai': soDienThoai,
      'hocVi': hocVi,
      'maKhoa': maKhoa,
      'moTa': moTa, // 🆕 thêm vào JSON
      'khoa': khoa?.toJson(),
    };
  }
}
