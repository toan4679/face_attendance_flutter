class ApiConstants {
  static const String baseUrl = "http://104.145.210.69/api";

  // Auth
  static const String register = "$baseUrl/register";
  static const String login = "$baseUrl/login";
  static const String logout = "$baseUrl/logout";

  // User
  static const String currentUser = "$baseUrl/users/me";
  static const String users = "$baseUrl/users";

  // Face
  static const String storeFace = "$baseUrl/faces/store";
  static const String verifyFace = "$baseUrl/faces/verify";

  // Attendance
  static const String checkIn = "$baseUrl/attendance/checkin";
  static const String history = "$baseUrl/attendance/history";

  // QR
  static const String generateQR = "$baseUrl/qrcode/generate";
  static const String verifyQR = "$baseUrl/qrcode/verify";

  // Reports
  static const String reportSummary = "$baseUrl/report/summary";
}
