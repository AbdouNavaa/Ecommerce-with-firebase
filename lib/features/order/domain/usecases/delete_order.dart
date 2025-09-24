import 'package:dartz/dartz.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../service_locator.dart';
import '../repository/order.dart';

class DeleteOrderUseCase implements UseCase<void, String> {
  @override
  Future<void> call({String? params}) {
    return sl<OrderRepository>().deleteOrder(params!);
  }
}
