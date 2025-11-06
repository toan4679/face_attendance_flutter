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
    return MonHoc(
      maMon: json['maMon'],
      maNganh: json['maNganh'],
      maSoMon: json['maSoMon'],
      tenMon: json['tenMon'],
      soTinChi: json['soTinChi'],
      moTa: json['moTa'] ?? '',
      maKhoa: json['maKhoa'],
    );
  }
}
