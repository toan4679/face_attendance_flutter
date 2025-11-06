import '../datasources/lophocphan_remote_datasource.dart';
import '../models/lophocphan_model.dart';

class LopHocPhanRepository {
  final LopHocPhanRemoteDataSource dataSource;

  LopHocPhanRepository(this.dataSource);

  Future<List<LopHocPhan>> getLopHocPhan() async {
    return await dataSource.fetchLopHocPhan();
  }
}
