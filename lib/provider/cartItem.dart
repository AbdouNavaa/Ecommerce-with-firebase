import 'package:flutter/cupertino.dart';
import 'package:flutter_with_firebase/core/constants.dart';
import 'package:flutter_with_firebase/features/product/domain/entities/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../features/product/data/models/product.dart';

class CartItem extends ChangeNotifier {
  List<ProductEntity> products = [];

  CartItem() {
    _loadCartItem(); // Load CartItem when the class is instantiated
  }

  /// 🔄 Add product to CartItem
  addProduct(ProductEntity product) async {
    products.add(product);
    await _saveCartItem();
    notifyListeners();
  }

  /// ❌ Remove product from CartItem
  deleteProduct(ProductEntity product) async {
    products.removeWhere((item) => item.pId == product.pId);
    await _saveCartItem();
    notifyListeners();
  }

  /// 💾 Save the list of products to SharedPreferences
  Future<void> _saveCartItem() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productList =
        products
            .map((product) => jsonEncode(product.toModel().toJson()))
            .toList();
    await prefs.setStringList(kCartItems, productList);
  }

  /// 🔄 Load the list of products from SharedPreferences
  Future<void> _loadCartItem() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? productList = prefs.getStringList(kCartItems);
    if (productList != null) {
      // products = productList.map((product) => ProductModel.fromJson(jsonDecode(product))).toList();

      // Décoder chaque produit et le convertir en ProductEntity
      products =
          productList.map((product) {
            final model = ProductModel.fromJson(jsonDecode(product));
            return ProductEntity(
              pId: model.pId,
              pCategory: model.pCategory,
              pDescription: model.pDescription,
              pLocation: model.pLocation,
              pName: model.pName,
              pPrice: model.pPrice,
              pQuantity: model.pQuantity,
            );
          }).toList();
      notifyListeners();
    }
  }

  /// 🧹 Clear all CartItem (optional)
  clearCartItem() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kCartItems);
    products.clear();
    notifyListeners();
  }

  void incrementQuantity(int index) {
    products[index].pQuantity = products[index].pQuantity! + 1;
    notifyListeners();
  }

  void decrementQuantity(int index) {
    products[index].pQuantity =
        products[index].pQuantity == 1 ? 1 : products[index].pQuantity! - 1;
    notifyListeners();
  }
}
