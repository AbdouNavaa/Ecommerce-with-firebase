import 'dart:math';

import 'package:flutter_with_firebase/provider/favorite.dart';
import 'package:flutter_with_firebase/screens/user/homePage.dart';
import 'package:ionicons/ionicons.dart';

import '../../constants.dart';
import '../../models/product.dart';
import '../../provider/cartItem.dart';
import '../../screens/user/CartScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductInfo extends StatefulWidget {
  static String id = 'ProductInfo';
  Color color;
  Product arguments;
  ProductInfo({Key? key, this.color = Colors.green, required this.arguments})
    : super(key: key);
  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    Product? product = ModalRoute.of(context)?.settings.arguments as Product?;
    return Scaffold(
      backgroundColor: widget.color,
      appBar: AppBar(
        backgroundColor: widget.color,
        automaticallyImplyLeading: false, // Cache le bouton retour par défaut
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_circle_left_outlined, // Icône personnalisée
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context); // Retour à la page précédente
              },
            ),
            IconButton(
              icon: Icon(Ionicons.cart_outline, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.id);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Flexible(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 380),
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage(widget.arguments!.pLocation.toString()),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Flexible(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: MediaQuery.of(context).size.height * .28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.arguments.pName.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            // widget.arguments.pDescription.toString(),
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '\$${widget.arguments.pPrice}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: kMainColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: Material(
                                      color: kMainColor,
                                      child: GestureDetector(
                                        onTap: add,
                                        child: SizedBox(
                                          child: Icon(Icons.add),
                                          height: 32,
                                          width: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    _quantity.toString().length < 2
                                        ? '0' + _quantity.toString()
                                        : _quantity.toString(),
                                    style: TextStyle(fontSize: 28),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: kMainColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: Material(
                                      color: kMainColor,
                                      child: GestureDetector(
                                        onTap: subtract,
                                        child: SizedBox(
                                          child: Icon(Icons.remove),
                                          height: 32,
                                          width: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  addToFavorites(context, widget.arguments);
                                },
                                icon: Icon(
                                  Ionicons.heart_circle,
                                  size: 30,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: Icon(
                                  Icons.shopping_cart_checkout_rounded,
                                  color: widget.color,
                                  size: 34,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: widget.color,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                              ),
                              SizedBox(width: 20),
                              ButtonTheme(
                                minWidth:
                                    MediaQuery.of(context).size.width * .67,
                                height:
                                    MediaQuery.of(context).size.height * .07,
                                child: Builder(
                                  builder:
                                      (context) => MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        color: widget.color,
                                        onPressed: () {
                                          addToCart(context, widget.arguments);
                                        },
                                        child: Text(
                                          'Add to Cart'.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  subtract() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        print(_quantity);
      });
    }
  }

  add() {
    setState(() {
      _quantity++;
      print(_quantity);
    });
  }

  void addToCart(context, product) {
    CartItem cartItem = Provider.of<CartItem>(context, listen: false);
    widget.arguments.pQuantity = _quantity;
    bool exist = false;
    var productsInCart = cartItem.products;
    for (var productInCart in productsInCart) {
      if (productInCart.pName == widget.arguments.pName) {
        exist = true;
      }
    }
    if (exist) {
      ScaffoldMessenger.of(context).showSnackBar(
        mySnackbar(context, 'you\'ve added this item before', Colors.red),
      );
    } else {
      cartItem.addProduct(product);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(mySnackbar(context, 'Added to Cart', widget.color));
    }
  }

  //add to favorites
  void addToFavorites(context, product) {
    Favorites favorites = Provider.of<Favorites>(context, listen: false);
    bool exist = false;
    var productsInFavorites = favorites.products;
    for (var product in productsInFavorites) {
      if (product.pName == widget.arguments.pName) {
        exist = true;
      }
    }
    if (exist) {
      ScaffoldMessenger.of(context).showSnackBar(
        mySnackbar(context, 'you\'ve added this item before', Colors.red),
      );
    } else {
      favorites.addProduct(product);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(mySnackbar(context, 'Added to Favorites', widget.color));
    }
  }

  SnackBar mySnackbar(context, String text, Color color) {
    return SnackBar(
      margin: EdgeInsets.all(15),
      //if you want to do margin you must use floating
      behavior: SnackBarBehavior.floating,
      content: Text(text),
      backgroundColor: color,
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          //close the snackbar
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }
}
