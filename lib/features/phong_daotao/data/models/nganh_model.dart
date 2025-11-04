class NganhModel {
  final int maNganh;
  final String tenNganh;
  final String? moTa;

  NganhModel({
    required this.maNganh,
    required this.tenNganh,
    this.moTa,
  });

  factory NganhModel.fromJson(Map<String, dynamic> json) {
    return NganhModel(
      maNganh: json['maNganh'],
      tenNganh: json['tenNganh'] ?? '',
      moTa: json['moTa'],
    );
  }
}
