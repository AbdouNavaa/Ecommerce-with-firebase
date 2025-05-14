import 'dart:ui';

import 'package:flutter_with_firebase/models/product.dart';
import 'package:flutter_with_firebase/provider/favorite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_with_firebase/screens/user/productInfo.dart';
import 'package:flutter_with_firebase/widgets/custom_bottom_nav.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  static String id = 'FavoritesScreen';

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _isFavorite = false;
  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<Favorites>(context).products;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Favorites', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_circle_left_outlined, color: Colors.black),
        ),
      ),
      body:
          products.isNotEmpty
              ? LayoutBuilder(
                builder: (context, constrains) {
                  print('products.length = ${products.length}');
                  print('Prodsucts = $products');
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .7,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          // height: screenHeight * .15,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                // fit: StackFit.expand,
                                children: [
                                  Container(
                                    height: screenHeight * .22,
                                    width:
                                        screenHeight *
                                        .18, // Or any width that fits well
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          '${products[index].pLocation}', // Ensure the path is correct
                                        ),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 10,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      splashColor: Colors.red.withOpacity(0.5),
                                      onTap: () {
                                        setState(() {
                                          _isFavorite = !_isFavorite;
                                          Provider.of<Favorites>(
                                            context,
                                            listen: false,
                                          ).deleteProduct(products[index]);
                                          // Navigator.pop(context);
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                        child: Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 10,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      splashColor: Colors.grey.withOpacity(0.5),
                                      onTap: () {
                                        setState(() {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => ProductInfo(
                                                    arguments: products[index],
                                                    color: Color(0xFF4482AF),
                                                  ),
                                            ),
                                          );
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                        child: Icon(
                                          Icons.info_outline,
                                          color: Colors.grey,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                products[index].pName.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '\$${products[index].pPrice}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
              : Center(
                child: Text(
                  'No Products Found',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
      bottomNavigationBar: CustomBottomNav(
        isAdmin: false,
        currentIndex: _bottomBarIndex,
        onTap: (index) {
          setState(() {
            _bottomBarIndex = index;
          });
        },
      ),
    );
  }

  int _bottomBarIndex = 0;
}
