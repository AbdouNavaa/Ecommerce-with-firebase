import 'package:dartz/dartz.dart';

import '../../data/models/add_to_cart_req.dart';
import '../../data/models/order_registration_req.dart';

abstract class OrderRepository {
  Future<Either> addToCart(AddToCartReq addToCartReq);
  Future<Either> getCartProducts();
  Future<Either> removeCartProduct(String id);
  Future<Either> orderRegistration(OrderRegistrationReq order);
  Future<Either> getUserOrders();
  Future<Either> getOrders();
  Future<Either> changeOrderStatus(String id, String status);
  Future<void> deleteOrder(String id);
}
