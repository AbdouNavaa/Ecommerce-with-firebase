import 'package:dartz/dartz.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../service_locator.dart';
import '../repository/order.dart';

class RemoveCartProductUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return sl<OrderRepository>().removeCartProduct(params!);
  }
}
