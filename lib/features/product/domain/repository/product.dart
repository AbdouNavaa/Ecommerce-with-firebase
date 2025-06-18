import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../entities/product.dart';

abstract class ProductRepository {
  Future<QuerySnapshot> getProducts();
  // Future<Either> getTopSelling();
  // Future<Either> getNewIn();
  // Future<Either> getProductsByCategoryId(String categoryId);
  Future<Either> getProductsByTitle(String title);
  Future<Either> addOrRemoveFavoriteProduct(ProductEntity product);
  Future<bool> isFavorite(String productId);
  Future<Either> getFavoritesProducts();
}
