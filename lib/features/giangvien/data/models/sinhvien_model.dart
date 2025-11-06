import 'chitiet_sv_diemdanh_model.dart';

class SinhVien {
  final String ma;
  final String ten;
  final String lop;
  String trangThai;
  String? avatar;
  int soBuoiDiemDanh; // số buổi đã điểm danh trong học kỳ
  List<DiemDanhBuoiHocChiTiet> diemDanhChiTiet; // danh sách chi tiết các buổi điểm danh

  SinhVien({
    required this.ma,
    required this.ten,
    required this.lop,
    this.trangThai = "unknown",
    this.avatar,
    this.soBuoiDiemDanh = 0,
    List<DiemDanhBuoiHocChiTiet>? diemDanhChiTiet,
  }) : diemDanhChiTiet = diemDanhChiTiet ?? [];

  String get avatarOrDefault => avatar ?? 'assets/images/toandeptrai.jpg';
}

// =================== DỮ LIỆU MẪU SINH VIÊN ===================
final List<SinhVien> danhSachSinhVienMau = [
  SinhVien(
    ma: "SV001",
    ten: "Nguyễn Văn A",
    lop: "CNTT1",
    trangThai: "Đúng giờ",
    soBuoiDiemDanh: 20,
    diemDanhChiTiet: [
      DiemDanhBuoiHocChiTiet(
        monHoc: "Lập trình Flutter",
        lop: "CNTT1",
        ngay: DateTime(2025, 10, 1),
        gio: DateTime(2025, 10, 1, 7, 5),
        phong: "B203",
        trangThai: "Đúng giờ",
      ),
      DiemDanhBuoiHocChiTiet(
        monHoc: "Lập trình Flutter",
        lop: "CNTT1",
        ngay: DateTime(2025, 10, 3),
        gio: DateTime(2025, 10, 3, 7, 10),
        phong: "B203",
        trangThai: "Muộn",
      ),
    ],
  ),
  SinhVien(
    ma: "SV002",
    ten: "Trần Thị B",
    lop: "CNTT1",
    trangThai: "Đúng giờ",
    soBuoiDiemDanh: 15,
  ),
  SinhVien(
    ma: "SV003",
    ten: "Lê Văn C",
    lop: "CNTT2",
    trangThai: "Muộn",
    soBuoiDiemDanh: 17,
  ),
  SinhVien(
    ma: "SV004",
    ten: "Phạm Thị D",
    lop: "CNTT2",
    trangThai: "Đúng giờ",
    soBuoiDiemDanh: 20,
  ),
];