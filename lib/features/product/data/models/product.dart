import 'package:flutter_with_firebase/features/product/domain/entities/product.dart';

class ProductModel {
  String? pName;
  String? pPrice;
  String? pLocation;
  String? pDescription;
  String? pCategory;
  String? pId;
  int? pQuantity;
  ProductModel({
    this.pQuantity,
    this.pId,
    this.pName,
    this.pCategory,
    this.pDescription,
    this.pLocation,
    this.pPrice,
  });
  // from json
  ProductModel.fromJson(Map<String, dynamic> json) {
    pName = json['pName'];
    pPrice = json['pPrice'];
    pLocation = json['pLocation'];
    pDescription = json['pDescription'];
    pCategory = json['pCategory'];
    pId = json['pId'];
    pQuantity = json['pQuantity'];
  }
  // to json
  Map<String, dynamic> toJson() {
    return {
      'pName': pName,
      'pPrice': pPrice,
      'pLocation': pLocation,
      'pDescription': pDescription,
      'pCategory': pCategory,
      'pId': pId,
      'pQuantity': pQuantity,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': pId ?? '',
      'productPrice': pPrice,
      'productLocation': pLocation,
      'productName': pName,
      'productDescription': pDescription,
      'productCategory': pCategory,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      pPrice: map['productPrice'] as String,
      pLocation: map['productLocation'] as String,
      pName: map['productName'] as String,
      pDescription: map['productDescription'] as String,
      pCategory: map['productCategory'] as String,
      pId: map['productId'] ?? '' as String,
    );
  }
}

extension ProductXModel on ProductModel {
  ProductEntity toEntity() {
    return ProductEntity(
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

extension ProductXEntity on ProductEntity {
  ProductModel fromEntity() {
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
