// lib/theme/tabbar_theme.dart
import 'package:flutter/material.dart';
import 'colors.dart';

class AppTabBarTheme {
  static final TabBarTheme light = TabBarTheme(
    labelColor: AppColors.white,
    unselectedLabelColor: Colors.white70,
    indicator: const UnderlineTabIndicator(
      borderSide: BorderSide(color: AppColors.white, width: 2),
    ),
  );

  static final TabBarTheme dark = TabBarTheme(
    labelColor: Colors.black,
    unselectedLabelColor: Colors.black54,
    indicator: const UnderlineTabIndicator(
      borderSide: BorderSide(color: Colors.black, width: 2),
    ),
  );
}
