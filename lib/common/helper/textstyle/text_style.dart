import 'package:flutter/material.dart';

Text myText(text, color, double size, FontWeight? fontWeight) {
  return Text(
    text,
    style: TextStyle(color: color, fontSize: size, fontWeight: fontWeight),
  );
}
