class DashboardStats {
  final int tongMonHoc;
  final int tongGiangVien;
  final int tongSinhVien;
  final int tongLopHocPhan;

  DashboardStats({
    required this.tongMonHoc,
    required this.tongGiangVien,
    required this.tongSinhVien,
    required this.tongLopHocPhan,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      tongMonHoc: json['tongMonHoc'] ?? 0,
      tongGiangVien: json['tongGiangVien'] ?? 0,
      tongSinhVien: json['tongSinhVien'] ?? 0,
      tongLopHocPhan: json['tongLopHocPhan'] ?? 0,
    );
  }
}
