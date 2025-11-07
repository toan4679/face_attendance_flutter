class MonHoc {
  final int maMon;
  final int maNganh;
  final String maSoMon;
  final String tenMon;
  final int soTinChi;
  final String moTa;
  final int maKhoa;

  MonHoc({
    required this.maMon,
    required this.maNganh,
    required this.maSoMon,
    required this.tenMon,
    required this.soTinChi,
    required this.moTa,
    required this.maKhoa,
  });

  factory MonHoc.fromJson(Map<String, dynamic> json) {
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

    return MonHoc(
      maMon: _asInt(json['maMon']),
      maNganh: _asInt(json['maNganh']),
      maSoMon: _asString(json['maSoMon']),
      tenMon: _asString(json['tenMon']),
      soTinChi: _asInt(json['soTinChi']),
      moTa: _asString(json['moTa']),
      maKhoa: _asInt(json['maKhoa']),
    );
  }

  Map<String, dynamic> toJson() => {
    'maMon': maMon,
    'maNganh': maNganh,
    'maSoMon': maSoMon,
    'tenMon': tenMon,
    'soTinChi': soTinChi,
    'moTa': moTa,
    'maKhoa': maKhoa,
  };
}