import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';
import 'package:flutter_with_firebase/core/resources/app_strings.dart';
import '../../../../core/constants.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../../../../service_locator.dart' as di;

class Lengths extends StatelessWidget {
  final double size;

  const Lengths({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<DashboardCubit>()..loadDashboardStats(),
      child: LengthsView(size: size),
    );
  }
}

class LengthsView extends StatelessWidget {
  final double size;

  const LengthsView({super.key, required this.size});

  List<Map<String, dynamic>> _getStatsItems(
    BuildContext context,
    dynamic stats,
  ) {
    return [
      {
        'count': stats.productsCount,
        'label': context.tr(AppStrings.products),
        'icon': Icons.inventory_2_rounded,
        'colors': [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
      },
      {
        'count': stats.categoriesCount,
        'label': context.tr(AppStrings.categories),
        'icon': Icons.category_rounded,
        'colors': [const Color(0xFF10B981), const Color(0xFF059669)],
      },
      {
        'count': stats.ordersCount,
        'label': context.tr(AppStrings.orders),
        'icon': Icons.shopping_bag_rounded,
        'colors': [const Color(0xFFEF4444), const Color(0xFFDC2626)],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isDark(context);

    return Container(
      height: size * 0.315,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return _buildLoadingState();
          }
          if (state is DashboardError) {
            return _buildErrorState(state.message);
          }
          if (state is DashboardLoaded) {
            return _buildStatsCards(context, state, isDarkMode);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 32),
          const SizedBox(height: 8),
          Text(
            'Error loading stats',
            style: TextStyle(color: Colors.red.shade700, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(
    BuildContext context,
    DashboardLoaded state,
    bool isDarkMode,
  ) {
    final items = _getStatsItems(context, state.stats);

    return Row(
      children:
          items
              .map(
                (item) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors:
                            isDarkMode
                                ? [
                                  const Color(0xFF1E293B),
                                  const Color(0xFF334155),
                                ]
                                : [Colors.white, const Color(0xFFF8FAFC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            isDarkMode ? 0.3 : 0.1,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: item['colors']),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            item['icon'],
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TweenAnimationBuilder<int>(
                          tween: IntTween(begin: 0, end: item['count']),
                          duration: const Duration(milliseconds: 1000),
                          builder: (context, value, child) {
                            return Text(
                              '$value',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    isDarkMode
                                        ? Colors.white
                                        : Colors.grey[900],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['label'],
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}
