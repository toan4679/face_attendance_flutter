class StudentProfile {
  final String maSV;
  final String hoTen;
  final String email;
  final String lop;
  final String nganh;
  final String? soDienThoai;
  final String? anhDaiDien;

  StudentProfile({
    required this.maSV,
    required this.hoTen,
    required this.email,
    required this.lop,
    required this.nganh,
    this.soDienThoai,
    this.anhDaiDien,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      maSV: json['maSV'].toString(), // ✅ ép kiểu an toàn
      hoTen: json['hoTen'] ?? '',
      email: json['email'] ?? '',
      lop: json['lop'] ?? '',
      nganh: json['nganh'] ?? '',
      soDienThoai: json['soDienThoai'] ?? '',
      anhDaiDien: json['anhDaiDien'],
    );
  }

  Map<String, dynamic> toJson() => {
    'maSV': maSV,
    'hoTen': hoTen,
    'email': email,
    'lop': lop,
    'nganh': nganh,
    'soDienThoai': soDienThoai,
    'anhDaiDien': anhDaiDien,
  };
}
