class DiemDanhBuoiHocChiTiet {
  final String maBuoi;
  final String maLopHP;
  final String maGV;
  final String thu;
  final int tietBatDau;
  final int tietKetThuc;
  final DateTime ngayHoc;
  final DateTime? gioBatDau;
  final DateTime? gioKetThuc;
  final String phongHoc;
  String trangThai; // "Đúng giờ", "Đi muộn", "Vắng"
  final String? maQR;
  final DateTime? createdAt;
  final int? up;

  DiemDanhBuoiHocChiTiet({
    required this.maBuoi,
    required this.maLopHP,
    required this.maGV,
    required this.thu,
    required this.tietBatDau,
    required this.tietKetThuc,
    required this.ngayHoc,
    this.gioBatDau,
    this.gioKetThuc,
    required this.phongHoc,
    this.trangThai = "unknown",
    this.maQR,
    this.createdAt,
    this.up,
  });

  factory DiemDanhBuoiHocChiTiet.fromJson(Map<String, dynamic> json) {
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

    DateTime _asDate(dynamic v, {DateTime? def}) {
      if (v == null) return def ?? DateTime.now();
      if (v is DateTime) return v;
      if (v is String) return DateTime.tryParse(v) ?? (def ?? DateTime.now());
      return def ?? DateTime.now();
    }

    DateTime? _asDateOrNull(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      if (v is String) return DateTime.tryParse(v);
      return null;
    }

    return DiemDanhBuoiHocChiTiet(
      maBuoi: _asString(json['maBuoi']),
      maLopHP: _asString(json['maLopHP']),
      maGV: _asString(json['maGV']),
      thu: _asString(json['thu']),
      tietBatDau: _asInt(json['tietBatDau']),
      tietKetThuc: _asInt(json['tietKetThuc']),
      ngayHoc: _asDate(json['ngayHoc']),
      gioBatDau: _asDateOrNull(json['gioBatDau']),
      gioKetThuc: _asDateOrNull(json['gioKetThuc']),
      phongHoc: _asString(json['phongHoc']),
      trangThai: _asString(json['trangThai'], 'unknown'),
      maQR: json['maQR'] == null ? null : _asString(json['maQR']),
      createdAt: _asDateOrNull(json['created_at']),
      up: json['up'] == null ? null : _asInt(json['up']),
    );
  }
}