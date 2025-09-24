import 'package:dartz/dartz.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/order.dart';
import '../models/add_to_cart_req.dart';
import '../models/order.dart';
import '../models/order_registration_req.dart';
import '../models/product_ordered.dart';
import '../source/order_firebase_service.dart';

class OrderRepositoryImpl extends OrderRepository {
  @override
  Future<Either> addToCart(AddToCartReq addToCartReq) async {
    return sl<OrderFirebaseService>().addToCart(addToCartReq);
  }

  @override
  Future<Either> getCartProducts() async {
    var returnedData = await sl<OrderFirebaseService>().getCartProducts();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => ProductOrderedModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> removeCartProduct(String id) async {
    var returnedData = await sl<OrderFirebaseService>().removeCartProduct(id);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (message) {
        return Right(message);
      },
    );
  }

  @override
  Future<Either> orderRegistration(OrderRegistrationReq order) async {
    var returnedData = await sl<OrderFirebaseService>().orderRegistration(
      order,
    );
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (message) {
        return Right(message);
      },
    );
  }

  @override
  Future<Either> getUserOrders() async {
    var returnedData = await sl<OrderFirebaseService>().getUserOrders();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data).map((e) => OrderModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getOrders() async {
    var returnedData = await sl<OrderFirebaseService>().getOrders();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data).map((e) => OrderModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> changeOrderStatus(String id, String status) async {
    var returnedData = await sl<OrderFirebaseService>().changeOrderStatus(
      id,
      status,
    );
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<void> deleteOrder(String id) {
    return sl<OrderFirebaseService>().deleteOrder(id);
  }
}
