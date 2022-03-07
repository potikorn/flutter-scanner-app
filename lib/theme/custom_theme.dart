import 'package:flutter/material.dart';

class CustomTheme {
  static const MaterialColor bringooprimary =
      MaterialColor(_bringooprimaryPrimaryValue, <int, Color>{
    50: Color(0xFFE6F8EA),
    100: Color(0xFFC0EFCA),
    200: Color(0xFF96E4A6),
    300: Color(0xFF6BD982),
    400: Color(0xFF4CD068),
    500: Color(_bringooprimaryPrimaryValue),
    600: Color(0xFF27C246),
    700: Color(0xFF21BB3D),
    800: Color(0xFF1BB434),
    900: Color(0xFF10A725),
  });
  static const int _bringooprimaryPrimaryValue = 0xFF2CC84D;

  static const MaterialColor bringooprimaryAccent =
      MaterialColor(_bringooprimaryAccentValue, <int, Color>{
    100: Color(0xFFD7FFDB),
    200: Color(_bringooprimaryAccentValue),
    400: Color(0xFF71FF80),
    700: Color(0xFF58FF6A),
  });
  static const int _bringooprimaryAccentValue = 0xFFA4FFAE;
}
