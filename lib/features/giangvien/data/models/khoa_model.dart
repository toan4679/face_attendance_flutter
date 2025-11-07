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

    return Khoa(
      maKhoa: _asInt(json['maKhoa']),
      tenKhoa: _asString(json['tenKhoa']),
      moTa: json['moTa'] != null ? _asString(json['moTa']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'maKhoa': maKhoa,
    'tenKhoa': tenKhoa,
    'moTa': moTa,
  };
}