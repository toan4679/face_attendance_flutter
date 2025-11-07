class BuoiHocModel {
  final int maBuoi;
  final int maLopHP;
  final int? maGV;
  final String thu;
  final int tietBatDau;
  final int tietKetThuc;
  final String phongHoc;
  final String? ngayHoc;        // 🆕 ngày học
  final String? gioBatDau;      // 🆕 giờ bắt đầu
  final String? gioKetThuc;     // 🆕 giờ kết thúc

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
    this.ngayHoc,
    this.gioBatDau,
    this.gioKetThuc,
    this.lopHocPhan,
    this.giangVien,
  });

  factory BuoiHocModel.fromJson(Map<String, dynamic> json) => BuoiHocModel(
    maBuoi: json['maBuoi'] ?? json['id'] ?? 0,
    maLopHP: json['maLopHP'] ?? 0,
    maGV: json['maGV'],
    thu: json['thu'] ?? '',
    tietBatDau: int.tryParse(json['tietBatDau'].toString()) ?? 0,
    tietKetThuc: int.tryParse(json['tietKetThuc'].toString()) ?? 0,
    phongHoc: json['phongHoc'] ?? '',
    ngayHoc: json['ngayHoc'],
    gioBatDau: json['gioBatDau'],
    gioKetThuc: json['gioKetThuc'],
    lopHocPhan: json['lop_hoc_phan'],
    giangVien: json['giang_vien'],
  );

  /// ✅ Dùng để gửi API hoặc hiển thị lại khi sửa
  Map<String, dynamic> toJson() => {
    'maBuoi': maBuoi,
    'maLopHP': maLopHP,
    if (maGV != null) 'maGV': maGV,
    'thu': thu,
    'tietBatDau': tietBatDau,
    'tietKetThuc': tietKetThuc,
    'phongHoc': phongHoc,
    if (ngayHoc != null) 'ngayHoc': ngayHoc,
    if (gioBatDau != null) 'gioBatDau': gioBatDau,
    if (gioKetThuc != null) 'gioKetThuc': gioKetThuc,
  };
}
