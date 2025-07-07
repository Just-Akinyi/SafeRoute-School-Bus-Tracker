import 'package:flutter/material.dart';
import 'package:saferoute/theme/colors.dart';
import 'package:saferoute/theme/text_styles.dart';
import 'package:saferoute/theme/button_styles.dart';
import 'package:saferoute/theme/tabbar_theme.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    primaryColor: AppColors.primaryOrange,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryOrange,
      foregroundColor: AppColors.white,
      centerTitle: true,
      elevation: 1,
    ),
    tabBarTheme: AppTabBarTheme.light,
    listTileTheme: const ListTileThemeData(
      textColor: AppColors.darkText,
      iconColor: AppColors.primaryOrange,
    ),
    iconTheme: const IconThemeData(color: AppColors.primaryOrange),
    textTheme: TextTheme(
      titleLarge: AppTextStyles.title,
      bodyMedium: AppTextStyles.body,
      labelSmall: AppTextStyles.caption,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: AppButtonStyles.elevated,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: AppButtonStyles.outlined,
    ),
    textButtonTheme: TextButtonThemeData(style: AppButtonStyles.text),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: AppColors.successGreen,
      error: AppColors.alertRed,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: AppColors.primaryOrange,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryOrange,
      foregroundColor: Colors.black,
    ),
    tabBarTheme: AppTabBarTheme.dark,
    iconTheme: const IconThemeData(color: AppColors.white),
    textTheme: TextTheme(
      titleLarge: AppTextStyles.titleWhite,
      bodyMedium: AppTextStyles.body,
      labelSmall: AppTextStyles.caption,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: AppButtonStyles.elevated,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: AppButtonStyles.outlined,
    ),
    textButtonTheme: TextButtonThemeData(style: AppButtonStyles.text),
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryOrange,
      secondary: AppColors.successGreen,
      error: AppColors.alertRed,
    ),
  );
}
