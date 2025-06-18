import 'package:dartz/dartz.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../service_locator.dart';
import '../../data/models/add_to_cart_req.dart';
import '../repository/order.dart';

class AddToCartUseCase implements UseCase<Either, AddToCartReq> {
  @override
  Future<Either> call({AddToCartReq? params}) async {
    return sl<OrderRepository>().addToCart(params!);
  }
}
