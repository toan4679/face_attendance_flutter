import 'sinhvien_model.dart';
import 'chitiet_sv_diemdanh_model.dart';

class BuoiHoc {
  // ===== Thông tin chung =====
  final String tenMon;
  final String lop;
  final String phong;

  // ===== Thông tin điểm danh =====
  final int? diemDanhHienTai;
  final int? tongSoBuoi;

  // ===== Thông tin lịch dạy =====
  final String? thoiGian;
  final DateTime? ngay;
  final String? ki;
  final String? namHoc;
  final String? tuan;

  // ===== Danh sách sinh viên =====
  final List<SinhVien> danhSachSinhVien;

  // ===== Chi tiết điểm danh từng sinh viên =====
  final Map<String, List<DiemDanhBuoiHocChiTiet>> diemDanhChiTietCuaSV;

  BuoiHoc({
    required this.tenMon,
    required this.lop,
    required this.phong,
    this.diemDanhHienTai,
    this.tongSoBuoi,
    this.thoiGian,
    this.ngay,
    this.ki,
    this.namHoc,
    this.tuan,
    this.danhSachSinhVien = const [],
    Map<String, List<DiemDanhBuoiHocChiTiet>>? diemDanhChiTietCuaSV,
  }) : diemDanhChiTietCuaSV = diemDanhChiTietCuaSV ?? {};

  // ===== Getter tỉ lệ điểm danh của lớp =====
  double get tiLeDiemDanh {
    if (diemDanhHienTai == null || tongSoBuoi == null || tongSoBuoi == 0) {
      return 0;
    }
    return (diemDanhHienTai! / tongSoBuoi!).clamp(0.0, 1.0);
  }

  // ===== Getter tỉ lệ điểm danh từng sinh viên =====
  double tiLeDiemDanhCuaSinhVien(SinhVien sv) {
    if (tongSoBuoi == null || tongSoBuoi == 0) return 0;
    return (sv.soBuoiDiemDanh / tongSoBuoi!).clamp(0.0, 1.0);
  }

  // ===== Hàm helper nối chi tiết điểm danh =====
  static List<BuoiHoc> buildWithChiTiet(
      List<BuoiHoc> quanLyLop, List<BuoiHoc> lichDay) {
    return quanLyLop.map((lop) {
      final match = lichDay.firstWhere(
            (b) =>
        b.tenMon == lop.tenMon && b.lop == lop.lop && b.phong == lop.phong,
        orElse: () => BuoiHoc(
          tenMon: lop.tenMon,
          lop: lop.lop,
          phong: lop.phong,
          diemDanhHienTai: lop.diemDanhHienTai,
          tongSoBuoi: lop.tongSoBuoi,
          danhSachSinhVien: lop.danhSachSinhVien,
        ),
      );

      return BuoiHoc(
        tenMon: lop.tenMon,
        lop: lop.lop,
        phong: lop.phong,
        diemDanhHienTai: lop.diemDanhHienTai,
        tongSoBuoi: lop.tongSoBuoi,
        thoiGian: match.thoiGian,
        ngay: match.ngay,
        ki: match.ki,
        namHoc: match.namHoc,
        tuan: match.tuan,
        danhSachSinhVien: lop.danhSachSinhVien,
        diemDanhChiTietCuaSV: match.diemDanhChiTietCuaSV,
      );
    }).toList();
  }

  // =================== DỮ LIỆU BUỔI HỌC MẪU ===================
  static final List<BuoiHoc> buoiHocMau = [
    BuoiHoc(
      tenMon: "Lập trình Flutter",
      lop: "CNTT1",
      phong: "B203",
      diemDanhHienTai: 20,
      tongSoBuoi: 45,
      thoiGian: "07:00 - 09:00",
      ngay: DateTime(2025, 11, 4),
      ki: "Kì 1",
      namHoc: "2025-2026",
      tuan: "Tuần 1",
      danhSachSinhVien: danhSachSinhVienMau
          .where((sv) => sv.lop == "CNTT1")
          .toList(),
      diemDanhChiTietCuaSV: {
        "SV001": danhSachSinhVienMau
            .firstWhere((sv) => sv.ma == "SV001")
            .diemDanhChiTiet,
        "SV002": danhSachSinhVienMau
            .firstWhere((sv) => sv.ma == "SV002")
            .diemDanhChiTiet,
      },
    ),
    BuoiHoc(
      tenMon: "Cơ sở dữ liệu",
      lop: "CNTT2",
      phong: "C101",
      diemDanhHienTai: 12,
      tongSoBuoi: 20,
      thoiGian: "15:00 - 24:00",
      ngay: DateTime(2025, 11, 5),
      ki: "Kì 1",
      namHoc: "2025-2026",
      tuan: "Tuần 1",
      danhSachSinhVien: danhSachSinhVienMau
          .where((sv) => sv.lop == "CNTT2")
          .toList(),
      diemDanhChiTietCuaSV: {
        "SV003": danhSachSinhVienMau
            .firstWhere((sv) => sv.ma == "SV003")
            .diemDanhChiTiet,
        "SV004": danhSachSinhVienMau
            .firstWhere((sv) => sv.ma == "SV004")
            .diemDanhChiTiet,
      },
    ),
  ];
}
