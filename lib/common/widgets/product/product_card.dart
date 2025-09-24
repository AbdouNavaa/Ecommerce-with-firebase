import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../features/product/domain/entities/product.dart';
import '../../../features/product/presentation/pages/productInfo.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity productEntity;
  const ProductCard({required this.productEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        try {
          // print('Product Entity Info1: ${productEntity.pName}');
          // print('Product ID: ${productEntity.pId}');
          // print('Product Location: ${productEntity.pLocation}');

          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => ProductInfo(
                    arguments: productEntity,
                    color: AppColors.secondBackground,
                  ),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error navigating to product details.'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.secondBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image:
                        productEntity.pLocation != null &&
                                productEntity.pLocation!.startsWith('http')
                            ? NetworkImage(productEntity.pLocation!)
                            : AssetImage(productEntity.pLocation!)
                                as ImageProvider,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productEntity.pName!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          productEntity.pPrice! == 0
                              ? "${productEntity.pPrice}\$"
                              : "${productEntity.pPrice}\$",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          productEntity.pPrice == 0
                              ? ''
                              : "${productEntity.pPrice}\$",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white60,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
