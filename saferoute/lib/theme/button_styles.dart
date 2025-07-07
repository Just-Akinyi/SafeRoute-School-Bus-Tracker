import 'package:flutter/material.dart';
import 'colors.dart';

class AppButtonStyles {
  static final elevated = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryOrange,
    foregroundColor: AppColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
  );

  static final outlined = OutlinedButton.styleFrom(
    foregroundColor: AppColors.primaryOrange,
    side: const BorderSide(color: AppColors.primaryOrange),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
  );

  static final text = TextButton.styleFrom(
    foregroundColor: AppColors.primaryOrange,
  );
}
