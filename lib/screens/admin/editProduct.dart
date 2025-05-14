import 'package:flutter_with_firebase/screens/admin/manageProduct.dart';
import 'package:ionicons/ionicons.dart';

import '../../constants.dart';
import '../../models/product.dart';
import '../../services/store.dart';
import '../../widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class EditProduct extends StatelessWidget {
  static String id = 'EditProduct';
  late String _name, _price, _description, _category, _imageLocation;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    double width_size = MediaQuery.of(context).size.width;
    Product product = ModalRoute.of(context)?.settings.arguments as Product;
    _name = product.pName!;
    _price = product.pPrice!;
    _description = product.pDescription!;
    _category = product.pCategory!;
    _imageLocation = product.pLocation!;
    return Scaffold(
      backgroundColor: kBnbColorAccentDark,
      appBar: AppBar(
        backgroundColor: kBnbColorAccentDark,
        title: Text(
          'Edit Product',
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
            Navigator.of(context).pushNamed(ManageProducts.id);
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
              initialValue: _name,
              hint: 'Product Name',
              onClick: (value) {
                _name = value!;
              },
              icon: Icons.production_quantity_limits,
            ),
            CustomTextField(
              initialValue: _price,
              onClick: (value) {
                _price = value!;
              },
              hint: 'Product Price',
              icon: Icons.attach_money,
            ),
            CustomTextField(
              initialValue: _description,
              onClick: (value) {
                _description = value!;
              },
              hint: 'Product Description',
              icon: Icons.description,
            ),
            CustomTextField(
              initialValue: _category,
              onClick: (value) {
                _category = value!;
              },
              hint: 'Product Category',
              icon: Icons.category,
            ),
            CustomTextField(
              initialValue: _imageLocation,
              onClick: (value) {
                _imageLocation = value!;
              },
              hint: 'Product Location',
              icon: Icons.image,
            ),
            TextButton(
              onPressed: () async {
                if (_globalKey.currentState!.validate()) {
                  _globalKey.currentState?.save();

                  try {
                    print('Pid: ${product.pId}');
                    await _store.editProduct({
                      kProductName: _name,
                      kProductLocation: _imageLocation,
                      kProductCategory: _category,
                      kProductDescription: _description,
                      kProductPrice: _price,
                    }, product.pId);

                    // Créer une nouvelle référence au contexte
                    final scaffoldContext = ScaffoldMessenger.of(context);
                    scaffoldContext.showSnackBar(
                      SnackBar(
                        content: Text('Produit modifié'),
                        backgroundColor: kBnbColorAccentDark,
                        duration: Duration(seconds: 10),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {
                            Navigator.of(context).pushNamed(ManageProducts.id);
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
                'Edit Product',
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
