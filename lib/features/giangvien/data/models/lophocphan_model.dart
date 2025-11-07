import 'monhoc_model.dart';
import 'giangvien_model.dart';
import 'sinhvien_model.dart'; // model SinhVien

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

  final List<SinhVien> danhSachSinhVien; // từ database
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
      maLopHP: json['maLopHP'],
      maSoLopHP: json['maSoLopHP'],
      hocKy: json['hocKy'],
      namHoc: json['namHoc'],
      thongTinLichHoc: json['thongTinLopHoc'],
      ngayBatDau: DateTime.parse(json['ngayBatDau']),
      ngayKetThuc: DateTime.parse(json['ngayKetThuc']),
      monHoc: monHoc,
      giangVien: giangVien,
      danhSachSinhVien: sinhVienList,
      diemDanhHienTai: json['diemDanhHienTai'] ?? 0,
      tongSoBuoi: json['tongSoBuoi'] ?? 0,
    );
  }

}
