import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../service_locator.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';
import 'get_porducts_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase _getProductsUseCase;

  ProductCubit(this._getProductsUseCase) : super(ProductInitial());

  void loadProducts() async {
    try {
      emit(ProductLoading());

      // Récupérer les produits depuis Firestore
      final snapshot = await sl<GetProductsUseCase>().call();

      final products =
          snapshot.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            print('Data: ${data}');
            return ProductEntity(
              pId: doc.id,
              pPrice: data['productPrice'],
              pName: data['productName'],
              pDescription: data['productDescription'],
              pLocation: data['productLocation'],
              pCategory: data['productCategory'],
              pQuantity: 0,
            );
          }).toList();

      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
