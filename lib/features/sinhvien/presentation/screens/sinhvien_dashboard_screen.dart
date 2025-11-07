import 'package:flutter/material.dart';
import '../../data/datasources/sinhvien_api.dart';
import '../../data/models/class_schedule_model.dart';
import 'Scan_Class_Screen.dart';
import 'sinhvien_profile_screen.dart'; // ✅ import thêm

class SinhVienDashboardScreen extends StatefulWidget {
  const SinhVienDashboardScreen({super.key});

  @override
  State<SinhVienDashboardScreen> createState() => _SinhVienDashboardScreenState();
}

class _SinhVienDashboardScreenState extends State<SinhVienDashboardScreen> {
  final SinhVienApi _api = SinhVienApi();
  List<ClassSchedule> _allClasses = [];
  List<ClassSchedule> _displayedClasses = [];
  bool _isLoading = true;
  String _filter = "Tất cả";
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      final data = await _api.fetchDashboard();
      setState(() {
        _allClasses = data;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ [DEBUG] Lỗi tải dashboard: $e");
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      _displayedClasses = _allClasses.where((c) {
        if (c.ngayHoc != null && c.ngayHoc!.isNotEmpty) {
          final classDate = DateTime.parse(c.ngayHoc!);
          if (classDate.year != _selectedDate.year ||
              classDate.month != _selectedDate.month ||
              classDate.day != _selectedDate.day) return false;
        }

        if (_filter == "Có mặt") {
          return c.trangThai.toLowerCase().contains("có mặt") ||
              c.trangThai.toLowerCase() == "present";
        } else if (_filter == "Vắng") {
          return c.trangThai.toLowerCase().contains("vắng") ||
              c.trangThai.toLowerCase() == "absent";
        }
        return true;
      }).toList();
    });
  }

  bool _isInSession(ClassSchedule c) {
    try {
      final now = TimeOfDay.now();
      final startParts = c.gioBatDau.split(':').map(int.parse).toList();
      final endParts = c.gioKetThuc.split(':').map(int.parse).toList();

      final start = TimeOfDay(hour: startParts[0], minute: startParts[1]);
      final end = TimeOfDay(hour: endParts[0], minute: endParts[1]);

      final nowMinutes = now.hour * 60 + now.minute;
      final startMinutes = start.hour * 60 + start.minute;
      final endMinutes = end.hour * 60 + end.minute;

      return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF6C63FF);
    const Color lightCardBackground = Color(0xFFF7F7F7);
    const double navIconSize = 28;

    final now = DateTime.now();
    final List<DateTime> weekDays = List.generate(7, (i) {
      DateTime monday = now.subtract(Duration(days: now.weekday - 1));
      return monday.add(Duration(days: i));
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Lịch học hôm nay",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Icon(Icons.notifications_none, size: navIconSize, color: Colors.black87),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- Thanh chọn ngày ---
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: weekDays.map((day) {
                        bool isSelected = _selectedDate.day == day.day &&
                            _selectedDate.month == day.month &&
                            _selectedDate.year == day.year;
                        final isToday = now.day == day.day &&
                            now.month == day.month &&
                            now.year == day.year;

                        Color bgColor = isSelected ? primaryColor : Colors.grey.shade200;
                        Color textColor = isSelected ? Colors.white : Colors.black87;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = day;
                              _applyFilters();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: _dateCard(
                              _getMonthVN(day.month),
                              day.day.toString().padLeft(2, '0'),
                              _getWeekVN(day.weekday, isToday),
                              bgColor,
                              textColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- Bộ lọc ---
                  Row(
                    children: [
                      Expanded(
                        child: _choiceChip("Tất cả", _filter == "Tất cả", primaryColor, () {
                          _filter = "Tất cả";
                          _applyFilters();
                        }),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _choiceChip("Có mặt", _filter == "Có mặt", primaryColor, () {
                          _filter = "Có mặt";
                          _applyFilters();
                        }),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _choiceChip("Vắng", _filter == "Vắng", primaryColor, () {
                          _filter = "Vắng";
                          _applyFilters();
                        }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- Danh sách buổi học ---
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _displayedClasses.isEmpty
                        ? const Center(child: Text("Không có lớp học trong ngày này."))
                        : ListView.builder(
                      itemCount: _displayedClasses.length,
                      itemBuilder: (context, index) {
                        final c = _displayedClasses[index];
                        final bool inSession = _isInSession(c);

                        Color statusColor;
                        switch (c.trangThai.toLowerCase()) {
                          case "present":
                          case "có mặt":
                            statusColor = Colors.green;
                            break;
                          case "absent":
                          case "vắng":
                            statusColor = Colors.red;
                            break;
                          case "late":
                          case "đi muộn":
                            statusColor = const Color(0xFF8B5CF6);
                            break;
                          default:
                            statusColor = Colors.grey;
                        }

                        return _subjectCard(
                          c.monHoc,
                          c.phongHoc,
                          "${c.gioBatDau} - ${c.gioKetThuc}",
                          inSession ? "Đang trong tiết" : c.trangThai,
                          inSession ? primaryColor : statusColor,
                          inSession,
                          lightCardBackground,
                          inSession,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // --- Thanh menu dưới cùng ---
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
                  Container(
                    height: 65,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // 🏠 Home icon
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(15)),
                          child: const Icon(Icons.home, color: Colors.white, size: navIconSize),
                        ),
                        const SizedBox(width: 80),

                        // 👤 Profile icon (➡ điều hướng)
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SinhVienProfileScreen()),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            child: Icon(Icons.person, color: Colors.grey.shade600, size: navIconSize),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Nút camera ở giữa
                  Positioned(
                    top: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const StudentScanScreen()),
                        );
                      },
                      child: Container(
                        width: 65,
                        height: 65,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
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

  // ---------- Helpers ----------
  Widget _dateCard(String month, String day, String week, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      width: 70,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          Text(month, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 13)),
          const SizedBox(height: 4),
          Text(day, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 4),
          Text(week, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 13)),
        ],
      ),
    );
  }

  Widget _choiceChip(String label, bool selected, Color primaryColor, VoidCallback onTap) {
    const Color lightPurple = Color(0xFFEEEAFF);
    final Color backgroundColor = selected ? primaryColor : lightPurple;
    final Color labelColor = selected ? Colors.white : primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(24)),
        child: Text(label, style: TextStyle(color: labelColor, fontWeight: FontWeight.w600, fontSize: 16)),
      ),
    );
  }

  Widget _subjectCard(String title, String room, String time, String status, Color statusColor, bool isSelected,
      Color unselectedBgColor, bool showCamera) {
    final Color cardBgColor = isSelected ? statusColor : unselectedBgColor;
    final Color titleColor = isSelected ? Colors.white : Colors.black87;
    final Color subtitleColor = isSelected ? Colors.white70 : Colors.black54;

    Widget statusBadge = Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(color: statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
      child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12)),
    );

    if (isSelected && showCamera) {
      statusBadge = Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.w600, fontSize: 12)),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: titleColor)),
          const SizedBox(height: 6),
          Text(room, style: TextStyle(color: subtitleColor, fontSize: 14)),
          const SizedBox(height: 8),
          Row(children: [
            Icon(Icons.access_time, size: 16, color: subtitleColor),
            const SizedBox(width: 6),
            Text(time, style: TextStyle(color: subtitleColor, fontSize: 14)),
          ]),
        ]),
        statusBadge,
      ]),
    );
  }

  String _getMonthVN(int month) {
    const months = ['Th01', 'Th02', 'Th03', 'Th04', 'Th05', 'Th06', 'Th07', 'Th08', 'Th09', 'Th10', 'Th11', 'Th12'];
    return months[month - 1];
  }

  String _getWeekVN(int weekday, bool isToday) {
    const days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    final text = days[weekday - 1];
    return isToday ? '$text ' : text;
  }
}
