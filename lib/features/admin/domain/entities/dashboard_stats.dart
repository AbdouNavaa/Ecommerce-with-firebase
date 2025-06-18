// entities/dashboard_stats.dart
class DashboardStats {
  final int categoriesCount;
  final int ordersCount;
  final int productsCount;

  const DashboardStats({
    required this.categoriesCount,
    required this.ordersCount,
    required this.productsCount,
  });

  DashboardStats copyWith({
    int? categoriesCount,
    int? ordersCount,
    int? productsCount,
  }) {
    return DashboardStats(
      categoriesCount: categoriesCount ?? this.categoriesCount,
      ordersCount: ordersCount ?? this.ordersCount,
      productsCount: productsCount ?? this.productsCount,
    );
  }
}
