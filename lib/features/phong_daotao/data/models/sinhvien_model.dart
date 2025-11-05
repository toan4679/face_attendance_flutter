class SinhVienModel {
  final int? maSV;
  final String maSo;
  final String hoTen;
  final String email;
  final String? gioiTinh;
  final String? ngaySinh;
  final String? sdt;
  final String? diaChi;
  final int? maLop;

  SinhVienModel({
    this.maSV,
    required this.maSo,
    required this.hoTen,
    required this.email,
    this.gioiTinh,
    this.ngaySinh,
    this.sdt,
    this.diaChi,
    this.maLop,
  });

  factory SinhVienModel.fromJson(Map<String, dynamic> json) {
    return SinhVienModel(
      maSV: json['maSV'] ?? json['id'],
      maSo: json['maSo'] ?? '',
      hoTen: json['hoTen'] ?? '',
      email: json['email'] ?? '',
      gioiTinh: json['gioiTinh'],
      ngaySinh: json['ngaySinh'],
      sdt: json['sdt'],
      diaChi: json['diaChi'],
      maLop: json['maLop'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maSV': maSV,
      'maSo': maSo,
      'hoTen': hoTen,
      'email': email,
      'gioiTinh': gioiTinh,
      'ngaySinh': ngaySinh,
      'sdt': sdt,
      'diaChi': diaChi,
      'maLop': maLop,
    };
  }
}
