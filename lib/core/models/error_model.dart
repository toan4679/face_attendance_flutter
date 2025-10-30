class ErrorModel {
  final String code;
  final String message;

  ErrorModel({
    required this.code,
    required this.message,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      code: json['error']?['code'] ?? 'UNKNOWN_ERROR',
      message: json['error']?['message'] ?? 'Lỗi không xác định',
    );
  }
}
