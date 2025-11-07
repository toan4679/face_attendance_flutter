// lib/features/giangvien/data/models/khoa_model.dart
class Khoa {
  final int maKhoa;
  final String tenKhoa;
  final String? moTa;

  Khoa({
    required this.maKhoa,
    required this.tenKhoa,
    this.moTa,
  });

  factory Khoa.fromJson(Map<String, dynamic> json) {
    return Khoa(
      maKhoa: json['maKhoa'],
      tenKhoa: json['tenKhoa'],
      moTa: json['moTa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maKhoa': maKhoa,
      'tenKhoa': tenKhoa,
      'moTa': moTa,
    };
  }
}
