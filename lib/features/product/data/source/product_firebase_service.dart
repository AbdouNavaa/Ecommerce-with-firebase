import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants.dart';
import '../../domain/entities/product.dart';

abstract class ProductFirebaseService {
  // Future<void> addProduct(Map<String, dynamic> product);
  Future<QuerySnapshot> getProducts();
  //   Future<Either> getTopSelling();
  // Future<Either> getNewIn();
  // Future<Either> getProductsByCategoryId(String categoryId);
  Future<Either> getProductsByTitle(String title);
  Future<Either> addOrRemoveFavoriteProduct(ProductEntity product);
  Future<bool> isFavorite(String productId);
  Future<Either> getFavoritesProducts();
}

class ProductFirebaseServiceImpl extends ProductFirebaseService {
  @override
  Future<QuerySnapshot> getProducts() {
    return FirebaseFirestore.instance.collection(kProductsCollection).get();
  }

  @override
  Future<Either<String, bool>> addOrRemoveFavoriteProduct(
    ProductEntity product,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return const Left('User not authenticated');

      final favoritesRef = FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .collection('Favorites');

      final productRef = favoritesRef.doc(
        product.pId,
      ); // On utilise l'ID du produit comme ID du document

      final snapshot = await productRef.get();

      if (snapshot.exists) {
        // Si le produit existe déjà, on le supprime
        await productRef.delete();
        return const Right(false);
      } else {
        // Sinon, on l'ajoute
        await productRef.set({
          ...product.toModel().toMap(),
          'addedAt': FieldValue.serverTimestamp(),
        });
        return const Right(true);
      }
    } catch (e) {
      return Left('Error: ${e.toString()}');
    }
  }

  @override
  Future<bool> isFavorite(String productId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final favoritesRef = FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .collection('Favorites');

      final productRef = favoritesRef.doc(productId);

      final snapshot = await productRef.get();
      return snapshot.exists;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> getFavoritesProducts() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var returnedData =
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(user!.uid)
              .collection('Favorites')
              .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getProductsByTitle(String title) async {
    try {
      var returnedData =
          await FirebaseFirestore.instance
              .collection('Products')
              .where('productName', isGreaterThanOrEqualTo: title)
              .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
