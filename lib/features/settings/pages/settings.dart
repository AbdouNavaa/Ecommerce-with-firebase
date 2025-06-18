import '../../../common/widgets/appbar/app_bar.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../widgets/my_favorties_tile.dart';
import '../widgets/my_orders_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDark(context) ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [MyFavortiesTile(), SizedBox(height: 15), MyOrdersTile()],
        ),
      ),
    );
  }
}
