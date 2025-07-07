import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );

  static const body = TextStyle(fontSize: 16, color: AppColors.darkText);

  static const caption = TextStyle(fontSize: 12, color: AppColors.darkText);

  static const titleWhite = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
}
