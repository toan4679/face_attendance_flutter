import 'package:flutter/material.dart';
import 'chitiet_lichhoc_screen.dart';

// Giả định màu chủ đạo là đen/trắng như trong ảnh
const Color overlayColor = Colors.black;

class StudentScanScreen extends StatelessWidget {
  const StudentScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Đặt màu nền là đen
      backgroundColor: overlayColor,
      appBar: AppBar(
        // Đảm bảo không có elevation (bóng)
        elevation: 0,
        title: const Text("Dashboard", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: overlayColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        // Loại bỏ action settings không có trong ảnh mẫu
        actions: const [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 80), // Tạo khoảng cách từ App Bar

            // Biểu tượng Camera lớn
            const Icon(Icons.photo_camera_outlined, size: 80, color: Colors.white),
            const SizedBox(height: 24),

            // Dòng chữ hướng dẫn
            const Text(
              "Quét QR CODE hoặc FACE SCAN",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 40), // Khoảng cách giữa hướng dẫn và QR Code

            // QR Code Placeholder (Biểu tượng QR màu trắng)
            // Không còn dùng Stack nữa, chỉ dùng Icon đơn thuần
            const Icon(
              Icons.qr_code_2_outlined,
              size: 250,
              color: Colors.white,
            ),

            const SizedBox(height: 30), // Khoảng cách giữa QR Code và nút Rescan

            // Button Rescan (Được đặt xuống dưới)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.25), // Nền xám mờ
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Bo góc lớn
                ),
                elevation: 0,
              ),
              onPressed: () {
                // Giữ nguyên logic chuyển màn hình để kiểm tra
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StudentDetailScreen()),
                );
              },
              icon: const Icon(Icons.autorenew, size: 20),
              label: const Text(
                "Rescan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
