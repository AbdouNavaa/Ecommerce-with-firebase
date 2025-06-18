import 'package:flutter_with_firebase/features/order/data/models/product_ordered.dart';

import '../../domain/entities/product_ordered.dart';
import 'order_status.dart';

class OrderRegistrationReq {
  final List<ProductOrderedEntity> products;
  final String createdDate;
  final String shippingAddress;
  final int itemCount;
  final double totalPrice;
  final String code;
  final List<OrderStatusModel> orderStatus;
  //userId

  final String? userId;
  final String? userName;

  OrderRegistrationReq({
    required this.products,
    required this.createdDate,
    required this.itemCount,
    required this.totalPrice,
    required this.shippingAddress,
    required this.code,
    required this.orderStatus,
    String? userId,
    this.userName,
  }) : userId = userId ?? DateTime.now().toString();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'products': products.map((e) => e.fromEntity().toMap()).toList(),
      'createdDate': createdDate,
      'itemCount': itemCount,
      'totalPrice': totalPrice,
      'shippingAddress': shippingAddress,
      'code': code,
      'orderStatus': orderStatus.map((e) => e.toMap()).toList(),
      'userId': userId,
      'userName': userName,
    };
  }
}
