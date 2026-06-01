import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xff0b0b0b);
  static const Color cards = Color(0xff010100);
  static const Color primary = Color(0xffffffff);
  static const Color secondary = Color(0xffBDBDBD);
}

class AppThemes {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.background,
      useMaterial3: true,
    );
  }
}
