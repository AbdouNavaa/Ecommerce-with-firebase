import 'package:flutter/cupertino.dart';
import 'package:flutter_with_firebase/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import 'dart:convert';

class CartItem extends ChangeNotifier {
  List<Product> products = [];

  CartItem() {
    _loadCartItem(); // Load CartItem when the class is instantiated
  }

  /// 🔄 Add product to CartItem
  addProduct(Product product) async {
    products.add(product);
    await _saveCartItem();
    notifyListeners();
  }

  /// ❌ Remove product from CartItem
  deleteProduct(Product product) async {
    products.removeWhere((item) => item.pId == product.pId);
    await _saveCartItem();
    notifyListeners();
  }

  /// 💾 Save the list of products to SharedPreferences
  Future<void> _saveCartItem() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productList =
        products.map((product) => jsonEncode(product.toJson())).toList();
    await prefs.setStringList(kCartItems, productList);
  }

  /// 🔄 Load the list of products from SharedPreferences
  Future<void> _loadCartItem() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? productList = prefs.getStringList(kCartItems);
    if (productList != null) {
      products =
          productList
              .map((product) => Product.fromJson(jsonDecode(product)))
              .toList();
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
