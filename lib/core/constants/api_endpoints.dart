class ApiEndpoints {
  // ================== BASE ==================
  static const String baseUrl = 'http://104.145.210.69/api/v1';

  // ================== AUTH ==================
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String logout = '$baseUrl/auth/logout';
  static const String refresh = '$baseUrl/auth/refresh';
  static const String changePassword = '$baseUrl/auth/change-password';

  // ================== ADMIN ==================
  static const String adminPdt = '$baseUrl/admin/pdt';
  static const String adminResetPassword = '$baseUrl/admin/reset-password';

  // ================== PHÒNG ĐÀO TẠO ==================
  static const String pdtDashboardStats = '$baseUrl/pdt/dashboard/stats';
  static const String pdtKhoa = '$baseUrl/pdt/khoa';
  static const String pdtBoMon = '$baseUrl/pdt/bomon';
  static const String pdtNganh = '$baseUrl/pdt/nganh';
  static const String pdtMonHoc = '$baseUrl/pdt/monhoc';
  static const String pdtLop = '$baseUrl/pdt/lop';
  static const String pdtGiangVien = '$baseUrl/pdt/giangvien';
  static const String pdtSinhVien = '$baseUrl/pdt/sinhvien';
  static const String pdtLopHocPhan = '$baseUrl/pdt/lophocphan';
  static const String pdtBuoiHoc = '$baseUrl/pdt/buoihoc';
  static const String pdtAssignSchedule = '$baseUrl/pdt/schedule/assign';
  static const String pdtThongBao = '$baseUrl/pdt/thongbao';
  static const String pdtKhuonMatPending = '$baseUrl/pdt/khuonmat/pending';
  static const String pdtKhuonMatUpload = '$baseUrl/pdt/khuonmat/upload';

  // ================== GIẢNG VIÊN ==================
  static const String gvLichDay = '$baseUrl/giangvien/lichday';
  static const String gvLopHocPhan = '$baseUrl/giangvien/lophocphan';
  static const String gvDiemDanh = '$baseUrl/giangvien/diemdanh';
  static const String gvGenerateQR = '$baseUrl/giangvien/buoihoc'; // + /{maBuoi}/qr
  static const String gvCloseQR = '$baseUrl/giangvien/buoihoc';    // + /{maBuoi}/close

  // ================== SINH VIÊN ==================
  static const String svLichHoc = '$baseUrl/sinhvien/lichhoc';
  static const String svDiemDanh = '$baseUrl/sinhvien/diemdanh';
  static const String svCheckInQR = '$baseUrl/sinhvien/attendance/check-in/qr';
  static const String svCheckInFace = '$baseUrl/sinhvien/attendance/check-in/face';
  static const String svKhuonMat = '$baseUrl/sinhvien/khuonmat';

  // ================== TEST & DEBUG ==================
  static const String test = '$baseUrl/test';
}
