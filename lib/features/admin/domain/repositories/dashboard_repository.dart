// usecases/get_dashboard_stats.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_stats.dart';

abstract class DashboardRepository {
  Future<DashboardStats> getDashboardStats();
  Stream<DashboardStats> getDashboardStatsStream();
}

class GetDashboardStats {
  final DashboardRepository repository;

  GetDashboardStats(this.repository);

  Future<Either<Failure, DashboardStats>> call() async {
    try {
      final stats = await repository.getDashboardStats();
      return Right(stats);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
