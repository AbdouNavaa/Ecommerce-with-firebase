import 'dart:ui';

import 'package:flutter_with_firebase/widgets/custom_bottom_nav.dart';
import 'package:ionicons/ionicons.dart';

import '../../constants.dart';
import '../../models/product.dart';
import '../../provider/cartItem.dart';
import '../../screens/user/productInfo.dart';
import '../../services/store.dart';
import '../../widgets/custom_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static String id = 'CartScreen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<CartItem>(context).products;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      //  resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('My Cart', style: TextStyle(color: Colors.black)),
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
              ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      '${products.length} Items',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Provider.of<CartItem>(
                                  context,
                                  listen: false,
                                ).deleteProduct(products[index]);
                              },
                              child: Container(
                                width: screenWidth - 100,
                                height: screenHeight * .15,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      height: screenHeight,
                                      width: screenWidth * .15,
                                      decoration: BoxDecoration(
                                        color: kBnbColorAccentDark,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          IconButton(
                                            onPressed: () {
                                              Provider.of<CartItem>(
                                                context,
                                                listen: false,
                                              ).incrementQuantity(index);
                                            },
                                            icon: Icon(
                                              color: Colors.white,
                                              size: 25,
                                              Ionicons.add,
                                            ),
                                          ),
                                          Text(
                                            products[index].pQuantity
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Provider.of<CartItem>(
                                                context,
                                                listen: false,
                                              ).decrementQuantity(index);
                                              // if (products[index].pQuantity == 1) {
                                              //     Provider.of<CartItem>(
                                              //       context,
                                              //       listen: false,
                                              //     ).deleteProduct(products[index]);
                                              //   }
                                            },
                                            icon: Icon(
                                              color: Colors.white,
                                              size: 25,
                                              Ionicons.remove,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: screenHeight * .15,
                                      width: screenWidth * .4,
                                      decoration: BoxDecoration(
                                        // color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5),
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            products[index].pLocation
                                                .toString(),
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              products[index].pName.toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              '\$ ${products[index].pPrice}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: screenHeight,
                                      width: screenWidth * .15,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          Provider.of<CartItem>(
                                            context,
                                            listen: false,
                                          ).deleteProduct(products[index]);
                                        },
                                        icon: Icon(
                                          color: Colors.white,
                                          size: 25,
                                          Ionicons.trash_outline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: products.length,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: GestureDetector(
                      onTap: () {
                        _showBottomSheet(
                          context,
                          products,
                          screenWidth,
                          screenHeight,
                        );
                      },
                      child: Container(
                        width: screenWidth,
                        height: screenHeight * .07,
                        decoration: BoxDecoration(
                          color: kBnbColorAccentDark,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(
                          child: Text(
                            'Order Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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

  void _showBottomSheet(
    BuildContext context,
    List<Product> products,
    double screenWidth,
    double screenHeight,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: screenHeight * 0.3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              children: [
                MyRow('Sub Total', '\$ ${getTotallPrice(products)}'),
                SizedBox(height: 10),
                MyRow('Delivery', '\$ 10'),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                MyRow('Total Costs', '\$ ${getTotallPrice(products) + 10}'),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    showCustomDialog(products, context);
                  },
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * .07,
                    decoration: BoxDecoration(
                      color: kBnbColorAccentDark,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Center(
                      child: Text(
                        'Order Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showCustomDialog(List<Product> products, context) async {
    var price = getTotallPrice(products);
    var address;
    AlertDialog alertDialog = AlertDialog(
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            try {
              Store _store = Store();
              _store.storeOrders({
                kTotallPrice: price,
                kAddress: address,
              }, products);

              SnackBar(content: Text('Orderd Successfully'));
              Navigator.pop(context);
            } catch (ex) {
              print(ex.toString());
            }
          },
          child: Text('Confirm'),
        ),
      ],
      content: TextField(
        onChanged: (value) {
          address = value;
        },
        decoration: InputDecoration(hintText: 'Enter your Address'),
      ),
      title: Text('Totall Price  = \$ $price'),
    );
    await showDialog(
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }

  getTotallPrice(List<Product> products) {
    var price = 0;
    for (var product in products) {
      price += product.pQuantity! * int.parse(product.pPrice!);
    }
    return price;
  }

  Widget MyRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.black38,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
