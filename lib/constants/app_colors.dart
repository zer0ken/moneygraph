import 'package:flutter/material.dart';

class AppColors {
  // Material 3 color scheme
  static const Color seedColor = Color(0xFF43A047); // Primary color as seed
  
  // Light color scheme
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  );
  // surface color for light theme
  static const Color surface = Color.fromARGB(255, 246, 247, 244); // Light surface color

  // Dark color scheme
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  );
  // surface color for dark theme
  static const Color darkSurface = Color(0xFF202020); // Dark surface color

  // Custom colors not included in the color scheme
  static const Color incomeColor = Color(0xFF4CAF50); // Green
  static const Color expenseColor = Color(0xFFF44336); // Red
  static const Color savingsColor = Color(0xFF9C27B0); // Purple
  
  // Additional custom semantic colors
  static const Color successLight = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF81C784);
  static const Color warningLight = Color(0xFFFFA726);
  static const Color warningDark = Color(0xFFFFB74D);
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorDark = Color(0xFFEF5350);
}
