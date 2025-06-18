import 'package:flutter_with_firebase/features/admin/presentation/pages/admin_products.dart';
import 'package:ionicons/ionicons.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/navigator/app_navigator.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/constants.dart';
import '../../../product/domain/entities/product.dart';
import '../../../../models/product.dart';
import '../../../../services/store.dart';
import '../../../../widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class EditProduct extends StatefulWidget {
  static String id = 'EditProduct';

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final _store = Store();

  final _nameController = TextEditingController();

  final _priceController = TextEditingController();

  final _descriptionController = TextEditingController();

  final _categoryController = TextEditingController();

  final _imageLocationController = TextEditingController();
  bool _isLoading = false;
  Future<void> _editProduct(ProductEntity product) async {
    if (!_globalKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _store.editProduct({
        kProductName: _nameController.text,
        kProductPrice: _priceController.text,
        kProductDescription: _descriptionController.text,
        kProductCategory: _categoryController.text,

        kProductLocation: _imageLocationController.text,
        'pId': product.pId,
        'pQuantity': product.pQuantity,
      }, product.pId);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Produit ajouté avec succès'),
          backgroundColor: kBnbColorAccentDark,
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width_size = MediaQuery.of(context).size.width;
    ProductEntity product =
        ModalRoute.of(context)?.settings.arguments as ProductEntity;
    setState(() {
      _nameController.text = product.pName!;
      _priceController.text = product.pPrice!;
      _descriptionController.text = product.pDescription!;
      _categoryController.text = product.pCategory!;
      _imageLocationController.text = product.pLocation!;
    });
    return Scaffold(
      // backgroundColor: kBnbColorAccentDark,
      appBar: AppBar(
        title: Text(
          'Edit Product',
          style: TextStyle(
            color: isDark(context) ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left_sharp,
            color: isDark(context) ? Colors.white : Colors.black,
            size: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              CustomTextField(
                controller: _nameController,
                hint: 'Product Name',
                keyboardType: TextInputType.name,
                icon: Icons.production_quantity_limits,
              ),
              const Spacer(),
              CustomTextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                hint: 'Product Price',
                icon: Icons.attach_money,
              ),
              const Spacer(),
              CustomTextField(
                controller: _descriptionController,
                keyboardType: TextInputType.text,
                hint: 'Product Description',
                icon: Icons.description,
              ),
              const Spacer(),
              CustomTextField(
                controller: _categoryController,
                keyboardType: TextInputType.name,
                hint: 'Product Category',
                icon: Icons.category,
              ),
              const Spacer(),

              // Bouton pour ouvrir le navigateur
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.open_in_browser,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'Shoose image from google',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    final url = Uri.parse('https://images.google.com/');
                    if (await canLaunchUrl(url)) {
                      // await launchUrl(url, mode: LaunchMode.externalApplication);
                      await launchUrl(url, mode: LaunchMode.platformDefault);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Impossible d\'ouvrir le navigateur'),
                        ),
                      );
                    }
                  },
                ),
              ),

              const Spacer(),

              // Champ pour coller l'URL de l'image
              CustomTextField(
                controller: _imageLocationController,
                hint: 'Paste image URL',
                icon: Icons.image,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  onPressed: () => _isLoading ? null : _editProduct(product),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Edit',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
              const Spacer(flex: 6),
            ],
          ),
        ),
      ),
    );
  }
}
