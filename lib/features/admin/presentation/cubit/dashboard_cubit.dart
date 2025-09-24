import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_stats_stream.dart';
import 'dashboard_state.dart';
import 'dart:async';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardStats getDashboardStats;
  final GetDashboardStatsStream getDashboardStatsStream;
  StreamSubscription? _statsSubscription;

  DashboardCubit({
    required this.getDashboardStats,
    required this.getDashboardStatsStream,
  }) : super(DashboardInitial());

  void loadDashboardStats() async {
    emit(DashboardLoading());

    final result = await getDashboardStats();

    result.fold(
      (failure) => emit(DashboardError(message: failure.message)),
      (stats) => emit(DashboardLoaded(stats: stats)),
    );
  }

  void startListeningToStats() {
    _statsSubscription?.cancel();
    _statsSubscription = getDashboardStatsStream().listen(
      (stats) => emit(DashboardLoaded(stats: stats)),
      onError: (error) => emit(DashboardError(message: error.toString())),
    );
  }

  void stopListeningToStats() {
    _statsSubscription?.cancel();
  }

  @override
  Future<void> close() {
    _statsSubscription?.cancel();
    return super.close();
  }
}
