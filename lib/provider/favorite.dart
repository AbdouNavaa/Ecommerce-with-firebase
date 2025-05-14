import 'package:flutter/cupertino.dart';
import 'package:flutter_with_firebase/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import 'dart:convert';

class Favorites extends ChangeNotifier {
  List<Product> products = [];

  Favorites() {
    _loadFavorites(); // Load favorites when the class is instantiated
  }

  /// 🔄 Add product to favorites
  addProduct(Product product) async {
    products.add(product);
    await _saveFavorites();
    notifyListeners();
  }

  /// ❌ Remove product from favorites
  deleteProduct(Product product) async {
    products.removeWhere((item) => item.pId == product.pId);
    await _saveFavorites();
    notifyListeners();
  }

  /// 💾 Save the list of products to SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productList =
        products.map((product) => jsonEncode(product.toJson())).toList();
    await prefs.setStringList(kFavorites, productList);
  }

  /// 🔄 Load the list of products from SharedPreferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? productList = prefs.getStringList(kFavorites);
    if (productList != null) {
      products =
          productList
              .map((product) => Product.fromJson(jsonDecode(product)))
              .toList();
      notifyListeners();
    }
  }

  /// 🧹 Clear all favorites (optional)
  clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kFavorites);
    products.clear();
    notifyListeners();
  }
}
