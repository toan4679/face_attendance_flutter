import 'monhoc_model.dart';
import 'giangvien_model.dart';
import 'sinhvien_model.dart';

class LopHocPhan {
  final int maLopHP;
  final String maSoLopHP;
  final String hocKy;
  final String namHoc;
  final String thongTinLichHoc;
  final DateTime ngayBatDau;
  final DateTime ngayKetThuc;
  final MonHoc monHoc;
  final GiangVien giangVien;

  final List<SinhVien> danhSachSinhVien;
  final int diemDanhHienTai;
  final int tongSoBuoi;

  LopHocPhan({
    required this.maLopHP,
    required this.maSoLopHP,
    required this.hocKy,
    required this.namHoc,
    required this.thongTinLichHoc,
    required this.ngayBatDau,
    required this.ngayKetThuc,
    required this.monHoc,
    required this.giangVien,
    required this.danhSachSinhVien,
    this.diemDanhHienTai = 0,
    this.tongSoBuoi = 0,
  });

  double get tiLeDiemDanh {
    if (tongSoBuoi == 0) return 0;
    return (diemDanhHienTai / tongSoBuoi).clamp(0.0, 1.0);
  }

  factory LopHocPhan.fromJson(Map<String, dynamic> json,
      {required List<SinhVien> sinhVienList,
        required MonHoc monHoc,
        required GiangVien giangVien}) {
    return LopHocPhan(
      maLopHP: json['maLopHP'] as int? ?? 0,
      maSoLopHP: json['maSoLopHP'] as String? ?? '',
      hocKy: json['hocKy'] as String? ?? '',
      namHoc: json['namHoc'] as String? ?? '',
      thongTinLichHoc: json['thongTinLopHoc'] as String? ?? '',
      ngayBatDau: json['ngayBatDau'] != null
          ? DateTime.parse(json['ngayBatDau'] as String)
          : DateTime.now(),
      ngayKetThuc: json['ngayKetThuc'] != null
          ? DateTime.parse(json['ngayKetThuc'] as String)
          : DateTime.now(),
      monHoc: monHoc,
      giangVien: giangVien,
      danhSachSinhVien: sinhVienList,
      diemDanhHienTai: json['diemDanhHienTai'] as int? ?? 0,
      tongSoBuoi: json['tongSoBuoi'] as int? ?? 0,
    );
  }
}