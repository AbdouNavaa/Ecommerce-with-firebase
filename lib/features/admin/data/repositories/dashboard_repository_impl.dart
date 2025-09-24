import '../../../../core/error/failures.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DashboardStats> getDashboardStats() async {
    try {
      final result = await remoteDataSource.getDashboardStats();
      return result;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Stream<DashboardStats> getDashboardStatsStream() {
    return remoteDataSource.getDashboardStatsStream();
  }
}
