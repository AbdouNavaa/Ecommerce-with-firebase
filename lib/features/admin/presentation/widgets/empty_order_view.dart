import 'package:flutter/material.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/constants/models.dart';

class EmptyOrderView extends StatelessWidget {
  const EmptyOrderView({
    super.key,
    required List<OrderStatusTab> orderStatusTabs,
    required this.context,
    required this.status,
  }) : _orderStatusTabs = orderStatusTabs;

  final List<OrderStatusTab> _orderStatusTabs;
  final BuildContext context;
  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final tab = _orderStatusTabs.firstWhere((t) => t!.status == status);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(tab.icon, size: 64, color: Theme.of(context).hintColor),
          const SizedBox(height: 16),
          Text(
            'No orders ${tab.title.toLowerCase()} found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'The orders will appear here once they have this status.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
