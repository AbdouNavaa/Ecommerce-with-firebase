import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/screens/admin/addProduct.dart';
import 'package:flutter_with_firebase/screens/user/CartScreen.dart';
import 'package:flutter_with_firebase/screens/user/FavoritesScreen.dart';
import 'package:flutter_with_firebase/screens/user/homePage.dart';
import '../../constants.dart';
import '../../screens/login_screen.dart';
import '../../services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ionicons/ionicons.dart';

class CustomBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isAdmin;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.isAdmin,
  }) : super(key: key);

  @override
  _CustomBottomNavState createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  final _auth = Auth();
  int isSelected = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildTabItem(0, Ionicons.home, 'Home'),
              _buildTabItem(1, Ionicons.search, 'Search'),
              widget.isAdmin
                  ? _buildTabItem(2, Ionicons.add_circle_outline, 'Add')
                  : _buildTabItem(2, Ionicons.heart_circle_outline, 'Wishlist'),

              widget.isAdmin
                  ? _buildTabItem(2, Ionicons.cart_sharp, 'Order')
                  : _buildTabItem(3, Ionicons.cart_outline, 'Cart'),
              _buildTabItem(4, Ionicons.person_outline, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int pos, IconData icon, String name) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = pos;
        });
        widget.onTap(pos);
        if (pos == 0) {
          Navigator.pushNamed(context, HomePage.id);
        }
        if (pos == 2) {
          widget.isAdmin
              ? Navigator.pushNamedAndRemoveUntil(
                context,
                AddProduct.id,
                (route) => false,
              )
              : Navigator.pushNamed(context, FavoritesScreen.id);
        }
        if (pos == 3) {
          _auth.signOut();
          SharedPreferences.getInstance().then((pref) {
            pref.clear();
            Navigator.pushNamed(context, CartScreen.id);
          });
        }

        if (pos == 4 && widget.isAdmin) {
          print('pos: $pos');
          _auth.signOut();
          SharedPreferences.getInstance().then((pref) {
            pref.clear();
            Navigator.pushNamed(context, CartScreen.id);
          });
        }
      },
      child: SizedBox(
        height: 36,
        width: 36,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
