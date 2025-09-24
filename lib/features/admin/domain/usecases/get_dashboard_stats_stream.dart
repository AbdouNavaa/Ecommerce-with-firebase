import '../entities/dashboard_stats.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardStatsStream {
  final DashboardRepository repository;

  GetDashboardStatsStream(this.repository);

  Stream<DashboardStats> call() {
    return repository.getDashboardStatsStream();
  }
}
