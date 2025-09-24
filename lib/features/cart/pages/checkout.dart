import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/bloc/button/button_state_cubit.dart';
import '../../../common/helper/cart/cart.dart';
import '../../../common/widgets/button/basic_reactive_button.dart';
import '../../order/data/models/order_registration_req.dart';
import '../../order/data/models/order_status.dart';
import '../../order/domain/entities/product_ordered.dart';
import '../../order/domain/usecases/order_registration.dart';
import 'package:flutter/material.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/helper/navigator/app_navigator.dart';
import '../../../common/widgets/appbar/app_bar.dart';
import 'order_placed.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';
import '../../../core/resources/app_strings.dart';

class CheckOutPage extends StatelessWidget {
  final List<ProductOrderedEntity> products;
  CheckOutPage({required this.products, super.key});

  final TextEditingController _addressCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(title: Text(context.tr(AppStrings.checkout))),
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonSuccessState) {
              var snackbar = SnackBar(
                content: Text(state.successMessage!),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              AppNavigator.pushAndRemove(context, const OrderPlacedPage());
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Builder(
              builder: (context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _addressField(context),
                    BasicReactiveButton(
                      content: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${CartHelper.calculateCartSubtotal(products)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              context.tr(AppStrings.placed),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        if (_addressCon.text.isNotEmpty) {
                          context.read<ButtonStateCubit>().execute(
                            usecase: OrderRegistrationUseCase(),
                            params: OrderRegistrationReq(
                              products: products,
                              createdDate: DateTime.now().toString(),
                              itemCount: products.length,
                              totalPrice: CartHelper.calculateCartSubtotal(
                                products,
                              ),
                              shippingAddress: _addressCon.text,
                              code: generateOrderCode(),
                              orderStatus: [
                                OrderStatusModel(
                                  title: 'Order Placed',
                                  done: true,
                                  createdDate: Timestamp.fromDate(
                                    DateTime.now(),
                                  ),
                                ),
                                OrderStatusModel(
                                  title: 'Order Confirmed',
                                  done: true,
                                  createdDate: Timestamp.fromDate(
                                    DateTime.now(),
                                  ),
                                ),
                                OrderStatusModel(
                                  title: 'Shipped',
                                  done: false,
                                  createdDate: Timestamp.fromDate(
                                    DateTime.now(),
                                  ),
                                ),

                                OrderStatusModel(
                                  title: 'Delivered',
                                  done: false,
                                  createdDate: Timestamp.fromDate(
                                    DateTime.now(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          var snackbar = SnackBar(
                            content: Text(
                              context.tr(AppStrings.enterShippingAddress),
                            ),
                            behavior: SnackBarBehavior.floating,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  //code automatic

  String generateOrderCode() {
    final random = Random();
    final code =
        random.nextInt(9000) + 1000; // Génère un nombre entre 1000 et 9999
    return code.toString();
  }

  Widget _addressField(BuildContext context) {
    return TextField(
      controller: _addressCon,
      minLines: 2,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: context.tr(AppStrings.addressShipping),
      ),
    );
  }
}
