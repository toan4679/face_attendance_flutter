class BuoiHoc {
  final int maBuoi;
  final String tenMon;
  final String maSoLopHP;
  final DateTime ngayHoc;
  final String gioBatDau;
  final String gioKetThuc;
  final String phongHoc;

  BuoiHoc({
    required this.maBuoi,
    required this.tenMon,
    required this.maSoLopHP,
    required this.ngayHoc,
    required this.gioBatDau,
    required this.gioKetThuc,
    required this.phongHoc,
  });

  factory BuoiHoc.fromJson(Map<String, dynamic> json) {
    int _asInt(dynamic v, [int def = 0]) {
      if (v == null) return def;
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? def;
      if (v is double) return v.toInt();
      return def;
    }

    String _asString(dynamic v, [String def = '']) => v == null ? def : v.toString();

    DateTime _asDate(dynamic v, {DateTime? def}) {
      if (v == null) return def ?? DateTime.now();
      if (v is DateTime) return v;
      if (v is String) return DateTime.tryParse(v) ?? (def ?? DateTime.now());
      return def ?? DateTime.now();
    }

    return BuoiHoc(
      maBuoi: _asInt(json['maBuoi']),
      tenMon: _asString(json['tenMon']),
      maSoLopHP: _asString(json['maSoLopHP']),
      ngayHoc: _asDate(json['ngayHoc']),
      gioBatDau: _asString(json['gioBatDau']),
      gioKetThuc: _asString(json['gioKetThuc']),
      phongHoc: _asString(json['phongHoc']),
    );
  }

  Map<String, dynamic> toJson() => {
    'maBuoi': maBuoi,
    'tenMon': tenMon,
    'maSoLopHP': maSoLopHP,
    'ngayHoc': ngayHoc.toIso8601String(),
    'gioBatDau': gioBatDau,
    'gioKetThuc': gioKetThuc,
    'phongHoc': phongHoc,
  };

  String get thoiGian => '$gioBatDau - $gioKetThuc';
}