// presentation/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/main.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: const Icon(Icons.language, color: Colors.blue),
        onPressed: () {
          Locale newLocale =
              Localizations.localeOf(context).languageCode == 'en'
                  ? const Locale('ar')
                  : const Locale('en');
          MyApp.setLocale(context, newLocale);
        },
      ),
    );
  }
}
