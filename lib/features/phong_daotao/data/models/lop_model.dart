class LopModel {
  final String maLop;
  final String tenLop;
  final String maNganh;
  final int siSo;

  LopModel({
    required this.maLop,
    required this.tenLop,
    required this.maNganh,
    required this.siSo,
  });

  factory LopModel.fromJson(Map<String, dynamic> json) {
    return LopModel(
      maLop: json['maLop'],
      tenLop: json['tenLop'],
      maNganh: json['maNganh'],
      siSo: json['siSo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maLop': maLop,
      'tenLop': tenLop,
      'maNganh': maNganh,
      'siSo': siSo,
    };
  }
}
