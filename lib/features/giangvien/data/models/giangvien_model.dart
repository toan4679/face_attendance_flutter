class GiangVien {
  final int maGV;
  final String hoTen;
  final String email;
  final String? soDienThoai;
  final String? hocVi;
  final int? maKhoa;

  GiangVien({
    required this.maGV,
    required this.hoTen,
    required this.email,
    this.soDienThoai,
    this.hocVi,
    this.maKhoa,
  });

  factory GiangVien.fromJson(Map<String, dynamic> json) {
    return GiangVien(
      maGV: json['maGV'],
      hoTen: json['hoTen'],
      email: json['email'],
      soDienThoai: json['soDienThoai'],
      hocVi: json['hocVi'],
      maKhoa: json['maKhoa'],
    );
  }
}
