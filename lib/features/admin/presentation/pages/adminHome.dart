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
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      // backgroundColor: Color(0xFFF0F4FF),
      appBar: BasicAppbar(
        // backgroundColor: isDark(context) ? Colors.white : Colors.black,
        title: Text(
          '(${context.tr(AppStrings.admin)})',
          style: TextStyle(
            color: isDark(context) ? Colors.white : Colors.black,
          ),
        ),
        hideBack: true,
        action: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: () {
                // ✅ On bascule entre Anglais et Arabe
                Locale newLocale =
                    Localizations.localeOf(context).languageCode == 'en'
                        ? const Locale('ar')
                        : const Locale('en');
                MyApp.setLocale(context, newLocale);
              },
            ),

            IconButton(
              icon: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return Icon(
                    themeMode == ThemeMode.light
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  );
                },
              ),
              onPressed: () {
                BlocProvider.of<ThemeCubit>(context).toggleTheme();
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: SizedBox(
                height: size * 0.1,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr(AppStrings.adminDashboard),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: isDark(context) ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      context.tr(AppStrings.adminDashDesc),
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            isDark(context) ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            Lengths(size: size),
            const SizedBox(height: 10),
            //gridview des actions
            MyCards(size: size),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                context.tr(AppStrings.recentOrders),
                style: TextStyle(
                  color: isDark(context) ? Colors.white : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            //listview des orders
            BlocProvider(
              create: (context) => OrdersDisplayCubit()..displayOrders(),
              child: BlocBuilder<OrdersDisplayCubit, OrdersDisplayState>(
                builder: (context, state) {
                  debugPrint('state: $state');

                  if (state is OrdersLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is OrdersLoaded) {
                    return SizedBox(
                      width: double.infinity,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.orders.length,
                        itemBuilder: (context, index) {
                          var order = state.orders[index];
                          return OrderCard(
                            address: order.shippingAddress,
                            orderId: order.code,
                            status: order.orderStatus.last.title,
                            total: order.totalPrice,
                            customer: order.customer,
                          );
                        },
                      ),
                    );
                  }
                  if (state is LoadOrdersFailure) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return Container();
                },
              ),
            ),
            const SizedBox(height: 10),
            //btn show all
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrdersListPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFf0f4FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    context.tr(AppStrings.viewAllOrders),
                    style: TextStyle(
                      color: Color(0xFF4a71FF),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _bottomBarIndex,
        onTap: (index) {
          setState(() {
            _bottomBarIndex = index;
          });
          // Ajoutez ici toute logique supplémentaire si nécessaire
        },
        isAdmin: true, // Passer true pour le mode admin
      ),
    );
  }
}
