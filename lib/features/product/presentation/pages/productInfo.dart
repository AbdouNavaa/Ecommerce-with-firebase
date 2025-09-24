import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_firebase/common/navigator/app_navigator.dart';
import 'package:flutter_with_firebase/core/configs/theme/app_colors.dart';
import 'package:flutter_with_firebase/features/product/domain/entities/product.dart';
import '../../../../common/bloc/button/button_state_cubit.dart';
import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../../core/constants.dart';
import '../../../admin/presentation/pages/editProduct.dart';
import '../../../cart/pages/cart.dart';
import '../cubit/favorite_icon_cubit.dart';
import '../../../../provider/cartItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cubit/product_quantity_cubit.dart';
import '../widgets/add_to_bag.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';
import '../../../../core/resources/app_strings.dart';

class ProductInfo extends StatelessWidget {
  static String id = 'ProductInfo';
  Color color;
  bool isAdmin;
  ProductEntity arguments;
  ProductInfo({
    Key? key,
    this.color = Colors.green,
    required this.arguments,
    this.isAdmin = false,
  }) : super(key: key);

  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  FavoriteIconCubit()..checkFavoriteStatus(arguments.pId!),
        ),
        BlocProvider(create: (context) => ButtonStateCubit()),
        BlocProvider(create: (context) => ProductQuantityCubit()),
      ],
      child: Scaffold(
        // backgroundColor: color,
        appBar: BasicAppbar(
          height: 60,
          backgroundColor: isDark(context) ? color : Colors.white,
          title: Text(context.tr(AppStrings.productDetails)),
          action:
              isAdmin
                  ? SizedBox.shrink()
                  : BlocBuilder<FavoriteIconCubit, bool>(
                    builder: (context, isFavorite) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color:
                                isFavorite
                                    ? Colors.red
                                    : isDark(context)
                                    ? Colors.white
                                    : Colors.black,
                            size: 28,
                          ),
                          onPressed: () {
                            context.read<FavoriteIconCubit>().toggleFavorite(
                              arguments,
                            );
                            // Optionnel: afficher un snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFavorite
                                      ? context.tr(
                                        AppStrings.removedFromFavorites,
                                      )
                                      : context.tr(AppStrings.addedToFavorites),
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
        ),

        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: h / 2.2,
                width: w,
                child: Image(
                  fit: BoxFit.cover,
                  image:
                      arguments.pLocation != null &&
                              arguments.pLocation!.startsWith('http')
                          ? NetworkImage(arguments.pLocation!)
                          : AssetImage(arguments.pLocation!) as ImageProvider,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Icon(Icons.error), // Fallback
                ),
              ),

              Container(
                width: w,
                height: h - h / 2.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(50),
                  //   topRight: Radius.circular(50),
                  // ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Padding(
                    padding: isAdmin ? EdgeInsets.all(18.0) : EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: SizedBox(
                            width: 80,
                            child: Divider(color: Colors.black, thickness: 2),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          arguments.pName.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          // arguments.pDescription.toString(),
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '\$${arguments.pPrice}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        isAdmin
                            ? SizedBox.fromSize()
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BlocBuilder<ProductQuantityCubit, int>(
                                  builder: (context, state) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: kMainColor,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          child: Material(
                                            // color: kUnActiveColor,
                                            color: AppColors.secondBackground,
                                            child: GestureDetector(
                                              // onTap: add,
                                              onTap: () {
                                                context
                                                    .read<
                                                      ProductQuantityCubit
                                                    >()
                                                    .increment();
                                              },
                                              child: SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          state.toString().length < 2
                                              ? '0$state'
                                              : state.toString(),
                                          style: TextStyle(
                                            fontSize: 28,
                                            color: Colors.black87,
                                          ),
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
                                            color: AppColors.secondBackground,
                                            child: GestureDetector(
                                              onTap: () {
                                                context
                                                    .read<
                                                      ProductQuantityCubit
                                                    >()
                                                    .decrement();
                                              },
                                              child: SizedBox(
                                                height: 25,
                                                width: 25,
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    AppNavigator.push(
                                      context,
                                      const CartPage(),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      // side: BorderSide(color: color, width: 1),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(10),
                                  ),
                                  child: Icon(
                                    Icons.shopping_cart_checkout_rounded,
                                    color: color,
                                    size: 34,
                                  ),
                                ),
                              ],
                            ),
                        SizedBox(height: 30),

                        // SizedBox(height: 60),
                        isAdmin
                            ? SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    EditProduct.id,
                                    arguments: arguments,
                                  );
                                },
                                child: Text(
                                  context.tr(AppStrings.editProduct),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            )
                            : AddToBag(productEntity: arguments),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: AddToBag(productEntity: arguments,),
      ),
    );
  }

  void addToCart(context, product) {
    CartItem cartItem = Provider.of<CartItem>(context, listen: false);
    arguments.pQuantity = _quantity;
    bool exist = false;
    var productsInCart = cartItem.products;
    for (var productInCart in productsInCart) {
      if (productInCart.pName == arguments.pName) {
        exist = true;
      }
    }
    if (exist) {
      ScaffoldMessenger.of(context).showSnackBar(
        mySnackbar(
          context,
          context.tr(AppStrings.productAddedToCart),
          Colors.red,
        ),
      );
    } else {
      cartItem.addProduct(product);
      ScaffoldMessenger.of(context).showSnackBar(
        mySnackbar(context, context.tr(AppStrings.productAddedToCart), color),
      );
    }
  }

  //add to favorites
  SnackBar mySnackbar(context, String text, Color color) {
    return SnackBar(
      margin: EdgeInsets.all(15),
      //if you want to do margin you must use floating
      behavior: SnackBarBehavior.floating,
      content: Text(text),
      backgroundColor: color,
      action: SnackBarAction(
        label: context.tr(AppStrings.yes),
        onPressed: () {
          //close the snackbar
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }
}
