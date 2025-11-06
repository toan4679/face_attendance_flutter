import 'monhoc_model.dart';
import 'giangvien_model.dart';
import 'sinhvien_model.dart'; // mock sinh viên

class LopHocPhan {
  final int maLopHP;
  final String maSoLopHP;
  final String hocKy;
  final String namHoc;
  final String thongTinLichHoc;
  final MonHoc monHoc;
  final GiangVien giangVien;

  // Mock dữ liệu điểm danh
  final int diemDanhHienTai;
  final int tongSoBuoi;
  final List<SinhVien> danhSachSinhVien;

  LopHocPhan({
    required this.maLopHP,
    required this.maSoLopHP,
    required this.hocKy,
    required this.namHoc,
    required this.thongTinLichHoc,
    required this.monHoc,
    required this.giangVien,
    this.diemDanhHienTai = 0,
    this.tongSoBuoi = 0,
    this.danhSachSinhVien = const [],
  });

  double get tiLeDiemDanh {
    if (tongSoBuoi == 0) return 0;
    return (diemDanhHienTai / tongSoBuoi).clamp(0.0, 1.0);
  }

  factory LopHocPhan.fromJson(Map<String, dynamic> json) {
    return LopHocPhan(
      maLopHP: json['maLopHP'],
      maSoLopHP: json['maSoLopHP'],
      hocKy: json['hocKy'],
      namHoc: json['namHoc'],
      thongTinLichHoc: json['thongTinLichHoc'],
      monHoc: MonHoc.fromJson(json['mon_hoc']),
      giangVien: GiangVien.fromJson(json['giang_vien']),
      diemDanhHienTai: 10, // tạm mock
      tongSoBuoi: 20, // tạm mock
      danhSachSinhVien: danhSachSinhVienMau, // giữ mock sinh viên
    );
  }
}
