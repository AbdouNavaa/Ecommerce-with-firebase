import 'package:flutter_with_firebase/features/product/domain/entities/product.dart';

List<ProductEntity> getProductByCategory(
  String kJackets,
  List<ProductEntity> allproducts,
) {
  List<ProductEntity> products = [];
  try {
    for (var product in allproducts) {
      if (product.pCategory == kJackets) {
        products.add(product);
      }
    }
  } on Error catch (ex) {
    print(ex);
  }
  return products;
}
