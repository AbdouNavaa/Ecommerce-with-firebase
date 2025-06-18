import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';

import '../../../../common/helper/textstyle/text_style.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/constants.dart';
import '../../../../core/constants/fonctions.dart';
import '../../../../core/constants/models.dart';
import '../../../../core/resources/app_strings.dart';
import '../../../order/domain/entities/order.dart';
import 'order_details_sheet.dart';
import 'status_badge.dart';

class OrderItem extends StatelessWidget {
  final OrderEntity order;
  final int currentStatusIndex;
  final OrderStatusTab currentTab;

  const OrderItem({
    super.key,
    required this.order,
    required this.currentTab,
    required this.currentStatusIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      // color: Colors.transparent,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[100]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête de la commande
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        myText(
                          '${context.tr(AppStrings.customer)} : ',
                          isDark(context) ? Colors.white : Colors.black,
                          18,
                          FontWeight.bold,
                        ),
                        myText(
                          '${order.customer} ',
                          isDark(context) ? Colors.white : Colors.black,
                          18,
                          FontWeight.bold,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        myText(
                          '${context.tr(AppStrings.orderCode)}: ',
                          isDark(context) ? Colors.white : Colors.black,
                          18,
                          FontWeight.w600,
                        ),
                        myText(
                          '#${order.code} ',
                          isDark(context) ? Colors.white : Colors.black,
                          18,
                          FontWeight.w600,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StatusBadge(tab: currentTab),
            ],
          ),

          const SizedBox(height: 12),

          // Adresse de livraison
          _buildInfoRow(
            context,
            Icons.location_on_outlined,
            context.tr(AppStrings.address),
            order.shippingAddress,
          ),

          const SizedBox(height: 8),

          // Nombre d'Items
          _buildInfoRow(
            context,
            Icons.shopping_bag_outlined,
            context.tr(AppStrings.items),
            '${order.itemCount} ${context.tr(AppStrings.items)} ${order.itemCount > 1 ? 's' : ''}',
          ),

          const SizedBox(height: 16),

          // Pied de page avec prix et action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myText(
                context.tr(AppStrings.total),
                isDark(context) ? Colors.white : Colors.black,
                16,
                FontWeight.bold,
              ),
              Text(
                ' ${order.totalPrice} MRU',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showOrderDetails(context, order),
                icon: const Icon(Icons.visibility_outlined, size: 18),
                label: Text(context.tr(AppStrings.details)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construit une ligne d'information
  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).hintColor),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Affiche les détails d'une commande
  void _showOrderDetails(BuildContext context, OrderEntity order) {
    // Navigation vers la page de détails de la commande
    // AppNavigator.push(context, OrderDetailsPage(order: order));

    // Ou afficher un bottom sheet avec les détails
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildOrderDetailsSheet(order),
    );
  }

  /// Construit la feuille des détails de commande
  Widget _buildOrderDetailsSheet(OrderEntity order) {
    return OrderDetailsSheet(order: order);
  }
}
