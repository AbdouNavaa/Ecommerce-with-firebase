import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';

import '../../../../common/helper/textstyle/text_style.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/constants.dart';
import '../../../../core/resources/app_strings.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String address;
  final double total;
  final String status;
  final String customer;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.address,
    required this.total,
    required this.status,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark(context) ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(10),

        boxShadow: [
          isDark(context)
              ? BoxShadow(
                color: Colors.grey.shade900,
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 3), // changes position of shadow
              )
              : BoxShadow(
                color: Colors.grey.shade200,
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 3), // changes position of shadow
              ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                myText(
                  '${context.tr(AppStrings.customer)}: ',
                  isDark(context) ? Colors.white : Colors.black,
                  18,
                  FontWeight.bold,
                ),
                myText(
                  '$customer ',
                  isDark(context) ? Colors.white : Colors.black,
                  18,
                  FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 8, child: Divider()),
            Row(
              children: [
                myText(
                  '${context.tr(AppStrings.orderCode)}: #',
                  isDark(context) ? Colors.white : Colors.black,
                  16,
                  FontWeight.bold,
                ),
                myText(
                  orderId,
                  isDark(context) ? Colors.white : Colors.black,
                  16,
                  FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                myText(
                  '${context.tr(AppStrings.address)}: ',
                  isDark(context) ? Colors.white70 : Colors.black54,
                  14,
                  FontWeight.w400,
                ),
                myText(
                  address,
                  isDark(context) ? Colors.white70 : Colors.black54,
                  14,
                  FontWeight.w400,
                ),
              ],
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${context.tr(AppStrings.status)}: ',

                  style: TextStyle(
                    color:
                        status == 'Order Placed'
                            ? Colors.redAccent
                            : status == 'Order Confirmed'
                            ? Colors.indigo
                            : status == 'Shipped'
                            ? Colors.orange
                            : Colors.green,

                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color:
                        status == 'Order Placed'
                            ? Colors.redAccent
                            : status == 'Order Confirmed'
                            ? Colors.indigo
                            : status == 'Shipped'
                            ? Colors.orange
                            : Colors.green,

                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                myText(
                  '${context.tr(AppStrings.total)}: ',
                  AppColors.primary,
                  16,
                  FontWeight.bold,
                ),
                myText('\$$total', AppColors.primary, 16, FontWeight.bold),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
