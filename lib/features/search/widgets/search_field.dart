import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/bloc/product/products_display_cubit.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../../core/constants.dart';

class SearchField extends StatelessWidget {
  SearchField({super.key});

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        controller: textEditingController,
        onChanged: (value) {
          if (value.isEmpty) {
            context.read<ProductsDisplayCubit>().displayInitial();
          } else {
            context.read<ProductsDisplayCubit>().displayProducts(params: value);
          }
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black26, width: .5),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black26, width: .5),
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: SvgPicture.asset(
            AppVectors.search,
            fit: BoxFit.none,
            colorFilter: ColorFilter.mode(
              isDark(context) ? Colors.white : Colors.black,
              BlendMode.srcIn,
            ),
          ),
          hintText: 'search',
        ),
      ),
    );
  }
}
