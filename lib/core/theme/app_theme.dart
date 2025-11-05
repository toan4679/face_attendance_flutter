import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Colors.deepPurpleAccent;
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.deepPurple,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white, // ✅ chữ trắng cho tất cả ElevatedButton
        textStyle: const TextStyle(fontWeight: FontWeight.normal),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
  );
}
