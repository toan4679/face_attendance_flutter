class LopHocPhanModel {
  final int maLopHP;
  final String maSoLopHP;
  final String hocKy;
  final String namHoc;
  final String? ngayBatDau;
  final String? ngayKetThuc;
  final String? thongTinLichHoc;
  final String? tenMon;
  final String? tenGiangVien;

  LopHocPhanModel({
    required this.maLopHP,
    required this.maSoLopHP,
    required this.hocKy,
    required this.namHoc,
    this.ngayBatDau,
    this.ngayKetThuc,
    this.thongTinLichHoc,
    this.tenMon,
    this.tenGiangVien,
  });

  factory LopHocPhanModel.fromJson(Map<String, dynamic> json) {
    return LopHocPhanModel(
      maLopHP: json['maLopHP'],
      maSoLopHP: json['maSoLopHP'] ?? '',
      hocKy: json['hocKy'] ?? '',
      namHoc: json['namHoc'] ?? '',
      ngayBatDau: json['ngayBatDau'],
      ngayKetThuc: json['ngayKetThuc'],
      thongTinLichHoc: json['thongTinLichHoc'],
      tenMon: json['mon_hoc'] != null ? json['mon_hoc']['tenMon'] : null,
      tenGiangVien: json['giang_vien'] != null
          ? json['giang_vien']['hoTen']
          : null,
    );
  }
}
