class AuthUser {
  final int id;
  final String hoTen;
  final String vaiTro;
  final String token;

  AuthUser({
    required this.id,
    required this.hoTen,
    required this.vaiTro,
    required this.token,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['user']['id'],
      hoTen: json['user']['hoTen'] ?? '',
      vaiTro: json['user']['vaiTro'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
