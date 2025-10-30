class ApiEndpoints {
  static const login = '/auth/login';
  static const logout = '/auth/logout';
  static const refreshToken = '/auth/refresh';

  // Admin
  static const adminPDT = '/admin/pdt';
  static const adminResetPassword = '/admin/reset-password';

  // Phòng đào tạo
  static const khoa = '/khoa';
  static const boMon = '/bomon';
  static const nganh = '/nganh';
  static const monHoc = '/monhoc';
  static const giangVien = '/giangvien';
  static const sinhVien = '/sinhvien';
  static const lopHocPhan = '/lophocphan';
  static const buoiHoc = '/buoihoc';
  static const dangKyHoc = '/dangkyhoc';
  static const thongBao = '/thongbao';
  static const khuonMat = '/sinhvien/khuonmat';

  // Giảng viên
  static const lichDay = '/giangvien/lichday';
  static const diemDanh = '/buoihoc/{maBuoi}/diemdanh';

  // Sinh viên
  static const lichHoc = '/sinhvien/lichhoc';
  static const checkInQR = '/attendance/check-in/qr';
  static const checkInFace = '/attendance/check-in/face';
}
