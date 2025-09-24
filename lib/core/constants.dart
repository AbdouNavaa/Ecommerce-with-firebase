import 'package:flutter/material.dart';

const kMainColor = Color.fromARGB(255, 248, 248, 247);
const kYellowColor = Color(0xFFFFC12F);
// const kYellowColor = Color(0xFF0A66C2);
const kSecondaryColor = Color.fromARGB(255, 244, 243, 242);
const kProductName = 'productName';
const kProductPrice = 'productPrice';
const kProductDescription = 'productDescription';
const kProductLocation = 'productLocation';
const kProductCategory = 'productCategory';
const kProductsCollection = 'Products';
const kUnActiveColor = Color(0xFFC1BDB8);
const kJackets = 'jackets';
const kTrousers = 'trousers';
const kTshirts = 't-shirts';
const kShoes = 'shoes';
const kOrders = 'Orders';
const kOrderDetails = 'OrderDetails';
const kTotallPrice = 'TotallPrice';
const kAddress = 'Address';
const kProductQuantity = 'Quantity';
const kKeepMeLoggedIn = 'KeepMeLoggedIn';
const kBnbColorPrimary = Color(0XFF313384);
const kBnbColorAccent = Color(0XFF313384);
const kBnbColorAccentDark = Color(0XFF313384);

// Updated color list with proper Color constructor
final List<Color> productColors = [
  Color(0xFF4482AF), // Blue-ish
  Color(0xFFD1A984), // Beige/Brown
  Color(0xFF999493), // Gray
  Color(0xFFE4B398), // Light Peach
  Color(0xFFCD686C), // Coral/Red
  Color(0xFF949494), // Another Gray
];

const kFavorites = 'favoriteProducts';
const kCartItems = 'CartItems';
// Use this function to determine if the theme is dark at runtime
bool isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;
Color themeColors(BuildContext context, Color color1, Color color2) =>
    isDark(context) ? color1 : color2;
