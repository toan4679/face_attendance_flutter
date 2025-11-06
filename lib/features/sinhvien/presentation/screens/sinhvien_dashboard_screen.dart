import 'package:flutter/material.dart';
import 'Scan_Class_Screen.dart';

class SinhVienDashboardScreen extends StatelessWidget {
  const SinhVienDashboardScreen({super.key});

  final List<Map<String, String>> _sampleDates = const [
    {"month": "May", "day": "23", "week": "Fri", "selected": "false"},
    {"month": "Sep", "day": "23", "week": "Fri", "selected": "true"}, // Ngày được chọn
    {"month": "Oct", "day": "01", "week": "Sun", "selected": "false"},
    {"month": "Oct", "day": "02", "week": "Mon", "selected": "false"},
    {"month": "Oct", "day": "03", "week": "Tue", "selected": "false"},
    {"month": "Oct", "day": "04", "week": "Wed", "selected": "false"},
    {"month": "Oct", "day": "05", "week": "Thu", "selected": "false"},
  ];

  @override
  Widget build(BuildContext context) {
    // Primary color: The purple used in the image
    const Color primaryColor = Color(0xFF6C63FF);
    // Light color: The pale purple used for unselected chips and other light elements
    const Color lightPurple = Color(0xFFEEEAFF);
    // Light Gray Background color for unselected cards
    const Color lightCardBackground = Color(0xFFF7F7F7);
    // Icon size for bottom navigation
    const double navIconSize = 28;

    return Scaffold(
      backgroundColor: Colors.white,

      // Use Stack to place the main content and the custom floating bottom bar
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // Header: Title and Bell Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Today's subject",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Icon(Icons.notifications_none, size: navIconSize, color: Colors.black87), // Increased bell size
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- Date Cards (Dùng SingleChildScrollView) ---
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Cho phép cuộn ngang
                    child: Row(
                      children: _sampleDates.map((date) {
                        bool isSelected = date["selected"] == "true";
                        Color bgColor = isSelected ? primaryColor : Colors.grey.shade200;
                        Color textColor = isSelected ? Colors.white : Colors.black54;

                        // Bọc mỗi Date Card trong Padding để tạo khoảng cách giữa chúng
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0), // Khoảng cách giữa các card
                          child: _dateCard(date["month"]!, date["day"]!, date["week"]!, bgColor, textColor),
                        );
                      }).toList(),
                    ),
                  ),
                  // --- KẾT THÚC SỬA ĐỔI ---

                  const SizedBox(height: 24),

                  // --- Filter Chips (SỬA LỖI VỊ TRÍ: Dùng Expanded để căn đều) ---
                  Row(
                    children: [
                      // Chip "All" (Selected)
                      Expanded(
                        child: this._choiceChip("All", true, primaryColor, Colors.white),
                      ),
                      const SizedBox(width: 8), // Khoảng cách giữa các chip

                      // Chip "Present" (Unselected)
                      Expanded(
                        child: this._choiceChip("Present", false, primaryColor, primaryColor),
                      ),
                      const SizedBox(width: 8), // Khoảng cách giữa các chip

                      // Chip "Absent" (Unselected)
                      Expanded(
                        child: this._choiceChip("Absent", false, primaryColor, primaryColor),
                      ),
                    ],
                  ),
                  // --- KẾT THÚC SỬA LỖI VỊ TRÍ ---

                  const SizedBox(height: 24),

                  // Subject Cards List
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero, // Remove default list padding
                      children: [
                        // Card 1: Default (Light Gray background, Green Present badge)
                        _subjectCard("Lập trình Android", "P.305A2", "10:00 AM", "Present", Colors.green, false, lightCardBackground, false),
                        // Card 2: Default (Light Gray background, Red Absent badge)
                        _subjectCard("Học tăng cường", "P.305A2", "10:00 AM", "Absent", Colors.red, false, lightCardBackground, false),
                        // Card 3: Default (Light Gray background, Purple Late badge)
                        _subjectCard("Tư tưởng Hồ Chí Minh", "P.305A2", "10:00 AM", "Late", const Color(0xFF8B5CF6), false, lightCardBackground, false),
                        // Card 4: Selected/Active (Purple background, White text, In session badge, Camera Icon)
                        _subjectCard("Quản trị mạng", "P.305A2", "10:00 AM", "In session", primaryColor, true, primaryColor, true),
                        const SizedBox(height: 100), // Space for floating bottom bar
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Custom Floating Bottom Navigation Bar (Custom implementation to match image)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 90,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background bar (for home and profile icons)
                  Container(
                    height: 65, // Slightly taller bar
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Home Icon Button (Wrapped in a Container to match the "pill" shape in the image)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: primaryColor, // Selected color
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(Icons.home, color: Colors.white, size: navIconSize),
                        ),

                        // Placeholder for the floating camera button
                        const SizedBox(width: 80),

                        // Profile Icon
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: Icon(Icons.person, color: Colors.grey.shade600, size: navIconSize),
                        ),
                      ],
                    ),
                  ),

                  // Floating Scan/Camera Button
                  Positioned(
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to Scan Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const StudentScanScreen()),
                        );
                      },
                      child: Container(
                        width: 65,
                        height: 65,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black, // Black background for the scan button
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 36),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Date Card Widget ---
  Widget _dateCard(String month, String day, String week, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      width: 70, // Fixed width for consistent look
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20), // Large border radius to match image
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(month, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 13)),
          const SizedBox(height: 4),
          Text(
              day,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor
              )
          ),
          const SizedBox(height: 4),
          Text(week, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 13)),
        ],
      ),
    );
  }

  // --- Filter Chip Widget ---
  Widget _choiceChip(String label, bool selected, Color selectedColor, Color textColor) {
    // Light purple color defined locally (0xFFEEEAFF)
    const Color lightPurple = Color(0xFFEEEAFF);

    // Background color: PrimaryColor (purple) if selected, LightPurple if not
    final Color backgroundColor = selected ? selectedColor : lightPurple;

    // Label color: White if selected, PrimaryColor (purple) if not (using textColor parameter here)
    final Color labelColor = selected ? Colors.white : textColor;

    return Container(
      // SỬA ĐỔI: Loại bỏ padding ngang, chỉ giữ padding dọc
      padding: const EdgeInsets.symmetric(vertical: 12),
      // THÊM: Căn giữa chữ trong không gian Expanded
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        // Chỉnh độ bo tròn lớn hơn để giống hình viên thuốc
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: labelColor,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  // --- Subject Card Widget ---
  Widget _subjectCard(String title, String room, String time, String status, Color statusColor, bool isSelected, Color unselectedBgColor, bool showCamera) {

    // Determine the card's background and text color based on selection state
    final Color cardBgColor = isSelected ? statusColor : unselectedBgColor; // Dùng màu xám nhạt cho unselected
    final Color titleColor = isSelected ? Colors.white : Colors.black87;
    final Color subtitleColor = isSelected ? Colors.white70 : Colors.black54;

    // Custom status badge
    Widget statusBadge = const SizedBox.shrink();

    // Standard badge logic for Present/Absent/Late
    if (status == "Present" || status == "Absent" || status == "Late") {
      statusBadge = Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          // Nền màu nhạt (0.15), bo góc
          color: statusColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12), // Tăng độ bo tròn để thành hình viên thuốc (pill-shaped)
        ),
        child: Text(
            status,
            style: TextStyle(
              // Chữ màu đậm (statusColor)
              color: statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            )
        ),
      );
    }

    // Custom design for "In session" card (Card 4)
    if (showCamera) {
      statusBadge = Row(
        children: [
          // Camera icon
          Icon(Icons.camera_alt_outlined, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          // "In session" badge (white background, primary color text)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor, // primaryColor
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        // Shadow only for the active card
        boxShadow: isSelected ? [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ] : [
          // Subtle shadow for unselected cards
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: titleColor)),
              const SizedBox(height: 6),
              Text(room, style: TextStyle(color: subtitleColor, fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: subtitleColor),
                  const SizedBox(width: 6),
                  Text(time, style: TextStyle(color: subtitleColor, fontSize: 14)),
                ],
              ),
            ],
          ),

          // Right side: Status Badge
          statusBadge,
        ],
      ),
    );
  }
}