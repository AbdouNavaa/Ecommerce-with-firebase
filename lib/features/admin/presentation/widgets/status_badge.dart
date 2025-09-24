import 'package:flutter/material.dart';

import '../../../../core/constants/models.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.tab});

  final OrderStatusTab tab;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tab.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tab.color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(tab.icon, size: 14, color: tab.color),
          const SizedBox(width: 4),
          Text(
            tab.title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: tab.color,
            ),
          ),
        ],
      ),
    );
  }
}
