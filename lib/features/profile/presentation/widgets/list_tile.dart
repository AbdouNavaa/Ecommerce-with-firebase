import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;
  const MyListTile({
    required this.title,
    required this.icon,
    this.onTap,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      leading: IconButton(
        icon: Icon(icon, color: Color(0xFF6484FF)),
        onPressed: onTap,
        style: IconButton.styleFrom(
          backgroundColor: Color(0xFFF0F4FF),
          shape: const RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: onTap,
    );
  }
}
