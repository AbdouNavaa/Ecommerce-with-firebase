import 'package:flutter/material.dart';

import '../../../common/navigator/app_navigator.dart';
import '../../../common/widgets/button/basic_app_button.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants.dart';
import '../../home/pages/homePage.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';
import '../../../core/resources/app_strings.dart';

class OrderPlacedPage extends StatelessWidget {
  const OrderPlacedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(AppImages.orderPlaced),
          ),
          const SizedBox(height: 60),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 300,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: AppColors.secondBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.tr(AppStrings.orderPlaced),
                    style: TextStyle(
                      color: themeColors(
                        context,
                        AppColors.primary,
                        AppColors.thirdBackground,
                      ),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 30),
                  BasicAppButton(
                    title: context.tr(AppStrings.finish),
                    onPressed: () {
                      AppNavigator.pushAndRemove(context, HomePage());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
