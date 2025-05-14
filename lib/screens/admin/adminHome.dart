import 'package:flutter_with_firebase/widgets/custom_bottom_nav.dart';

import '../../constants.dart';
import '../../screens/admin/OrdersScreen.dart';
import '../../screens/admin/addProduct.dart';
import '../../screens/admin/manageProduct.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  static String id = 'AdminHome';

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _bottomBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: double.infinity),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AddProduct.id,
                (route) => false,
              );
            },
            child: Text('Add Product'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, ManageProducts.id);
            },
            child: Text('Edit Product'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, OrdersScreen.id);
            },
            child: Text('View orders'),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _bottomBarIndex,
        onTap: (index) {
          setState(() {
            _bottomBarIndex = index;
          });
          // Ajoutez ici toute logique supplémentaire si nécessaire
        },
        isAdmin: true, // Passer true pour le mode admin
      ),
    );
  }
}
