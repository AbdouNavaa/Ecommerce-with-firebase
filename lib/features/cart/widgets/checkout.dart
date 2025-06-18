import 'package:flutter/material.dart';

import '../../../common/helper/cart/cart.dart';
import '../../../common/navigator/app_navigator.dart';
import '../../../common/widgets/button/basic_app_button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../order/domain/entities/product_ordered.dart';
import '../pages/checkout.dart';

class Checkout extends StatelessWidget {
  final List<ProductOrderedEntity> products;
  const Checkout({required this.products, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height / 3.5,
      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? AppColors.secondBackground
                : AppColors.thirdBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(2, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subtotal',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                '\$${CartHelper.calculateCartSubtotal(products).toString()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shipping Cost',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                '\$8',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax', style: TextStyle(color: Colors.grey, fontSize: 16)),
              Text(
                '\$0.0',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                '\$${CartHelper.calculateCartSubtotal(products) + 8}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          BasicAppButton(
            onPressed: () {
              AppNavigator.push(context, CheckOutPage(products: products));
            },
            title: 'Checkout',
          ),
        ],
      ),
    );
  }
}
