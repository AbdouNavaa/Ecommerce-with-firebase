import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/common/helper/navigator/app_navigator.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';
import 'package:flutter_with_firebase/core/resources/app_strings.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/constants.dart';
import '../pages/admin_orders.dart';
import '../pages/admin_products.dart';

class MyCards extends StatelessWidget {
  final double size;
  const MyCards({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size * 0.45,
      width: double.infinity,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .95,
          crossAxisSpacing: .1,
          // mainAxisSpacing: 5,
        ),
        itemCount: 4, // Replace with your actual item count length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              index == 0
                  ? AppNavigator.push(context, ProductsManagement())
                  : index == 1
                  ? Navigator.pushNamed(context, '/orders')
                  : index == 2
                  ? AppNavigator.push(context, OrdersListPage())
                  : Navigator.pushNamed(context, '/analytics');
            },
            child: Container(
              margin: const EdgeInsets.all(8),
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
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        index == 0
                            ? Ionicons.cube_outline
                            : index == 1
                            ? Ionicons.pricetag_outline
                            : index == 2
                            ? Icons.shopping_bag_outlined
                            : Ionicons.stats_chart_outline,
                        size: 28,
                        color:
                            index == 0
                                ? Color(0xFF6484FF)
                                : index == 1
                                ? Color(0xFFff0009)
                                : index == 2
                                ? Color(0xff00ff0f)
                                : Color(0xffff80f1),
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor:
                            index == 0
                                ? Color(0x1A6484FF)
                                : index == 1
                                ? Color(0x1Aff0009)
                                : index == 2
                                ? Color(0x1A00ff0f)
                                : Color(0x1Aff80f1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Text(
                      index == 0
                          ? context.tr(AppStrings.products)
                          : index == 1
                          ? context.tr(AppStrings.categories)
                          : index == 2
                          ? context.tr(AppStrings.orders)
                          : context.tr(AppStrings.analytics),
                      style: TextStyle(
                        color: isDark(context) ? Colors.white : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      index == 0
                          ? context.tr(AppStrings.manageProducts)
                          : index == 1
                          ? context.tr(AppStrings.manageCategories)
                          : index == 2
                          ? context.tr(AppStrings.manageOrders)
                          : context.tr(AppStrings.manageAnalytics),
                      style: TextStyle(
                        color:
                            isDark(context) ? Colors.white70 : Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
