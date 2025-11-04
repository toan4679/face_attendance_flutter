import '../models/lop_model.dart';

class LopRepository {
  final List<LopModel> _fakeDb = [
    LopModel(maLop: 'L01', tenLop: 'CNTT K45A', maNganh: 'CNTT', siSo: 35),
    LopModel(maLop: 'L02', tenLop: 'HTTT K45B', maNganh: 'HTTT', siSo: 40),
  ];

  Future<List<LopModel>> fetchLop() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _fakeDb;
  }

  Future<void> addLop(LopModel lop) async {
    _fakeDb.add(lop);
  }

  Future<void> updateLop(LopModel lop) async {
    final index = _fakeDb.indexWhere((l) => l.maLop == lop.maLop);
    if (index != -1) {
      _fakeDb[index] = lop;
    }
  }

  Future<void> deleteLop(String maLop) async {
    _fakeDb.removeWhere((l) => l.maLop == maLop);
  }
}
