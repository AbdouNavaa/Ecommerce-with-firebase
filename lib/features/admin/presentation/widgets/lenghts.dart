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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size * 0.1,
      width: double.infinity,
      // margin: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardError) {
            return Center(
              child: Text(
                'Erreur: ${state.message}',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            );
          }

          if (state is DashboardLoaded) {
            final stats = state.stats;
            final items = [
              {
                'count': stats.productsCount,
                'label': context.tr(AppStrings.products),
              },
              {
                'count': stats.categoriesCount,
                'label': context.tr(AppStrings.categories),
              },
              {
                'count': stats.ordersCount,
                'label': context.tr(AppStrings.orders),
              },
            ];

            return ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemExtent: size * 0.135,
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isDark(context) ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color:
                            isDark(context)
                                ? Colors.grey.shade900
                                : Colors.grey.shade200,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navigation logic here
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${item['count']}',
                          style: TextStyle(
                            color:
                                isDark(context) ? Colors.white : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${item['label']}',
                          style: TextStyle(
                            color:
                                isDark(context) ? Colors.white : Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
