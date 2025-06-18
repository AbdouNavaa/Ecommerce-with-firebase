import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_firebase/features/product/domain/entities/product.dart';
import '../../../../common/widgets/product/product_card.dart';
import '../cubit/get_porducts_cubit.dart';
import '../cubit/get_porducts_state.dart';
import 'package:flutter/material.dart';

Widget ProductsView(String pCategory, List<ProductEntity> allProducts) {
  // List<ProductEntity> products;
  // products = getProductByCategory(pCategory, allProducts);
  return BlocBuilder<ProductCubit, ProductState>(
    builder: (context, state) {
      if (state is ProductLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is ProductLoaded) {
        final products =
            state.products
                .where((product) => product.pCategory == pCategory)
                .toList();
        // for (var doc in products) {
        //   print('Abdou1 data: ${doc.pCategory}');
        // }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: .65,
            crossAxisSpacing: .1,
            mainAxisSpacing: 1,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProductCard(productEntity: products[index]),
            );
          },
        );
      } else if (state is ProductError) {
        return Center(child: Text('Error: ${state.message}'));
      } else {
        return Center(child: Text('No Products Found'));
      }
    },
  );
}
