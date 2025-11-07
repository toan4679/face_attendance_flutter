class DiemDanhBuoiHocChiTiet {
  final String maBuoi;
  final String maLopHP;
  final String maGV;
  final String thu;
  final int tietBatDau;
  final int tietKetThuc;
  final DateTime ngayHoc;
  final DateTime? gioBatDau;  // có thể null
  final DateTime? gioKetThuc; // có thể null
  final String phongHoc;
  String trangThai;            // "Đúng giờ", "Đi muộn", "Vắng"
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

  // =================== fromJson ===================
  factory DiemDanhBuoiHocChiTiet.fromJson(Map<String, dynamic> json) {
    return DiemDanhBuoiHocChiTiet(
      maBuoi: json['maBuoi'] ?? '',
      maLopHP: json['maLopHP'] ?? '',
      maGV: json['maGV'] ?? '',
      thu: json['thu'] ?? '',
      tietBatDau: json['tietBatDau'] ?? 0,
      tietKetThuc: json['tietKetThuc'] ?? 0,
      ngayHoc: json['ngayHoc'] != null ? DateTime.parse(json['ngayHoc']) : DateTime.now(),
      gioBatDau: json['gioBatDau'] != null ? DateTime.parse(json['gioBatDau']) : null,
      gioKetThuc: json['gioKetThuc'] != null ? DateTime.parse(json['gioKetThuc']) : null,
      phongHoc: json['phongHoc'] ?? '',
      trangThai: json['trangThai'] ?? 'unknown',
      maQR: json['maQR'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      up: json['up'],
    );
  }
}
