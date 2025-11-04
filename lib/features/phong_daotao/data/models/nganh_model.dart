class NganhModel {
  final int maNganh;
  final String maSo;       // ✅ đổi tên thuộc tính
  final String tenNganh;
  final int maKhoa;
  final String? moTa;

  NganhModel({
    required this.maNganh,
    required this.maSo,
    required this.tenNganh,
    required this.maKhoa,
    this.moTa,
  });

  factory NganhModel.fromJson(Map<String, dynamic> json) {
    return NganhModel(
      maNganh: json['maNganh'] ?? 0,
      maSo: json['maSo'] ?? '',
      tenNganh: json['tenNganh'] ?? '',
      maKhoa: json['maKhoa'] ?? 0,
      moTa: json['moTa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maSo': maSo,
      'tenNganh': tenNganh,
      'maKhoa': maKhoa,
      'moTa': moTa,
    };
  }
}
