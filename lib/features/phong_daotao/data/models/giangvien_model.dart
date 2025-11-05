class GiangVienModel {
  final int maGV;
  final String hoTen;
  final String? email;
  final int? maKhoa; // ✅ Thêm trường này để lọc theo Khoa

  GiangVienModel({
    required this.maGV,
    required this.hoTen,
    this.email,
    this.maKhoa,
  });

  factory GiangVienModel.fromJson(Map<String, dynamic> json) {
    return GiangVienModel(
      maGV: json['maGV'] ?? 0,
      hoTen: json['hoTen'] ?? '',
      email: json['email'],
      maKhoa: json['maKhoa'],
    );
  }
}
