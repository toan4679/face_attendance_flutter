import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/datasources/buoihoc_api.dart';
import '../../data/repositories/buoihoc_repository.dart';
import '../controllers/buoihoc_controller.dart';

import '../../data/models/lop_hoc_phan_model.dart';
import '../../data/datasources/lophocphan_api.dart';
import '../../data/repositories/lophocphan_repository.dart';

import '../widgets/buoihoc_table.dart';
import '../widgets/buoihoc_form_dialog.dart';
import '../../../../core/network/api_client.dart';
import 'package:dio/dio.dart';

class ManageBuoiHocScreen extends StatefulWidget {
  const ManageBuoiHocScreen({super.key});

  @override
  State<ManageBuoiHocScreen> createState() => _ManageBuoiHocScreenState();
}

class _ManageBuoiHocScreenState extends State<ManageBuoiHocScreen> {
  List<Map<String, dynamic>> monHocList = [];
  List<LopHocPhanModel> lhpAll = [];
  List<LopHocPhanModel> lhpFiltered = [];
  List<Map<String, dynamic>> giangVienList = [];

  int? selectedMaMon;
  int? selectedMaLopHP;
  int? selectedMaGV;

  late final BuoiHocController controller;

  @override
  void initState() {
    super.initState();
    controller = BuoiHocController(repository: BuoiHocRepository(api: BuoiHocApi()));
    _loadMonHoc();
    _loadAllLHP();
    _loadGiangVien();
  }

  Future<void> _loadMonHoc() async {
    try {
      final res = await ApiClient.instance.dio.get('/v1/pdt/monhoc');
      setState(() {
        monHocList = res.data is List
            ? List<Map<String, dynamic>>.from(res.data)
            : List<Map<String, dynamic>>.from(res.data['data'] ?? []);
      });
      print('[DEBUG] ✅ monhoc=${monHocList.length}');
    } catch (e) {
      print('[ERROR] ❌ _loadMonHoc: $e');
    }
  }

  Future<void> _loadAllLHP() async {
    try {
      final repo = LopHocPhanRepository(api: LopHocPhanApi());
      final list = await repo.getAll();
      setState(() => lhpAll = list);
      print('[DEBUG] ✅ LHP all=${lhpAll.length}');
    } catch (e) {
      print('[ERROR] ❌ _loadAllLHP: $e');
    }
  }

  Future<void> _loadGiangVien() async {
    try {
      final res = await ApiClient.instance.dio.get('/v1/pdt/giangvien');
      setState(() {
        giangVienList = res.data is List
            ? List<Map<String, dynamic>>.from(res.data)
            : List<Map<String, dynamic>>.from(res.data['data'] ?? []);
      });
      print('[DEBUG] ✅ giangvien=${giangVienList.length}');
    } catch (e) {
      print('[ERROR] ❌ _loadGiangVien: $e');
    }
  }

  void _onChangeMon(int? maMon) {
    setState(() {
      selectedMaMon = maMon;
      selectedMaLopHP = null;
      controller.selectedMaLopHP = null;
      // Lọc LHP theo tên môn khớp trong danh sách môn học
      lhpFiltered = lhpAll.where((lhp) {
        final mon = monHocList.firstWhere(
              (m) => m['maMon'] == maMon,
          orElse: () => {},
        );
        final tenMon = (mon['tenMon'] ?? '').toString().toLowerCase();
        return (lhp.tenMon ?? '').toLowerCase() == tenMon;
      }).toList();
    });
  }

  Future<void> _onChangeLHP(int? maLopHP) async {
    setState(() {
      selectedMaLopHP = maLopHP;
      controller.selectedMaLopHP = maLopHP;
    });
    if (maLopHP != null) {
      await controller.loadByLopHP(maLopHP);
    } else {
      controller.list = [];
      controller.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<BuoiHocController>(
        builder: (_, c, __) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FC),
            appBar: AppBar(
              title: const Text('Quản lý Buổi học'),
              backgroundColor: Colors.deepPurpleAccent,
            ),
            floatingActionButton: (selectedMaLopHP != null)
                ? FloatingActionButton(
              backgroundColor: Colors.deepPurpleAccent,
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) => BuoiHocFormDialog(
                  maLopHP: selectedMaLopHP!,
                  maGV: selectedMaGV, // gửi kèm nếu đã chọn
                  onSubmit: (body) => c.add(body, ctx),
                ),
              ),
              child: const Icon(Icons.add),
            )
                : null,
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Bộ chọn: Môn / LHP / (tuỳ chọn) Giảng viên
                  Row(children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: selectedMaMon,
                        items: monHocList
                            .map((m) => DropdownMenuItem<int>(
                          value: m['maMon'] as int,
                          child: Text('${m['maSoMon']} - ${m['tenMon']}'),
                        ))
                            .toList(),
                        onChanged: _onChangeMon,
                        decoration: const InputDecoration(
                          labelText: 'Chọn Môn học',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: selectedMaLopHP,
                        items: lhpFiltered
                            .map((l) => DropdownMenuItem<int>(
                          value: l.maLopHP,
                          child: Text('${l.maSoLopHP} (${l.hocKy}-${l.namHoc})'),
                        ))
                            .toList(),
                        onChanged: _onChangeLHP,
                        decoration: const InputDecoration(
                          labelText: 'Chọn Lớp học phần',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: selectedMaGV,
                        items: giangVienList
                            .map((g) => DropdownMenuItem<int>(
                          value: g['maGV'] as int,
                          child: Text(g['hoTen'] ?? 'GV ${g['maGV']}'),
                        ))
                            .toList(),
                        onChanged: (v) => setState(() => selectedMaGV = v),
                        decoration: const InputDecoration(
                          labelText: 'Giảng viên (tuỳ chọn)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3))],
                      ),
                      child: c.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : (selectedMaLopHP == null)
                          ? const Center(child: Text('Hãy chọn Môn học và Lớp học phần để xem lịch.'))
                          : BuoiHocTable(
                        items: c.list,
                        onEdit: (b) => showDialog(
                          context: context,
                          builder: (ctx) => BuoiHocFormDialog(
                            maLopHP: selectedMaLopHP!,
                            maGV: selectedMaGV,
                            buoi: b,
                            onSubmit: (body) => c.update(b.maBuoi, body, ctx),
                          ),
                        ),
                        onDelete: (b) => c.remove(b.maBuoi, context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
