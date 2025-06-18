import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_firebase/core/configs/theme/app_colors.dart';

import '../../../../common/bloc/button/button_state.dart';
import '../../../../common/bloc/button/button_state_cubit.dart';
import '../../../../common/helper/product/product_price.dart';
import '../../../../common/widgets/button/basic_reactive_button.dart';
import '../../../order/data/models/add_to_cart_req.dart';
import '../../../order/domain/usecases/add_to_cart.dart';
import '../../domain/entities/product.dart';
import '../cubit/product_quantity_cubit.dart';

class AddToBag extends StatelessWidget {
  final ProductEntity productEntity;
  const AddToBag({required this.productEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ButtonStateCubit, ButtonState>(
      // listenWhen: (previous, current) =>  previous != current is ButtonSuccessState || previous != current is ButtonInitialState,
      listener: (context, state) {
        if (state is ButtonSuccessState) {
          // AppNavigator.push(context, const CartPage());
          var snackbar = SnackBar(
            content: Text(state.successMessage!),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
        if (state is ButtonFailureState) {
          var snackbar = SnackBar(
            content: Text(state.errorMessage),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: BasicReactiveButton(
            color: AppColors.background,
            onPressed: () {
              context.read<ButtonStateCubit>().execute(
                usecase: AddToCartUseCase(),
                params: AddToCartReq(
                  productId: productEntity.pId!,
                  productTitle: productEntity.pName!,
                  productQuantity: context.read<ProductQuantityCubit>().state,
                  // productColor: productEntity.colors[context.read<ProductColorSelectionCubit>().selectedIndex].title,
                  // productSize: productEntity.sizes[context.read<ProductSizeSelectionCubit>().selectedIndex],
                  productPrice: double.parse(productEntity.pPrice!.toString()),
                  totalPrice:
                      ProductPriceHelper.provideCurrentPrice(productEntity) *
                      context.read<ProductQuantityCubit>().state,
                  productImage: productEntity.pLocation!,
                  createdDate: DateTime.now().toString(),
                ),
              );
            },
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<ProductQuantityCubit, int>(
                  builder: (context, state) {
                    var price =
                        ProductPriceHelper.provideCurrentPrice(productEntity) *
                        state;
                    return Text(
                      "\$${price.toString()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    );
                  },
                ),
                const Text(
                  'Add to Bag',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
