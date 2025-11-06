class DiemDanhBuoiHocChiTiet {
  final String monHoc;       // Tên môn học
  final String lop;          // Tên lớp
  final DateTime ngay;       // Ngày điểm danh
  final DateTime gio;        // Giờ điểm danh thực tế
  final String phong;        // Phòng học
  String trangThai;    // Trạng thái: "present", "absent", "late"

  DiemDanhBuoiHocChiTiet({
    required this.monHoc,
    required this.lop,
    required this.ngay,
    required this.gio,
    required this.phong,
    required this.trangThai,
  });
}

// =================== DỮ LIỆU MẪU ===================
final List<DiemDanhBuoiHocChiTiet> diemDanhChiTietMau = [
  DiemDanhBuoiHocChiTiet(
    monHoc: "Lập trình Android",
    lop: "64KTPM.NB",
    ngay: DateTime(2025, 10, 1),
    gio: DateTime(2025, 10, 1, 7, 5), // giờ điểm danh thực tế
    phong: "325 - A2",
    trangThai: "đúng giờ",
  ),
  DiemDanhBuoiHocChiTiet(
    monHoc: "Lập trình Android",
    lop: "64KTPM.NB",
    ngay: DateTime(2025, 10, 3),
    gio: DateTime(2025, 10, 3, 7, 10),
    phong: "325 - A2",
    trangThai: "Đi muộn",
  ),
  DiemDanhBuoiHocChiTiet(
    monHoc: "Lập trình Android",
    lop: "64KTPM.NB",
    ngay: DateTime(2025, 10, 5),
    gio: DateTime(2025, 10, 5, 7, 0),
    phong: "325 - A2",
    trangThai: "Đúng giờ",
  ),
  DiemDanhBuoiHocChiTiet(
    monHoc: "Lập trình Android",
    lop: "64KTPM.NB",
    ngay: DateTime(2025, 10, 8),
    gio: DateTime(2025, 10, 8, 7, 2),
    phong: "325 - A2",
    trangThai: "Vắng",
  ),
  // ... bạn có thể thêm nhiều buổi khác
];
