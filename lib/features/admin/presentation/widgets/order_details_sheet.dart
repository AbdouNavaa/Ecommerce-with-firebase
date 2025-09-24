import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_firebase/core/configs/theme/app_colors.dart';
import 'package:flutter_with_firebase/core/constants.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';

import '../../../../common/helper/navigator/app_navigator.dart';
import '../../../../common/helper/textstyle/text_style.dart';
import '../../../../core/constants/fonctions.dart';
import '../../../../core/resources/app_strings.dart';
import '../../../../service_locator.dart';
import '../../../order/domain/entities/order.dart';
import '../../../order/domain/usecases/delete_order.dart';
import '../../../order/domain/usecases/order_change_status.dart';
import '../../../settings/bloc/orders_display_cubit.dart';
import '../../../settings/pages/order_items.dart';
import 'order_timeline.dart';

class OrderDetailsSheet extends StatefulWidget {
  final OrderEntity order;

  const OrderDetailsSheet({super.key, required this.order});

  @override
  State<OrderDetailsSheet> createState() => _OrderDetailsSheetState();
}

class _OrderDetailsSheetState extends State<OrderDetailsSheet> {
  late String selectedStatus;
  bool _isLoading = false;

  static const List<String> _statuses = [
    'Order Placed',
    'Order Confirmed',
    'Shipped',
    'Delivered',
  ];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.order.orderStatus.lastWhere((s) => s.done).title;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final order = widget.order;
    // print('Orders:  ${widget.order}');

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDragHandle(theme),
          _buildHeader(order, theme),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderInfo(order, theme),
                  const SizedBox(height: 32),
                  _buildStatusSection(order, theme),
                  const SizedBox(height: 32),
                  _buildActionButtons(context, order, theme),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle(ThemeData theme) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      decoration: BoxDecoration(
        color: theme.dividerColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(OrderEntity order, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    myText(
                      '${context.tr(AppStrings.orderCode)}: #',
                      theme.colorScheme.primary,
                      20,
                      FontWeight.bold,
                    ),
                    myText(
                      order.code,
                      theme.colorScheme.primary,
                      20,
                      FontWeight.bold,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    myText(
                      '${context.tr(AppStrings.customer)}: ',
                      theme.colorScheme.onSurface,
                      18,
                      FontWeight.bold,
                    ),
                    myText(
                      order.customer,
                      theme.colorScheme.onSurface,
                      18,
                      FontWeight.bold,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            style: IconButton.styleFrom(
              backgroundColor: theme.scaffoldBackgroundColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfo(OrderEntity order, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr(AppStrings.orderInformation),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: context.tr(AppStrings.address),
            value: order.shippingAddress,
            theme: theme,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.attach_money,
            label: context.tr(AppStrings.total),
            value: '${order.totalPrice} MRU',
            theme: theme,
            isHighlighted: true,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.shopping_bag_outlined,
            label: context.tr(AppStrings.items),
            value: '${order.itemCount} ${context.tr(AppStrings.items)}',
            theme: theme,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.calendar_today_outlined,
            label: context.tr(AppStrings.date),
            value: formatDate(order.createdDate),
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
    bool isHighlighted = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 25, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
                  color:
                      isHighlighted
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSection(OrderEntity order, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr(AppStrings.orderStatus),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          OrderTimeline(order: order),
          const SizedBox(height: 24),
          Text(
            context.tr(AppStrings.updateStatus),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: selectedStatus,
              isExpanded: true,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items:
                  _statuses.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status, style: theme.textTheme.bodyLarge),
                    );
                  }).toList(),
              onChanged:
                  _isLoading
                      ? null
                      : (value) {
                        if (value != null) {
                          setState(() {
                            selectedStatus = value;
                          });
                        }
                      },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    OrderEntity order,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            label: context.tr(AppStrings.items),
            icon: Icons.list_alt,
            color: theme.colorScheme.secondary,
            onPressed:
                _isLoading
                    ? null
                    : () {
                      AppNavigator.push(
                        context,
                        OrderItemsPage(products: order.products),
                      );
                    },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            label:
                _isLoading
                    ? context.tr(AppStrings.editing)
                    : context.tr(AppStrings.edit),
            icon: _isLoading ? Icons.hourglass_empty : Icons.edit,
            color: Colors.green,
            onPressed:
                _isLoading ? null : () => _updateOrderStatus(context, order),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            label: context.tr(AppStrings.delete),
            icon: Icons.delete_outline,
            color: Colors.red.shade500,
            onPressed:
                _isLoading
                    ? null
                    : () => _showDeleteConfirmation(context, order),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    );
  }

  Future<void> _updateOrderStatus(
    BuildContext context,
    OrderEntity order,
  ) async {
    setState(() => _isLoading = true);

    try {
      final result = await sl<OrderChangeStatusUseCase>()(
        params: {'id': order.code, 'status': selectedStatus},
      );

      if (!mounted) return;

      result.fold(
        (error) {
          _showSnackBar(context, error, isError: true);
        },
        (message) {
          _showSnackBar(context, message, isError: false);
          Navigator.pop(context);
          context.read<OrdersDisplayCubit>().displayOrders();
        },
      );
    } catch (e) {
      if (mounted) {
        _showSnackBar(
          context,
          context.tr(AppStrings.errorUpdatingStatus),
          isError: true,
        );
      }
    }
    // finally {
    //   if (mounted) {
    //     setState(() => _isLoading = false);
    //   }
    // }
  }

  Future<void> _deletOrder(BuildContext context, OrderEntity order) async {
    try {
      await sl<DeleteOrderUseCase>()(params: order.code);

      if (!mounted) return;
      _showSnackBar(
        context,
        context.tr(AppStrings.orderDeleted),
        isError: false,
      );
      Navigator.pop(context);
      // context.read<OrdersDisplayCubit>().displayOrders();
    } catch (e) {
      if (mounted) {
        _showSnackBar(context, e.toString(), isError: true);
      }
    }
    // finally {
    //   if (mounted) {
    //     setState(() => _isLoading = false);
    //   }
    // }
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    OrderEntity order,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: themeColors(
              context,
              AppColors.secondBackground,
              Colors.white,
            ),
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(1),
            ),
            title: Text(context.tr(AppStrings.deleteOrderConf)),
            content: Container(
              padding: const EdgeInsets.all(16),
              child: Text('${context.tr(AppStrings.areYouSureDeleteOrder)} '),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.tr(AppStrings.cancel)),
              ),
              ElevatedButton(
                onPressed: () => _deletOrder(context, order),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  context.tr(AppStrings.delete),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      // Implémentez ici la logique de suppression
      _showSnackBar(
        context,
        context.tr(AppStrings.orderDeleted),
        isError: false,
      );
      Navigator.pop(context);
      context.read<OrdersDisplayCubit>().displayOrders();
    }
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    required bool isError,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
