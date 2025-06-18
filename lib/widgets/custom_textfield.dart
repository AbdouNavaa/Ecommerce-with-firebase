import 'package:flutter_with_firebase/core/configs/theme/app_colors.dart';

import '../core/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  // final FormFieldSetter<String> onClick;
  String? _errorMessage(String str) {
    switch (hint) {
      case 'Enter your name':
        return 'Name is empty !';
      case 'Enter your email':
        return 'Email is empty !';
      case 'Enter your password':
        return 'Password is empty !';
    }
  }

  final String initialValue;
  final TextEditingController controller;
  final TextInputType keyboardType;

  CustomTextField({
    // required this.onClick,
    required this.icon,
    required this.hint,
    this.initialValue = '',
    required this.controller,
    required this.keyboardType,
    //  required String? Function(dynamic value) validator,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        initialValue: controller.text == null ? initialValue : null,
        // initialValue: initialValue,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer un nom de produit';
          }
          return null;
        },
        // onSaved: onClick,
        obscureText: hint == 'Enter your password' ? true : false,
        cursorColor: kMainColor,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.background),
          hintStyle: TextStyle(color: Colors.black26),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
          focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
