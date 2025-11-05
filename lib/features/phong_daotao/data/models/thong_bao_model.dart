class ThongBaoModel {
  final String title;       // Tiêu đề thông báo
  final String message;     // Nội dung chi tiết
  final bool isSuccess;     // true = thành công, false = thất bại
  final DateTime time;      // Thời gian tạo thông báo

  ThongBaoModel({
    required this.title,
    required this.message,
    this.isSuccess = true,
    DateTime? time,
  }) : time = time ?? DateTime.now();

  // Tạo từ JSON (nếu backend có trả về thông báo)
  factory ThongBaoModel.fromJson(Map<String, dynamic> json) {
    return ThongBaoModel(
      title: json['title'] ?? 'Thông báo',
      message: json['message'] ?? '',
      isSuccess: json['isSuccess'] ?? true,
      time: DateTime.tryParse(json['time'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'message': message,
    'isSuccess': isSuccess,
    'time': time.toIso8601String(),
  };
}
