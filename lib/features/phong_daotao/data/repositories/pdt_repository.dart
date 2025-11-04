import '../datasources/pdt_api.dart';
import '../models/dashboard_stats_model.dart';

class PdtRepository {
  final PdtApi api = PdtApi();

  Future<DashboardStats> getStats() => api.fetchDashboardStats();

  Future<List<Map<String, dynamic>>> getBuoiHoc() => api.fetchBuoiHoc();
}
