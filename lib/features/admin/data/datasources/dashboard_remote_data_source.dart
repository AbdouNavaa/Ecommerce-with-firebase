import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/dashboard_stats_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats();
  Stream<DashboardStatsModel> getDashboardStatsStream();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  // final FirebaseFirestore firestore;

  // DashboardRemoteDataSourceImpl();

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    try {
      // Compter les catégories
      // ...existing code...
      
      // Compter les catégories
      final categoriesSnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .get();
      
      final Set<String> uniqueCategories = categoriesSnapshot.docs
          .map((doc) => doc.data()['productCategory'] as String)
          .toSet();
      
      final categoriesCount = uniqueCategories.length;
      
      // ...existing code...

      // Compter les commandes
      final ordersSnapshot =
          await FirebaseFirestore.instance.collection('Orders').get();
      final ordersCount = ordersSnapshot.docs.length;

      // Compter les produits
      final productsSnapshot =
          await FirebaseFirestore.instance.collection('Products').get();
      final productsCount = productsSnapshot.docs.length;

      return DashboardStatsModel(
        categoriesCount: categoriesCount,
        ordersCount: ordersCount,
        productsCount: productsCount,
      );
    } catch (e) {
      throw Exception('Failed to get dashboard stats: $e');
    }
  }

  @override
  Stream<DashboardStatsModel> getDashboardStatsStream() {
    return Stream.periodic(const Duration(seconds: 30), (_) async {
      return await getDashboardStats();
    }).asyncMap((future) => future);
  }
}
