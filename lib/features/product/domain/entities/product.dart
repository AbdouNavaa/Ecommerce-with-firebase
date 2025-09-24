import '../../data/models/product.dart';

class ProductEntity {
  String? pName;
  String? pPrice;
  String? pLocation;
  String? pDescription;
  String? pCategory;
  String? pId;
  int? pQuantity;

  ProductEntity({
    required this.pName,
    required this.pPrice,
    required this.pLocation,
    required this.pDescription,
    required this.pCategory,
    required this.pId,
    required this.pQuantity,
  });

  fromEntity() {}
}

//to model
extension ProductXModel on ProductEntity {
  ProductModel toModel() {
    return ProductModel(
      pId: pId,
      pCategory: pCategory,
      pDescription: pDescription,
      pLocation: pLocation,
      pName: pName,
      pPrice: pPrice,
      pQuantity: pQuantity,
    );
  }
}
