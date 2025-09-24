import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/core/configs/theme/app_colors.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';
import 'package:flutter_with_firebase/features/home/pages/homePage.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../core/constants.dart';
import '../../../../core/resources/app_strings.dart';
import '../../../../models/product.dart';
import '../../../../services/store.dart';
import '../../../../widgets/custom_textfield.dart';

// Ajoute dans pubspec.yaml : url_launcher: ^6.2.5
import 'package:url_launcher/url_launcher.dart';

class AddProduct extends StatefulWidget {
  static String id = 'AddProduct';

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final _store = Store();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageLocationController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageLocationController.dispose();
    super.dispose();
  }

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _store.addProduct(
        Product(
          pName: _nameController.text.trim(),
          pPrice: _priceController.text.trim(),
          pDescription: _descriptionController.text.trim(),
          pLocation: _imageLocationController.text.trim(),
          pCategory: _categoryController.text.trim(),
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Produit ajouté avec succès'),
          backgroundColor: kBnbColorAccentDark,
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.of(context).pushReplacementNamed(HomePage.id);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.addProduct),
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
        // padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Spacer(flex: 2),
              CustomTextField(
                controller: _nameController,
                hint: context.tr(AppStrings.productName),
                icon: LineAwesomeIcons.product_hunt,
                keyboardType: TextInputType.text,
              ),
              const Spacer(),

              CustomTextField(
                controller: _priceController,
                hint: context.tr(AppStrings.productPrice),
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),
              const Spacer(),

              CustomTextField(
                controller: _descriptionController,
                hint: context.tr(AppStrings.productDescription),
                icon: Icons.description,
                keyboardType: TextInputType.text,
              ),
              const Spacer(),

              CustomTextField(
                controller: _categoryController,
                hint: context.tr(AppStrings.productCategory),
                icon: Icons.category,
                keyboardType: TextInputType.text,
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
                  label: Text(
                    context.tr(AppStrings.openBrowser),
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
                hint: context.tr(AppStrings.imageUrl),
                icon: Icons.image,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                            context.tr(AppStrings.save),
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
