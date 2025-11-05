class KhoaModel {
  final int? maKhoa;
  final String tenKhoa;
  final String? moTa;

  KhoaModel({
    this.maKhoa,
    required this.tenKhoa,
    this.moTa,
  });

  factory KhoaModel.fromJson(Map<String, dynamic> json) {
    return KhoaModel(
      maKhoa: json['maKhoa'] ?? json['id'],
      tenKhoa: json['tenKhoa'] ?? '',
      moTa: json['moTa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maKhoa': maKhoa,
      'tenKhoa': tenKhoa,
      'moTa': moTa,
    };
  }
}
