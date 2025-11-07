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

  // Chuyển từ JSON sang model
  factory BuoiHoc.fromJson(Map<String, dynamic> json) {
    return BuoiHoc(
      maBuoi: json['maBuoi'] ?? 0,
      tenMon: json['tenMon'] ?? '',
      maSoLopHP: json['maSoLopHP'] ?? '',
      ngayHoc: DateTime.parse(json['ngayHoc']),
      gioBatDau: json['gioBatDau'] ?? '',
      gioKetThuc: json['gioKetThuc'] ?? '',
      phongHoc: json['phongHoc'] ?? '',
    );
  }

  // Chuyển từ model sang JSON (nếu cần gửi lên API)
  Map<String, dynamic> toJson() {
    return {
      'maBuoi': maBuoi,
      'tenMon': tenMon,
      'maSoLopHP': maSoLopHP,
      'ngayHoc': ngayHoc.toIso8601String(),
      'gioBatDau': gioBatDau,
      'gioKetThuc': gioKetThuc,
      'phongHoc': phongHoc,
    };
  }

  // Tách thời gian để hiển thị "08:00 - 09:50"
  String get thoiGian => '$gioBatDau - $gioKetThuc';
}
