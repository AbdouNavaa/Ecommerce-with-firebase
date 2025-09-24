import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';
import 'package:flutter_with_firebase/widgets/custom_bottom_nav.dart';
import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../../core/configs/theme/theme_cubit.dart';
import '../../../../core/constants.dart';
import 'package:flutter/material.dart';
import '../../../../core/resources/app_strings.dart';
import '../../../../main.dart';
import '../../../settings/bloc/orders_display_cubit.dart';
import '../../../settings/bloc/orders_display_state.dart';
import '../widgets/lenghts.dart';
import '../widgets/my_cards.dart';
import '../widgets/order_card.dart';
import 'admin_orders.dart';

class AdminHome extends StatefulWidget {
  static String id = 'AdminHome';

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _bottomBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = isDark(context);
    
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: _buildAppBar(context, isDarkMode),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(context, isDarkMode),
            const SizedBox(height: 24),
            Lengths(size: size.width),
            const SizedBox(height: 24),
            MyCards(size: size.height),
            const SizedBox(height: 24),
            _buildRecentOrders(context, isDarkMode),
            const SizedBox(height: 100), // Bottom padding for nav
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _bottomBarIndex,
        onTap: (index) => setState(() => _bottomBarIndex = index),
        isAdmin: true,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDarkMode) {
    return BasicAppbar(
      backgroundColor: Colors.transparent,
      // elevation: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.blue.withOpacity(0.2) : Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.blue.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          context.tr(AppStrings.admin),
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      hideBack: true,
      action: Row(
        children: [
          _buildActionButton(
            icon: Icons.language,
            onPressed: () {
              Locale newLocale = Localizations.localeOf(context).languageCode == 'en'
                  ? const Locale('ar')
                  : const Locale('en');
              MyApp.setLocale(context, newLocale);
            },
            isDarkMode: isDarkMode,
          ),
          const SizedBox(width: 8),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return _buildActionButton(
                icon: themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
                onPressed: () => BlocProvider.of<ThemeCubit>(context).toggleTheme(),
                isDarkMode: isDarkMode,
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: isDarkMode ? Colors.white : Colors.grey[700]),
        onPressed: onPressed,
        iconSize: 20,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode 
              ? [const Color(0xFF1E293B), const Color(0xFF334155)]
              : [Colors.white, const Color(0xFFF1F5F9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.dashboard, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(AppStrings.adminDashboard),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.tr(AppStrings.adminDashDesc),
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrders(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.shopping_cart, color: Colors.green, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      context.tr(AppStrings.recentOrders),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.grey[900],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrdersListPage()),
                  ),
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('View All', style: TextStyle(fontSize: 14)),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF6366F1),
                    backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          BlocProvider(
            create: (context) => OrdersDisplayCubit()..displayOrders(),
            child: BlocBuilder<OrdersDisplayCubit, OrdersDisplayState>(
              builder: (context, state) {
                if (state is OrdersLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is OrdersLoaded) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.orders.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    ),
                    itemBuilder: (context, index) {
                      final order = state.orders[index];
                      return OrderCard(
                        address: order.shippingAddress,
                        orderId: order.code,
                        status: order.orderStatus.last.title,
                        total: order.totalPrice,
                        customer: order.customer,
                      );
                    },
                  );
                }
                if (state is LoadOrdersFailure) {
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          state.errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}