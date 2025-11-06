import 'package:flutter/material.dart';

// ===== Model thống kê tổng quan =====
class Stat {
  final String title;
  final String value;
  final IconData icon;

  Stat({
    required this.title,
    required this.value,
    required this.icon,
  });
}

// ===== Dữ liệu mẫu thống kê tổng quan =====
final List<Stat> statData = [
  Stat(title: "Số lớp dạy", value: "8", icon: Icons.class_),
  Stat(title: "Sinh viên", value: "240", icon: Icons.group),
  Stat(title: "Buổi giảng", value: "42", icon: Icons.schedule),
  Stat(title: "Điểm TB", value: "7.9", icon: Icons.bar_chart),
  Stat(title: "Giờ dạy", value: "120h", icon: Icons.access_time),
  Stat(title: "Đề tài dự án", value: "5", icon: Icons.workspace_premium),
  Stat(title: "Kinh nghiệm", value: "8 năm", icon: Icons.school),
];

// ===== Model dữ liệu BarChart =====
class BarChartItem {
  final String label;
  final double value;
  final Color color;

  BarChartItem({
    required this.label,
    required this.value,
    required this.color,
  });
}

// ===== Dữ liệu mẫu BarChart =====
final List<BarChartItem> barChartData = [
  BarChartItem(label: "Lập trình Flutter", value: 8.5, color: Colors.blueAccent),
  BarChartItem(label: "CSDL", value: 7.8, color: Colors.green),
  BarChartItem(label: "Web Frontend", value: 8.2, color: Colors.orange),
  BarChartItem(label: "Dự án phần mềm", value: 7.6, color: Colors.redAccent),
  BarChartItem(label: "Mạng máy tính", value: 7.4, color: Colors.purple),
  BarChartItem(label: "Hệ điều hành", value: 8.0, color: Colors.teal),
  BarChartItem(label: "Phân tích hệ thống", value: 8.1, color: Colors.indigo),
  BarChartItem(label: "AI & ML", value: 8.7, color: Colors.pinkAccent),
];
