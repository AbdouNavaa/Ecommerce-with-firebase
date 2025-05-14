import 'package:flutter_with_firebase/provider/favorite.dart';
import 'package:flutter_with_firebase/screens/user/FavoritesScreen.dart';

import 'models/product.dart';
import 'provider/adminMode.dart';
import 'provider/cartItem.dart';
import 'provider/modelHud.dart';
import 'screens/admin/OrdersScreen.dart';
import 'screens/admin/addProduct.dart';
import 'screens/admin/adminHome.dart';
import 'screens/admin/editProduct.dart';
import 'screens/admin/manageProduct.dart';
import 'screens/admin/order_details.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/user/CartScreen.dart';
import 'screens/user/homePage.dart';
import 'screens/user/productInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isUserLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            home: Scaffold(body: Center(child: Text('Loading....'))),
          );
        } else {
          isUserLoggedIn = snapshot.data?.getBool(kKeepMeLoggedIn) ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ModelHud>(create: (context) => ModelHud()),
              ChangeNotifierProvider<CartItem>(create: (context) => CartItem()),
              ChangeNotifierProvider<Favorites>(
                create: (context) => Favorites(),
              ),
              ChangeNotifierProvider<AdminMode>(
                create: (context) => AdminMode(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: isUserLoggedIn ? HomePage.id : LoginScreen.id,
              routes: {
                OrderDetails.id: (context) => OrderDetails(),
                OrdersScreen.id: (context) => OrdersScreen(),
                CartScreen.id: (context) => CartScreen(),
                FavoritesScreen.id: (context) => FavoritesScreen(),
                // ProductInfo.id: (context) => ProductInfo(),
                EditProduct.id: (context) => EditProduct(),
                ManageProducts.id: (context) => ManageProducts(),
                LoginScreen.id: (context) => LoginScreen(),
                SignupScreen.id: (context) => SignupScreen(),
                HomePage.id: (context) => HomePage(),
                AdminHome.id: (context) => AdminHome(),
                AddProduct.id: (context) => AddProduct(),
              },
            ),
          );
        }
      },
    );
  }
}
