class MonHocModel {
  final int maMon;
  final String maSoMon;
  final String tenMon;
  final int soTinChi;
  final String moTa;
  final int maNganh;
  final String tenNganh;

  MonHocModel({
    required this.maMon,
    required this.maSoMon,
    required this.tenMon,
    required this.soTinChi,
    required this.moTa,
    required this.maNganh,
    required this.tenNganh,
  });

  factory MonHocModel.fromJson(Map<String, dynamic> json) {
    return MonHocModel(
      maMon: json['maMon'] ?? 0,
      maSoMon: json['maSoMon'] ?? '',
      tenMon: json['tenMon'] ?? '',
      soTinChi: json['soTinChi'] ?? 0,
      moTa: json['moTa'] ?? '',
      maNganh: json['maNganh'] ?? 0,
      tenNganh: json['tenNganh'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maSoMon': maSoMon,
      'tenMon': tenMon,
      'soTinChi': soTinChi,
      'moTa': moTa,
      'maNganh': maNganh,
    };
  }
}
