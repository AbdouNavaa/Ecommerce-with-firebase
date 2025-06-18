import 'package:flutter/material.dart';

import '../../../common/helper/navigator/app_navigator.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants.dart';
import '../pages/my_orders.dart';

class MyOrdersTile extends StatelessWidget {
  const MyOrdersTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, const MyOrdersPage());
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color:
              isDark(context)
                  ? AppColors.secondBackground
                  : AppColors.thirdBackground,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Orders',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}
