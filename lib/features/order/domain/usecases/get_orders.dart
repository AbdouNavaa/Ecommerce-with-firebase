import 'package:dartz/dartz.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../service_locator.dart';
import '../repository/order.dart';

class GetOrdersUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return sl<OrderRepository>().getOrders();
  }
}
