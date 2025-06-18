import '../../../features/product/domain/entities/product.dart';

class ProductPriceHelper {
  static double provideCurrentPrice(ProductEntity product) {
    return product.pPrice != 0
        ? double.parse(product.pPrice.toString())
        : double.parse(product.pPrice.toString());
  }
}
