import 'package:flutter_with_firebase/constants.dart';
import 'package:flutter_with_firebase/screens/admin/adminHome.dart';
import 'package:ionicons/ionicons.dart';

import '../../models/product.dart';
import '../../widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import '../../services/store.dart';

class AddProduct extends StatelessWidget {
  static String id = 'AddProduct';
  late String _name = '';
  late String _price = '';
  late String _description = '';
  late String _category = '';
  late String _imageLocation = '';

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store = Store();
  @override
  Widget build(BuildContext context) {
    double width_size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBnbColorAccentDark,
      appBar: AppBar(
        backgroundColor: kBnbColorAccentDark,
        title: Text(
          'Add Product',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Ionicons.chevron_back_circle_outline,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(AdminHome.id);
          },
        ),
      ),
      body: Form(
        key: _globalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            CustomTextField(
              hint: 'Product Name',
              onClick: (value) {
                _name = value!;
              },
              icon: Icons.production_quantity_limits,
            ),
            CustomTextField(
              onClick: (value) {
                _price = value!;
              },
              hint: 'Product Price',
              icon: Icons.attach_money,
            ),
            CustomTextField(
              onClick: (value) {
                _description = value!;
              },
              hint: 'Product Description',
              icon: Icons.description,
            ),
            CustomTextField(
              onClick: (value) {
                _category = value!;
              },
              hint: 'Product Category',
              icon: Icons.category,
            ),
            CustomTextField(
              onClick: (value) {
                _imageLocation = value!;
              },
              hint: 'Product Location',
              icon: Icons.image,
            ),
            // SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_globalKey.currentState!.validate()) {
                  _globalKey.currentState?.save();

                  try {
                    await _store.addProduct(
                      Product(
                        pName: _name,
                        pPrice: _price,
                        pDescription: _description,
                        pLocation: _imageLocation,
                        pCategory: _category,
                      ),
                    );

                    // Créer une nouvelle référence au contexte
                    final scaffoldContext = ScaffoldMessenger.of(context);
                    scaffoldContext.showSnackBar(
                      SnackBar(
                        content: Text('Produit ajouté'),
                        backgroundColor: kBnbColorAccentDark,
                        duration: Duration(seconds: 10),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {
                            Navigator.of(context).pushNamed(AdminHome.id);
                          },
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: ${e.toString()}')),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: kBnbColorAccentDark,
                surfaceTintColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: width_size * .3,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              child: Text(
                'Add Product',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
