import 'package:flutter/material.dart';
import 'thongbao_screen.dart'; // Giữ nguyên import này

class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors based on the image
    const Color primaryColor = Color(0xFF6C63FF); // Main Purple
    const Color lightPurple = Color(0xFFEEEAFF); // Light Purple for cards
    const Color activeGreen = Color(0xFF4ADE80); // Green for Active/Present
    const Color inactiveRed = Color(0xFFEF4444); // Red for Absent
    const Color grayText = Color(0xFF6B7280); // Gray text color

    return Scaffold(
      backgroundColor: Colors.white,
      // Không dùng AppBar mặc định để tùy chỉnh Header
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Custom Header Section ---
            Container(
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30), // Tăng bo góc
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
              child: Column(
                children: [
                  // Top Row: Avatar, Name, Settings Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Avatar (Simplified using a CircleAvatar and Icon)
                          const CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: primaryColor, size: 30),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Dtoan", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  // Active Dot
                                  const Icon(Icons.circle, color: activeGreen, size: 10),
                                  const SizedBox(width: 4),
                                  Text("Active", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.settings, color: Colors.white, size: 28),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Subject Title
                  const Text(
                    "LẬP TRÌNH ANDROID",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),

                  // Stats Boxes (Room, Time, Active)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _StatBox(icon: Icons.bookmark_border, title: "325-A2", subtitle: "Room", color: Colors.white70),
                      _StatBox(icon: Icons.schedule, title: "50 mins", subtitle: "Time", color: Colors.white70),
                      _StatBox(icon: Icons.people_outline, title: "5", subtitle: "Active", color: Colors.white70),
                    ],
                  ),
                ],
              ),
            ),

            // --- Main Content Area ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rooms Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("ROOMS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: grayText)),
                      Text("View Rooms", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: primaryColor)),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Room Cards
                  Row(
                    children: [
                      // Card 1: 325-A2 Rooms
                      Expanded(
                        child: _DetailCard(
                            title: "325-A2",
                            subtitle: "Rooms",
                            icon: Icons.book_outlined,
                            color: primaryColor,
                            bgColor: lightPurple
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Card 2: 27 Checked-ins
                      Expanded(
                        child: _DetailCard(
                            title: "27",
                            subtitle: "Checked-ins",
                            icon: Icons.people_alt_outlined,
                            color: primaryColor,
                            bgColor: lightPurple
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Recent Log Header
                  const Text("RECENT LOG", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: grayText)),
                  const SizedBox(height: 15),

                  // Log List
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Disable scrolling for ListView inside SingleChildScrollView
                    children: [
                      _LogItem(room: "CL3", date: "05-29-2022", status: "Present", statusColor: activeGreen, borderColor: primaryColor),
                      _LogItem(room: "CL1", date: "06-29-2022", status: "Present", statusColor: activeGreen, borderColor: activeGreen),
                      _LogItem(room: "CL5", date: "05-29-2022", status: "Present", statusColor: activeGreen, borderColor: Color(0xFF06B6D4)), // Cyan border
                      _LogItem(room: "CL1", date: "06-29-2022", status: "Absent", statusColor: inactiveRed, borderColor: inactiveRed),
                      _LogItem(room: "CL3", date: "05-29-2022", status: "Absent", statusColor: inactiveRed, borderColor: primaryColor),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Action Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Tăng bo góc
                      minimumSize: const Size(double.infinity, 55), // Tăng chiều cao
                      elevation: 5,
                      shadowColor: primaryColor.withOpacity(0.5),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const StudentSuccessScreen()),
                      );
                    },
                    child: const Text("Điểm danh", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for the stats inside the purple header
class _StatBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _StatBox({required this.icon, required this.title, required this.subtitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: TextStyle(color: color.withOpacity(0.8), fontSize: 13)),
      ],
    );
  }
}

// Widget for the large detail cards (325-A2 and 27 Checked-ins)
class _DetailCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _DetailCard({required this.title, required this.subtitle, required this.icon, required this.color, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Height matching the image proportions
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: color, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget for each log entry
class _LogItem extends StatelessWidget {
  final String room;
  final String date;
  final String status;
  final Color statusColor;
  final Color borderColor;

  const _LogItem({required this.room, required this.date, required this.status, required this.statusColor, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Border trái màu sắc như trong ảnh
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Room and Date
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 50, // Cố định chiều rộng cho Room
                  child: Text(room, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                ),
                const SizedBox(width: 20),
                Text(date, style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280))), // Gray date
              ],
            ),
          ),

          // Right side: Status
          Row(
            children: [
              Icon(Icons.access_time_filled, size: 18, color: statusColor),
              const SizedBox(width: 8),
              Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 15)),
            ],
          ),
        ],
      ),
    );
  }
}
