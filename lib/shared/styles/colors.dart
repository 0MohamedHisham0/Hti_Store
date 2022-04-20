import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

const defaultColor = MaterialColor(
  0xFF16234D,
  <int, Color>{
    50: Color(0xFF16234D),
    100: Color(0xFF16234D),
    200: Color(0xFF16234D),
    300: Color(0xFF16234D),
    400: Color(0xFF16234D),
    500: Color(0xFF16234D),
    600: Color(0xFF16234D),
    700: Color(0xFF16234D),
    800: Color(0xFF16234D),
    900: Color(0xFF16234D),
  },
);

const defaultColorDark = MaterialColor(
  0xFF16234D,
  <int, Color>{
    50: Color(0xFF3459C9),
    100: Color(0xFF3459C9),
    200: Color(0xFF3459C9),
    300: Color(0xFF3459C9),
    400: Color(0xFF3459C9),
    500: Color(0xFF3459C9),
    600: Color(0xFF3459C9),
    700: Color(0xFF3459C9),
    800: Color(0xFF3459C9),
    900: Color(0xFF3459C9),
  },
);
