import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service_locator.dart';
import '../../order/domain/entities/product_ordered.dart';
import '../../order/domain/usecases/get_cart_products.dart';
import '../../order/domain/usecases/remove_cart_product.dart';
import 'cart_products_display_state.dart';

class CartProductsDisplayCubit extends Cubit<CartProductsDisplayState> {
  CartProductsDisplayCubit() : super(CartProductsLoading());

  void displayCartProducts() async {
    var returnedData = await sl<GetCartProductsUseCase>().call();

    returnedData.fold(
      (error) {
        emit(LoadCartProductsFailure(errorMessage: error));
      },
      (data) {
        emit(CartProductsLoaded(products: data));
      },
    );
  }

  Future<void> removeProduct(ProductOrderedEntity product) async {
    emit(CartProductsLoading());
    var returnedData = await sl<RemoveCartProductUseCase>().call(
      params: product.id,
    );

    returnedData.fold(
      (error) {
        emit(LoadCartProductsFailure(errorMessage: error));
      },
      (data) {
        displayCartProducts();
      },
    );
  }
}
