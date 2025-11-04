// import 'package:flutter/material.dart';
// import '../data/auth_repository.dart';
// import '../data/auth_model.dart';
//
// class AuthProvider with ChangeNotifier {
//   final AuthRepository repository;
//   AuthProvider(this.repository);
//
//   AuthUser? currentUser;
//   bool isLoading = false;
//   String? error;
//
//   Future<bool> login(String email, String password, String loai) async {
//     try {
//       isLoading = true;
//       notifyListeners();
//
//       currentUser = await repository.login(email, password, loai);
//       error = null;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       error = e.toString();
//       notifyListeners();
//       return false;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<bool> register(String email, String password, String hoTen, String loai) async {
//     try {
//       isLoading = true;
//       notifyListeners();
//
//       await repository.register(email, password, hoTen, loai);
//       error = null;
//       return true;
//     } catch (e) {
//       error = e.toString();
//       return false;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<void> logout() async {
//     await repository.logout();
//     currentUser = null;
//     notifyListeners();
//   }
// }
