import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/common/helper/navigator/app_navigator.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';
import 'package:flutter_with_firebase/core/resources/app_strings.dart';
import '../../../../core/constants.dart';
import '../pages/admin_orders.dart';
import '../pages/admin_products.dart';

class MyCards extends StatelessWidget {
  final double size;
  const MyCards({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isDark(context);

    final List<Map<String, dynamic>> items = [
      {
        'title': context.tr(AppStrings.products),
        'subtitle': context.tr(AppStrings.manageProducts),
        'icon': Icons.inventory_2_rounded,
        'colors': [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
        'route': () => AppNavigator.push(context, ProductsManagement()),
      },
      {
        'title': context.tr(AppStrings.categories),
        'subtitle': context.tr(AppStrings.manageCategories),
        'icon': Icons.category_rounded,
        'colors': [const Color(0xFFEF4444), const Color(0xFFDC2626)],
        'route': () => Navigator.pushNamed(context, '/categories'),
      },
      {
        'title': context.tr(AppStrings.orders),
        'subtitle': context.tr(AppStrings.manageOrders),
        'icon': Icons.shopping_bag_rounded,
        'colors': [const Color(0xFF10B981), const Color(0xFF059669)],
        'route': () => AppNavigator.push(context, OrdersListPage()),
      },
      {
        'title': context.tr(AppStrings.analytics),
        'subtitle': context.tr(AppStrings.manageAnalytics),
        'icon': Icons.analytics_rounded,
        'colors': [const Color(0xFFF59E0B), const Color(0xFFD97706)],
        'route': () => Navigator.pushNamed(context, '/analytics'),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        // childAspectRatio: size * 0.6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildCard(context, item, isDarkMode);
      },
    );
  }

  Widget _buildCard(
    BuildContext context,
    Map<String, dynamic> item,
    bool isDarkMode,
  ) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: item['route'],
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:
                  isDarkMode
                      ? [const Color(0xFF1E293B), const Color(0xFF334155)]
                      : [Colors.white, const Color(0xFFF8FAFC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background decoration
              Positioned(
                right: -10,
                bottom: -10,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: item['colors']),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: item['colors'][0].withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: item['colors']),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: item['colors'][0].withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(item['icon'], color: Colors.white, size: 24),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['subtitle'],
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
