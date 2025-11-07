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
    return SinhVien(
      ma: json['ma'] ?? json['maSV'] ?? '',
      ten: json['ten'] ?? json['tenSV'] ?? '',
      lop: json['lop'] ?? '',
      trangThai: json['trangThai'] ?? 'unknown',
      avatar: json['avatar'],
      soBuoiDiemDanh: json['soBuoiDiemDanh'] ?? 0,
      diemDanhChiTiet: (json['diemDanhChiTiet'] as List?)
          ?.map((e) => DiemDanhBuoiHocChiTiet.fromJson(e))
          .toList() ??
          [],
    );
  }
}

// chitiet_sv_diemdanh_model.dart
class DiemDanhBuoiHocChiTiet {
  final String monHoc;
  final String lop;
  final DateTime ngay;
  final DateTime gio;
  final String phong;
  String trangThai;

  DiemDanhBuoiHocChiTiet({
    required this.monHoc,
    required this.lop,
    required this.ngay,
    required this.gio,
    required this.phong,
    required this.trangThai,
  });

  factory DiemDanhBuoiHocChiTiet.fromJson(Map<String, dynamic> json) {
    return DiemDanhBuoiHocChiTiet(
      monHoc: json['monHoc'] ?? '',
      lop: json['lop'] ?? '',
      ngay: DateTime.parse(json['ngay']),
      gio: DateTime.parse(json['gio']),
      phong: json['phong'] ?? '',
      trangThai: json['trangThai'] ?? 'unknown',
    );
  }
}
