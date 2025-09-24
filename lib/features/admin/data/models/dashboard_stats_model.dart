import '../../domain/entities/dashboard_stats.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.categoriesCount,
    required super.ordersCount,
    required super.productsCount,
  });

  factory DashboardStatsModel.fromMap(Map<String, dynamic> map) {
    return DashboardStatsModel(
      categoriesCount: map['categoriesCount'] ?? 0,
      ordersCount: map['ordersCount'] ?? 0,
      productsCount: map['productsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoriesCount': categoriesCount,
      'ordersCount': ordersCount,
      'productsCount': productsCount,
    };
  }
}
