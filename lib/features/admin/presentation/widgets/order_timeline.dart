import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/constants/fonctions.dart';
import '../../../order/domain/entities/order.dart';

class OrderTimeline extends StatelessWidget {
  final OrderEntity order;

  const OrderTimeline({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          order.orderStatus.asMap().entries.map((entry) {
            final index = entry.key;
            final status = entry.value;
            final isCompleted = status.done ?? false;
            final isLast = index == order.orderStatus.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCompleted ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : Icons.circle,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 50,
                        color: isCompleted ? Colors.green : Colors.grey,
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        status.title ?? 'Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isCompleted ? Colors.green : Colors.grey,
                        ),
                      ),
                      if (status.createdDate != null)
                        Text(
                          formatDate(status.createdDate.toDate().toString()),
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }
}
