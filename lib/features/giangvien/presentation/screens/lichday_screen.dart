import 'package:flutter/material.dart';
import '../../data/models/buoihoc_model.dart';
import '../../gv_routes.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../widgets/gv_side_menu.dart';

// ===== Hàm helper hiển thị thứ =====
String getThu(DateTime? ngay) {
  if (ngay == null) return "-";
  switch (ngay.weekday) {
    case DateTime.monday:
      return "T2";
    case DateTime.tuesday:
      return "T3";
    case DateTime.wednesday:
      return "T4";
    case DateTime.thursday:
      return "T5";
    case DateTime.friday:
      return "T6";
    case DateTime.saturday:
      return "T7";
    case DateTime.sunday:
      return "CN";
    default:
      return "-";
  }
}

class LichDayScreen extends StatefulWidget {
  final String giangVienId;

  const LichDayScreen({super.key, required this.giangVienId});

  @override
  State<LichDayScreen> createState() => _LichDayScreenState();
}

class _LichDayScreenState extends State<LichDayScreen> {
  final int _currentIndex = 1; // Lịch dạy
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedTerm = 'Kì 1';
  String selectedYear = '';
  String selectedWeek = 'Tuần 1';

  late List<String> years;
  final List<String> terms = ['Kì 1', 'Kì 2'];
  final List<String> weeks = List.generate(10, (index) => 'Tuần ${index + 1}');
  DateTime selectedDate = DateTime.now();

  late List<BuoiHoc> lichDayHomNay;
  List<BuoiHoc> displayedBuoiHoc = [];
  bool isFilteringByDate = true;

  @override
  void initState() {
    super.initState();
    final currentYear = DateTime.now().year;
    years = [for (int start = 2020; start <= currentYear; start++) '$start-${start + 1}'];
    selectedYear = years.last;

    lichDayHomNay = BuoiHoc.buoiHocMau;
    filterByDate(selectedDate);
  }

  void filterByDate(DateTime date) {
    isFilteringByDate = true;
    displayedBuoiHoc = lichDayHomNay
        .where((b) =>
    parseNgay(b.ngay)?.year == date.year &&
        parseNgay(b.ngay)?.month == date.month &&
        parseNgay(b.ngay)?.day == date.day)
        .toList();
    setState(() => selectedDate = date);
  }

  void filterByTermYearWeek() {
    isFilteringByDate = false;
    displayedBuoiHoc = lichDayHomNay
        .where((b) =>
    b.ki == selectedTerm &&
        b.namHoc == selectedYear &&
        b.tuan == selectedWeek)
        .toList();

    if (displayedBuoiHoc.isNotEmpty) {
      final firstBuoi = parseNgay(displayedBuoiHoc.first.ngay)!;
      final startOfWeek = getStartOfWeek(firstBuoi);
      final endOfWeek = getEndOfWeek(firstBuoi);

      // Highlight hôm nay nếu nằm trong tuần, hoặc ngày đầu tuần
      final now = DateTime.now();
      if (now.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          now.isBefore(endOfWeek.add(const Duration(days: 1)))) {
        selectedDate = now;
      } else {
        selectedDate = startOfWeek;
      }
    }

    setState(() {});
  }

  DateTime? parseNgay(dynamic ngay) {
    if (ngay == null) return null;
    if (ngay is DateTime) return ngay;
    if (ngay is String) {
      try {
        return DateTime.parse(ngay);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Map<DateTime, List<BuoiHoc>> groupBuoiHocByDate(List<BuoiHoc> buoiHocList) {
    final Map<DateTime, List<BuoiHoc>> grouped = {};
    for (var b in buoiHocList) {
      final date = parseNgay(b.ngay);
      if (date == null) continue;
      final key = DateTime(date.year, date.month, date.day);
      if (!grouped.containsKey(key)) grouped[key] = [];
      grouped[key]!.add(b);
    }
    final sortedKeys = grouped.keys.toList()..sort();
    return {for (var k in sortedKeys) k: grouped[k]!};
  }

  DateTime getStartOfWeek(DateTime date) => date.subtract(Duration(days: date.weekday - 1));
  DateTime getEndOfWeek(DateTime date) => getStartOfWeek(date).add(const Duration(days: 6));

  List<DateTime> generateCalendarDays(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final int startWeekday = firstDayOfMonth.weekday % 7;
    final DateTime firstDisplayDay = firstDayOfMonth.subtract(Duration(days: startWeekday));

    return List.generate(28, (i) => firstDisplayDay.add(Duration(days: i)));
  }

  String getWeekRangeFromDate(DateTime anyDateInWeek) {
    final start = getStartOfWeek(anyDateInWeek);
    final end = getEndOfWeek(anyDateInWeek);
    return "Từ ${start.day}/${start.month}/${start.year} đến ${end.day}/${end.month}/${end.year}";
  }

  @override
  Widget build(BuildContext context) {
    final calendarDays = generateCalendarDays(selectedDate);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: GVSideMenu(
        giangVienId: widget.giangVienId,
        onClose: () => Navigator.pop(context),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF154B71),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            const Spacer(),
            const Text(
              'LỊCH DẠY',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Không có thông báo mới")),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // --- Bộ lọc ---
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton(
                  value: selectedTerm,
                  items: terms
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedTerm = v!),
                ),
                DropdownButton(
                  value: selectedYear,
                  items: years
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedYear = v!),
                ),
                DropdownButton(
                  value: selectedWeek,
                  items: weeks
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedWeek = v!),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF154B71)),
                  onPressed: filterByTermYearWeek,
                  child: const Text("Lọc", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),

          // --- Lịch tháng ---
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: calendarDays.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1.2),
              itemBuilder: (context, index) {
                final day = calendarDays[index];
                final isCurrentMonth = day.month == selectedDate.month;
                final isSelected = day.year == selectedDate.year &&
                    day.month == selectedDate.month &&
                    day.day == selectedDate.day;
                return GestureDetector(
                  onTap: () => filterByDate(day),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF154B71) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: isCurrentMonth
                            ? (isSelected ? Colors.white : Colors.black)
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // --- Text "Lịch học" ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  "Lịch học",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF154B71)),
                ),
                const SizedBox(width: 8),
                if (!isFilteringByDate && displayedBuoiHoc.isNotEmpty)
                  Text(
                    getWeekRangeFromDate(parseNgay(displayedBuoiHoc.first.ngay)!),
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.normal),
                  ),
              ],
            ),
          ),

          // --- Danh sách buổi học ---
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF0F0F0), // nền xám
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45), // bo góc trên trái
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: displayedBuoiHoc.isEmpty
                  ? const Center(child: Text("Không có buổi học"))
                  : ListView(
                children: [
                  for (var entry in groupBuoiHocByDate(displayedBuoiHoc).entries)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${entry.key.day}/${entry.key.month}/${entry.key.year}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF154B71),
                            ),
                          ),
                          const SizedBox(height: 4),
                          for (var b in entry.value)
                            Card(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              child: ListTile(
                                leading: const Icon(Icons.book,
                                    color: Color(0xFF154B71)),
                                title: Text(b.tenMon),
                                subtitle: Text(
                                    "${b.phong} | Thứ: ${getThu(parseNgay(b.ngay))} | ${b.thoiGian ?? ''} | Lớp: ${b.lop}"),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const GiangVienBottomNav(currentIndex: 1),
    );
  }
}
