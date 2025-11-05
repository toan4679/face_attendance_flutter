class LopHocPhanModel {
  final int maLopHP;
  final int? maMon;        // Mã môn học
  final int? maGV;         // 🆕 Mã giảng viên được gán (có thể null)
  final String maSoLopHP;  // Mã lớp học phần (VD: SE101-L01)
  final String hocKy;
  final String namHoc;
  final String? ngayBatDau;
  final String? ngayKetThuc;
  final String? tenMon;    // Tên môn học để hiển thị

  LopHocPhanModel({
    required this.maLopHP,
    this.maMon,
    this.maGV,
    required this.maSoLopHP,
    required this.hocKy,
    required this.namHoc,
    this.ngayBatDau,
    this.ngayKetThuc,
    this.tenMon,
  });

  factory LopHocPhanModel.fromJson(Map<String, dynamic> json) {
    return LopHocPhanModel(
      maLopHP: json['maLopHP'] ?? 0,
      maMon: json['maMon'],
      maGV: json['maGV'], // 🆕 Thêm parse mã giảng viên
      maSoLopHP: json['maSoLopHP'] ?? '',
      hocKy: json['hocKy'] ?? '',
      namHoc: json['namHoc'] ?? '',
      ngayBatDau: json['ngayBatDau'],
      ngayKetThuc: json['ngayKetThuc'],
      tenMon: json['mon_hoc'] != null
          ? json['mon_hoc']['tenMon']
          : json['tenMon'], // hỗ trợ cả response có hoặc không có nested object
    );
  }

  Map<String, dynamic> toJson() => {
    'maLopHP': maLopHP,
    'maMon': maMon,
    'maGV': maGV,
    'maSoLopHP': maSoLopHP,
    'hocKy': hocKy,
    'namHoc': namHoc,
    'ngayBatDau': ngayBatDau,
    'ngayKetThuc': ngayKetThuc,
    'tenMon': tenMon,
  };
}
