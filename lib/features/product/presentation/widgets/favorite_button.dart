import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../cubit/favorite_icon_cubit.dart';

class FavoriteButton extends StatelessWidget {
  final ProductEntity product;

  const FavoriteButton({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteIconCubit(),
      child: BlocBuilder<FavoriteIconCubit, bool>(
        builder: (context, isFavorite) {
          return IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              context.read<FavoriteIconCubit>().toggleFavorite(product);
            },
          );
        },
      ),
    );
  }
}
