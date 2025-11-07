class ClassSchedule {
  final String monHoc;
  final String phongHoc;
  final String gioBatDau;
  final String gioKetThuc;
  final String trangThai;
  final String? ngayHoc; // 🟢 thêm trường này
  final String? tenGV;

  ClassSchedule({
    required this.monHoc,
    required this.phongHoc,
    required this.gioBatDau,
    required this.gioKetThuc,
    required this.trangThai,
    this.ngayHoc,
    this.tenGV,
  });

  factory ClassSchedule.fromJson(Map<String, dynamic> json) {
    return ClassSchedule(
      monHoc: json['monHoc'] ?? '',
      phongHoc: json['phongHoc'] ?? '',
      gioBatDau: json['gioBatDau'] ?? '',
      gioKetThuc: json['gioKetThuc'] ?? '',
      trangThai: json['trangThai'] ?? '',
      ngayHoc: json['ngayHoc'] ?? '', // ✅ parse ngày học
      tenGV: json['tenGV'] ?? '',
    );
  }
}
