import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/common/widgets/product/product_card.dart';
import 'package:flutter_with_firebase/features/home/widgets/empty_view.dart';
import 'package:flutter_with_firebase/features/product/domain/entities/product.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.context,
    required this.products,
    required this.categoryFilter,
  });

  final BuildContext context;
  final List<ProductEntity> products;
  final String categoryFilter;

  @override
  Widget build(BuildContext context) {
    final filteredProducts =
        products
            .where((product) => product.pCategory == categoryFilter)
            .toList();

    if (filteredProducts.isEmpty) return EmptyView(context: context);

    return GridView.builder(
      padding: const EdgeInsets.all(5),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 1,
        // mainAxisSpacing: 10,
      ),
      itemCount: filteredProducts.length,
      itemBuilder:
          (context, index) =>
              ProductCard(productEntity: filteredProducts[index]),
    );
  }
}
