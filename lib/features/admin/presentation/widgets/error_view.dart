import 'package:flutter/material.dart';

import '../../../settings/bloc/orders_display_cubit.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.context,
    required OrdersDisplayCubit ordersDisplayCubit,
    required this.message,
  }) : _ordersDisplayCubit = ordersDisplayCubit;

  final BuildContext context;
  final OrdersDisplayCubit _ordersDisplayCubit;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Erreur de chargement',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _ordersDisplayCubit.displayOrders(),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}
