import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../core/constants.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;
  final Color? backgroundColor;
  final bool hideBack;
  final double? height;
  const BasicAppbar({
    this.title,
    this.hideBack = false,
    this.action,
    this.backgroundColor,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      toolbarHeight: height ?? 80,
      title: title ?? const Text(''),
      titleSpacing: 0,
      actions: [action ?? Container()],
      leading:
          hideBack
              ? null
              : IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Ionicons.arrow_back_outline,
                  size: 20,
                  color: isDark(context) ? Colors.white : Colors.black87,
                ),
              ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 80);
}
