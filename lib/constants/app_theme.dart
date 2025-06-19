import 'package:flutter/material.dart';
import 'package:moneygraph/constants/app_colors.dart';
import 'package:moneygraph/constants/app_text_theme.dart';
import 'package:moneygraph/constants/app_dimensions.dart';

class AppTheme {
  static final ThemeData _baseTheme = ThemeData(
    useMaterial3: true,

    // Cards
    cardTheme: CardThemeData(
      elevation: AppDimensions.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.md),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: AppDimensions.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.md),
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.sm),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.sm,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.sm),
          ),
        ),
      ),
    ),
  );

  // 라이트 테마
  static ThemeData lightTheme = _baseTheme.copyWith(
    colorScheme: AppColors.lightColorScheme,
    textTheme: AppTextTheme.light,
  );

  // 다크 테마
  static ThemeData darkTheme = _baseTheme.copyWith(
    colorScheme: AppColors.darkColorScheme,
    textTheme: AppTextTheme.dark,
  );
}
