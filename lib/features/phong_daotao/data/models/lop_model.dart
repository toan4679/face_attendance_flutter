class LopModel {
  final int maLop;
  final String maSoLop;      // 👈 THÊM
  final String tenLop;
  final String khoaHoc;
  final int maNganh;
  final String tenNganh;
  final int siSo;
  final String? coVan;

  LopModel({
    required this.maLop,
    required this.maSoLop,   // 👈 THÊM
    required this.tenLop,
    required this.khoaHoc,
    required this.maNganh,
    required this.tenNganh,
    required this.siSo,
    this.coVan,
  });

  factory LopModel.fromJson(Map<String, dynamic> json) {
    return LopModel(
      maLop: json['maLop'] ?? 0,
      maSoLop: json['maSoLop'] ?? '',          // 👈 MAP
      tenLop: json['tenLop'] ?? '',
      khoaHoc: json['khoaHoc'] ?? '',
      maNganh: json['maNganh'] ?? 0,
      tenNganh: json['tenNganh'] ?? '',
      siSo: json['siSo'] ?? 0,
      coVan: json['coVan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maSoLop': maSoLop,                       // 👈 GỬI LÊN API
      'tenLop': tenLop,
      'khoaHoc': khoaHoc,
      'maNganh': maNganh,
      if (coVan != null) 'coVan': coVan,
    };
  }
}
