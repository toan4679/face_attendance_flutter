import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../../data/datasources/buoihoc_api.dart';
import '../../data/repositories/buoihoc_repository.dart';
import '../controllers/buoihoc_controller.dart';

import '../../data/models/lop_hoc_phan_model.dart';
import '../../data/datasources/lophocphan_api.dart';
import '../../data/repositories/lophocphan_repository.dart';

import '../widgets/buoihoc_table.dart';
import '../widgets/buoihoc_form_dialog.dart';
import '../../../../core/network/api_client.dart';

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

  // ========================== LOAD DATA ==========================
  Future<void> _loadMonHoc() async {
    try {
      final res = await ApiClient.instance.dio.get('/v1/pdt/monhoc');
      setState(() {
        monHocList = res.data is List
            ? List<Map<String, dynamic>>.from(res.data)
            : List<Map<String, dynamic>>.from(res.data['data'] ?? []);
      });
      debugPrint('[DEBUG] ✅ monhoc=${monHocList.length}');
    } catch (e) {
      debugPrint('[ERROR] ❌ _loadMonHoc: $e');
    }
  }

  Future<void> _loadAllLHP() async {
    try {
      final repo = LopHocPhanRepository(api: LopHocPhanApi());
      final list = await repo.getAll();
      setState(() => lhpAll = list);
      debugPrint('[DEBUG] ✅ LHP all=${lhpAll.length}');
    } catch (e) {
      debugPrint('[ERROR] ❌ _loadAllLHP: $e');
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
      debugPrint('[DEBUG] ✅ giangvien=${giangVienList.length}');
    } catch (e) {
      debugPrint('[ERROR] ❌ _loadGiangVien: $e');
    }
  }

  // ========================== FILTER ==========================
  void _onChangeMon(int? maMon) {
    setState(() {
      selectedMaMon = maMon;
      selectedMaLopHP = null;
      controller.selectedMaLopHP = null;

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

  // ========================== BUILD ==========================
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

            // ========================== Nút thêm buổi học ==========================
            floatingActionButton: (selectedMaLopHP != null)
                ? FloatingActionButton(
              backgroundColor: Colors.deepPurpleAccent,
              tooltip: 'Thêm buổi học',
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) => BuoiHocFormDialog(
                  maLopHP: selectedMaLopHP!,
                  maGV: selectedMaGV,
                  onSubmit: (listBuoi) async {
                    // ✅ listBuoi là List<Map<String, dynamic>>
                    await c.addMultiple(listBuoi, ctx);
                    await controller.loadByLopHP(selectedMaLopHP!);
                  },
                ),
              ),
              child: const Icon(Icons.add),
            )
                : null,

            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ========================== Bộ chọn Môn / LHP / GV ==========================
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

                  // ========================== Bảng buổi học ==========================
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: c.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : (selectedMaLopHP == null)
                          ? const Center(
                        child: Text(
                          'Hãy chọn Môn học và Lớp học phần để xem lịch.',
                        ),
                      )
                          : BuoiHocTable(
                        items: c.list,
                        onEdit: (b) {
                          showDialog(
                            context: context,
                            builder: (_) => BuoiHocFormDialog(
                              maLopHP: selectedMaLopHP!,
                              maGV: selectedMaGV,
                              buoi: b.toJson(),
                              onSubmit: (listBuoi) async {
                                if (listBuoi.isNotEmpty) {
                                  await controller.update(
                                    b.maBuoi,
                                    listBuoi.first,
                                    context,
                                  );
                                  await controller.loadByLopHP(selectedMaLopHP!);
                                }
                              },
                            ),
                          );
                        },
                        onDelete: (b) async {
                          await c.remove(b.maBuoi, context);
                          await controller.loadByLopHP(selectedMaLopHP!);
                        },
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
