import 'package:flutter/material.dart';

import 'enums.dart';

/// Configuration d'un onglet de statut de commande
class OrderStatusTab {
  final String title;
  final OrderStatus status;
  final int statusValue;
  final IconData icon;
  final Color color;

  const OrderStatusTab({
    required this.title,
    required this.status,
    required this.statusValue,
    required this.icon,
    required this.color,
  });
}
