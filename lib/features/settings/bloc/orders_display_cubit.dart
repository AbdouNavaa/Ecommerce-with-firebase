import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service_locator.dart';
import '../../order/domain/usecases/get_orders.dart';
import '../../order/domain/usecases/get_user_orders.dart';
import 'orders_display_state.dart';

class OrdersDisplayCubit extends Cubit<OrdersDisplayState> {
  OrdersDisplayCubit() : super(OrdersLoading());

  void displayUserOrders() async {
    var returnedData = await sl<GetUserOrdersUseCase>().call();
    returnedData.fold(
      (error) {
        emit(LoadOrdersFailure(errorMessage: error));
      },
      (orders) {
        // print('orders: $orders');
        emit(OrdersLoaded(orders: orders));
      },
    );
  }

  void displayOrders() async {
    var returnedData = await sl<GetOrdersUseCase>().call();
    returnedData.fold(
      (error) {
        emit(LoadOrdersFailure(errorMessage: error));
      },
      (orders) {
        emit(OrdersLoaded(orders: orders));
      },
    );
  }
}
