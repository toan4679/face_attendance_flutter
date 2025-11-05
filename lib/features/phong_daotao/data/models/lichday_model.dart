class LichDayModel {
  final int id;
  final int maLopHP;
  final int maGV;
  final String thu;
  final String tietBatDau;
  final String tietKetThuc;
  final String phongHoc;
  final String? tenMon;

  LichDayModel({
    required this.id,
    required this.maLopHP,
    required this.maGV,
    required this.thu,
    required this.tietBatDau,
    required this.tietKetThuc,
    required this.phongHoc,
    this.tenMon,
  });

  factory LichDayModel.fromJson(Map<String, dynamic> json) {
    return LichDayModel(
      id: json['maBuoi'] ?? json['id'] ?? 0,
      maLopHP: json['maLopHP'] ?? 0,
      maGV: json['maGV'] ?? 0,
      thu: json['thu'] ?? '',
      tietBatDau: json['tietBatDau']?.toString() ?? '',
      tietKetThuc: json['tietKetThuc']?.toString() ?? '',
      phongHoc: json['phongHoc'] ?? '',
      tenMon: json['lophocphan']?['mon_hoc']?['tenMon'] ?? '',
    );
  }
}
