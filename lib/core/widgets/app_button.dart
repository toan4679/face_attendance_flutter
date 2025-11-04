// import 'package:flutter/material.dart';
// import '../constants/app_colors.dart';
//
// class AppButton extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed;
//   final bool isLoading;
//
//   const AppButton({
//     super.key,
//     required this.text,
//     this.onPressed,
//     this.isLoading = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: isLoading ? null : onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.primary,
//         minimumSize: const Size(double.infinity, 48),
//       ),
//       child: isLoading
//           ? const SizedBox(
//           height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
//           : Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
//     );
//   }
// }
