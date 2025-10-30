class UserModel {
  final int id;
  final String hoTen;
  final String vaiTro;
  final String? email;
  final String? token;

  UserModel({
    required this.id,
    required this.hoTen,
    required this.vaiTro,
    this.email,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      hoTen: json['hoTen'] ?? '',
      vaiTro: json['vaiTro'] ?? '',
      email: json['email'],
      token: json['token'],
    );
  }
}
