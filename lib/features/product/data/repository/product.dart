import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_with_firebase/features/product/domain/entities/product.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/product.dart';
import '../models/product.dart';
import '../source/product_firebase_service.dart';

class ProductRepositoryImpl extends ProductRepository {
  @override
  Future<QuerySnapshot<Object?>> getProducts() async {
    var products = await sl<ProductFirebaseService>().getProducts();
    return products;
  }

  //   @override
  // Future<Either> getTopSelling() async {
  //   var returnedData = await sl<ProductFirebaseService>().getTopSelling();
  //   return returnedData.fold(
  //     (error){
  //       return Left(error);
  //     },
  //     (data){
  //       return Right(
  //         List.from(data).map((e) => ProductModel.fromMap(e).toEntity()).toList()
  //       );
  //     }
  //   );
  // }

  // @override
  // Future<Either> getNewIn() async {
  //   var returnedData = await sl<ProductFirebaseService>().getNewIn();
  //   return returnedData.fold(
  //     (error){
  //       return Left(error);
  //     },
  //     (data){
  //       return Right(
  //         List.from(data).map((e) => ProductModel.fromMap(e).toEntity()).toList()
  //       );
  //     }
  //   );
  // }

  // @override
  // Future<Either> getProductsByCategoryId(String categoryId) async {
  //   var returnedData = await sl<ProductFirebaseService>().getProductsByCategoryId(categoryId);
  //   return returnedData.fold(
  //     (error){
  //       return Left(error);
  //     },
  //     (data){
  //       return Right(
  //         List.from(data).map((e) => ProductModel.fromMap(e).toEntity()).toList()
  //       );
  //     }
  //   );
  // }

  // @override
  // Future<Either> getProductsByTitle(String title) async {
  //   var returnedData = await sl<ProductFirebaseService>().getProductsByTitle(title);
  //   return returnedData.fold(
  //     (error){
  //       return Left(error);
  //     },
  //     (data){
  //       return Right(
  //         List.from(data).map((e) => ProductModel.fromMap(e).toEntity()).toList()
  //       );
  //     }
  //   );
  // }

  @override
  Future<Either> addOrRemoveFavoriteProduct(ProductEntity product) async {
    var returnedData = await sl<ProductFirebaseService>()
        .addOrRemoveFavoriteProduct(product);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }

  @override
  Future<bool> isFavorite(String productId) async {
    return await sl<ProductFirebaseService>().isFavorite(productId);
  }

  @override
  Future<Either> getFavoritesProducts() async {
    var returnedData =
        await sl<ProductFirebaseService>().getFavoritesProducts();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => ProductModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> getProductsByTitle(String title) async {
    var returnedData = await sl<ProductFirebaseService>().getProductsByTitle(
      title,
    );
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(
            data,
          ).map((e) => ProductModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }
}
