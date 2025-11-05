class BuoiHocModel {
  final int maBuoi;
  final int maLopHP;
  final int? maGV;
  final String thu;             // "Thứ 2"..."Chủ nhật"
  final int tietBatDau;         // 1..12
  final int tietKetThuc;        // >= tietBatDau
  final String phongHoc;


  // 🆕 Thêm các trường lồng
  final Map<String, dynamic>? lopHocPhan;
  final Map<String, dynamic>? giangVien;

  BuoiHocModel({
    required this.maBuoi,
    required this.maLopHP,
    this.maGV,
    required this.thu,
    required this.tietBatDau,
    required this.tietKetThuc,
    required this.phongHoc,
    this.lopHocPhan,
    this.giangVien,
  });

  factory BuoiHocModel.fromJson(Map<String, dynamic> json) => BuoiHocModel(
    maBuoi: json['maBuoi'],
    maLopHP: json['maLopHP'],
    maGV: json['maGV'],
    thu: json['thu'] ?? '',
    tietBatDau: (json['tietBatDau'] ?? 0) is String
        ? int.tryParse(json['tietBatDau']) ?? 0
        : (json['tietBatDau'] ?? 0),
    tietKetThuc: (json['tietKetThuc'] ?? 0) is String
        ? int.tryParse(json['tietKetThuc']) ?? 0
        : (json['tietKetThuc'] ?? 0),
    phongHoc: json['phongHoc'] ?? '',
    // 🆕 Parse thêm các object lồng
    lopHocPhan: json['lop_hoc_phan'],
    giangVien: json['giang_vien'],
  );

  Map<String, dynamic> toJson() => {
    'maLopHP': maLopHP,
    if (maGV != null) 'maGV': maGV,
    'thu': thu,
    'tietBatDau': tietBatDau,
    'tietKetThuc': tietKetThuc,
    'phongHoc': phongHoc,
  };
}
