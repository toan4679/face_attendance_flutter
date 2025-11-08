import '../datasources/lophocphan_remote_datasource.dart';
import '../models/lophocphan_model.dart';
import '../models/buoihoc_model.dart';

class LopHocPhanRepository {
  final LopHocPhanRemoteDataSource dataSource;

  LopHocPhanRepository(this.dataSource);

  // 🔹 Nhận maGV là int
  Future<List<LopHocPhan>> getLopHocPhan(int maGV) async {
    return await dataSource.fetchLopHocPhan(maGV);
  }

  Future<List<BuoiHoc>> getLichDayHomNay(int maGV) async {
    return await dataSource.getLichDayHomNay(maGV);
  }
}
