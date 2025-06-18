import 'package:flutter_with_firebase/features/product/domain/entities/product.dart';

import '../core/constants.dart';
import '../models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  addProduct(Product product) {
    _firestore.collection(kProductsCollection).add({
      kProductName: product.pName,
      kProductDescription: product.pDescription,
      kProductLocation: product.pLocation,
      kProductCategory: product.pCategory,
      kProductPrice: product.pPrice,
    });
  }

  Stream<QuerySnapshot> loadProducts() {
    return _firestore.collection(kProductsCollection).snapshots();
  }

  Stream<QuerySnapshot> loadOrders() {
    return _firestore.collection(kOrders).snapshots();
  }

  Stream<QuerySnapshot> loadOrderDetails(documentId) {
    return _firestore
        .collection(kOrders)
        .doc(documentId)
        .collection(kOrderDetails)
        .snapshots();
  }

  deleteProduct(documentId) {
    _firestore.collection(kProductsCollection).doc(documentId).delete();
  }

  editProduct(data, documentId) {
    _firestore.collection(kProductsCollection).doc(documentId).update(data);
  }

  storeOrders(data, List<ProductEntity> products) {
    var documentRef = _firestore.collection(kOrders).doc();
    documentRef.set(data);
    for (var product in products) {
      documentRef.collection(kOrderDetails).doc().set({
        kProductName: product.pName,
        kProductPrice: product.pPrice,
        kProductQuantity: product.pQuantity,
        kProductLocation: product.pLocation,
        kProductCategory: product.pCategory,
      });
    }
  }
}
