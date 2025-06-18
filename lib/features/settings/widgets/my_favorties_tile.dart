import 'package:flutter/material.dart';

import '../../../common/navigator/app_navigator.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../product/presentation/pages/FavoritesScreen.dart';

class MyFavortiesTile extends StatelessWidget {
  const MyFavortiesTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppNavigator.push(context, const MyFavoritesPage());
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? AppColors.secondBackground
                  : AppColors.thirdBackground,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Favorites',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}
