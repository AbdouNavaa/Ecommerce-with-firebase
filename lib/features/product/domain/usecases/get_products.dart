import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_with_firebase/features/product/domain/repository/product.dart';

import '../../../../service_locator.dart';

import '../../../../core/usecase/usecase.dart';

class GetProductsUseCase implements UseCase<QuerySnapshot, void> {
  // void car dans l'appel de cette usecase il n'est pas besoin de parametres
  @override
  Future<QuerySnapshot> call({void params}) async {
    return await sl<ProductRepository>().getProducts();
  }
}
