import 'package:flutter/material.dart';
import '../widgets/giangvien_bottom_nav.dart';
import '../widgets/gv_side_menu.dart';
import '../../data/models/giangvien_model.dart';
import 'edit_profile_form.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.giangVienId});

  final String giangVienId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _currentIndex = 4; // Hồ sơ
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late GiangVien _gv;

  @override
  void initState() {
    super.initState();
    _gv = currentGV; // Lấy dữ liệu hiện tại
  }

  @override
  Widget build(BuildContext context) {
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
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          "HỒ SƠ GIẢNG VIÊN",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(radius: 45, backgroundImage: AssetImage(_gv.avatarPath)),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _openEditProfile(context),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _gv.ten,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              "Giảng viên Khoa ${_gv.khoa}",
              style: const TextStyle(color: Colors.black54, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildInfoSection(
                    title: "Thông tin cá nhân",
                    infoList: [
                      {"label": "Mã giảng viên", "value": _gv.maGV},
                      {"label": "Khoa", "value": _gv.khoa},
                      {"label": "Email", "value": _gv.email},
                      {"label": "SĐT", "value": _gv.sdt},
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildInfoSection(
                    title: "Thông tin chuyên môn",
                    infoList: [
                      {"label": "Học vị", "value": _gv.hocVi},
                      {"label": "Chuyên ngành", "value": _gv.chuyenNganh},
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildInfoSection(
                    title: "Giới thiệu",
                    infoList: [
                      {"label": "", "value": _gv.gioiThieu},
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Xác nhận đăng xuất"),
                      content: const Text("Bạn có chắc chắn muốn đăng xuất không?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Hủy"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (route) => false);
                          },
                          child: const Text("Đăng xuất"),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text(
                  "Đăng xuất",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GiangVienBottomNav(currentIndex: _currentIndex),
    );
  }

  Widget _buildInfoSection({required String title, required List<Map<String, String>> infoList}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          for (var item in infoList)
            if (item["label"]!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    SizedBox(width: 120, child: Text(item["label"]!, style: const TextStyle(color: Colors.black54, fontSize: 13))),
                    Expanded(
                      child: Text(
                        item["value"]!,
                        style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              )
            else
              Text(item["value"]!, style: const TextStyle(color: Colors.black87, height: 1.4)),
        ],
      ),
    );
  }

  void _openEditProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => EditProfileForm(
        gv: _gv,
        onSave: (updatedGV) {
          setState(() {
            _gv = updatedGV;
          });
        },
      ),
    );
  }
}
