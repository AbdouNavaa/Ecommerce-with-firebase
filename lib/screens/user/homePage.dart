import 'package:ionicons/ionicons.dart';

import '../../constants.dart';
import '../../models/product.dart';
import '../../screens/login_screen.dart';
import '../../screens/user/CartScreen.dart';
import '../../screens/user/productInfo.dart';
import '../../services/store.dart';
import '../../widgets/productView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/svg.dart';

import '../../functions.dart';
import '../../widgets/custom_bottom_nav.dart';

class HomePage extends StatefulWidget {
  static String id = 'HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = Auth();
  late User _loggedUser;
  int _tabBarIndex = 0;
  int _bottomBarIndex = 0;
  final _store = Store();
  late List<Product> _products = [];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: CustomBottomNav(
              currentIndex: _bottomBarIndex,
              onTap: (index) {
                setState(() {
                  _bottomBarIndex = index;
                });
                // Ajoutez ici toute logique supplémentaire si nécessaire
              },
              isAdmin: false, // Passer true pour le mode admin
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TabBar(
                    // Ensures tabs fill the entire width
                    tabAlignment: TabAlignment.fill,

                    // Make the indicator cover the entire tab width
                    indicator: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.black, width: 2),
                      ),
                      // borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: kMainColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    unselectedLabelColor: Colors.black45,
                    labelColor: Colors.black,
                    labelStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: TextStyle(fontSize: 16),
                    dividerColor: Colors.white,
                    onTap: (value) {
                      setState(() {
                        _tabBarIndex = value;
                      });
                    },
                    tabs: [
                      // Wrap each tab to ensure full-width clickable area
                      Tab(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text('Jackets', textAlign: TextAlign.center),
                        ),
                      ),
                      Tab(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text('Trouser', textAlign: TextAlign.center),
                        ),
                      ),
                      Tab(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text('T-shirts', textAlign: TextAlign.center),
                        ),
                      ),
                      Tab(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text('Shoes', textAlign: TextAlign.center),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                jacketView(),
                ProductsView(kTrousers, _products),
                ProductsView(kTshirts, _products),
                ProductsView(kShoes, _products),
              ],
            ),
          ),
        ),
        Material(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Discover'.toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.popAndPushNamed(context, LoginScreen.id);
                    },
                    child: Icon(Ionicons.log_out_outline),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    getCurrenUser();
  }

  getCurrenUser() async {
    try {
      final user = await _auth.getUser();
      if (user != null) {
        _loggedUser = user;
      } else {
        print("⚠️ L'utilisateur n'est pas connecté.");
      }
    } catch (e) {
      print("Une erreur s'est produite : $e");
    }
  }

  // Rest of the code remains the same as in the previous implementation
  Widget jacketView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.loadProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = [];
          for (var doc in snapshot.data?.docs ?? []) {
            var data = doc.data();
            products.add(
              Product(
                pId: 'doc.document.id',
                pPrice: data[kProductPrice],
                pName: data[kProductName],
                pDescription: data[kProductDescription],
                pLocation: data[kProductLocation],
                pCategory: data[kProductCategory],
              ),
            );
          }
          _products = [...products];
          products.clear();
          products = getProductByCategory(kJackets, _products);

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .8,
            ),
            itemBuilder:
                (context, index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ProductInfo(
                                arguments: products[index],
                                color:
                                    productColors[index % productColors.length],
                              ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        // color: productColors[index % productColors.length],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: AssetImage(
                                      products[index].pLocation.toString(),
                                    ),
                                    // colorFilter: ColorFilter.mode(
                                    //   productColors[index %
                                    //       productColors.length],
                                    //   BlendMode.srcIn,
                                    // ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: .8,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                color:
                                    productColors[index % productColors.length],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      products[index].pName.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '\$ ${products[index].pPrice}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            itemCount: products.length,
          );
        } else {
          return Center(child: Text('Loading...'));
        }
      },
    );
  }
}
