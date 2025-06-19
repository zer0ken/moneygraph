import 'package:flutter/material.dart';
import 'package:moneygraph/constants/app_colors.dart';

class AppTextTheme {
  // 기본 폰트 크기
  static const _displayLargeSize = 32.0;
  static const _displayMediumSize = 28.0;
  static const _displaySmallSize = 24.0;
  static const _headlineMediumSize = 20.0;
  static const _titleLargeSize = 18.0;
  static const _titleMediumSize = 16.0;
  static const _titleSmallSize = 14.0;
  static const _bodyLargeSize = 16.0;
  static const _bodyMediumSize = 14.0;
  static const _bodySmallSize = 12.0;
  static const _labelLargeSize = 14.0;
  static const _labelMediumSize = 12.0;
  static const _labelSmallSize = 11.0;

  // 기본 레터 스페이싱
  static const _defaultLetterSpacing = 0.0;
  static const _titleLetterSpacing = -0.5;
  static const _buttonLetterSpacing = 0.5;

  // 기본 텍스트 테마
  static const TextTheme base = TextTheme(
    // Display styles
    displayLarge: TextStyle(
      fontSize: _displayLargeSize,
      fontWeight: FontWeight.bold,
      letterSpacing: _defaultLetterSpacing,
      height: 1.2,
    ),
    displayMedium: TextStyle(
      fontSize: _displayMediumSize,
      fontWeight: FontWeight.bold,
      letterSpacing: _defaultLetterSpacing,
      height: 1.2,
    ),
    displaySmall: TextStyle(
      fontSize: _displaySmallSize,
      fontWeight: FontWeight.bold,
      letterSpacing: _defaultLetterSpacing,
      height: 1.2,
    ),
    
    // Headline styles
    headlineMedium: TextStyle(
      fontSize: _headlineMediumSize,
      fontWeight: FontWeight.w600,
      letterSpacing: _titleLetterSpacing,
      height: 1.3,
    ),
    
    // Title styles
    titleLarge: TextStyle(
      fontSize: _titleLargeSize,
      fontWeight: FontWeight.w600,
      letterSpacing: _titleLetterSpacing,
      height: 1.3,
    ),
    titleMedium: TextStyle(
      fontSize: _titleMediumSize,
      fontWeight: FontWeight.w500,
      letterSpacing: _titleLetterSpacing,
      height: 1.3,
    ),
    titleSmall: TextStyle(
      fontSize: _titleSmallSize,
      fontWeight: FontWeight.w500,
      letterSpacing: _titleLetterSpacing,
      height: 1.3,
    ),
    
    // Body styles
    bodyLarge: TextStyle(
      fontSize: _bodyLargeSize,
      fontWeight: FontWeight.normal,
      letterSpacing: _defaultLetterSpacing,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: _bodyMediumSize,
      fontWeight: FontWeight.normal,
      letterSpacing: _defaultLetterSpacing,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontSize: _bodySmallSize,
      fontWeight: FontWeight.normal,
      letterSpacing: _defaultLetterSpacing,
      height: 1.5,
    ),
    
    // Label styles
    labelLarge: TextStyle(
      fontSize: _labelLargeSize,
      fontWeight: FontWeight.w500,
      letterSpacing: _buttonLetterSpacing,
      height: 1.4,
    ),
    labelMedium: TextStyle(
      fontSize: _labelMediumSize,
      fontWeight: FontWeight.w500,
      letterSpacing: _buttonLetterSpacing,
      height: 1.4,
    ),
    labelSmall: TextStyle(
      fontSize: _labelSmallSize,
      fontWeight: FontWeight.w500,
      letterSpacing: _buttonLetterSpacing,
      height: 1.4,
    ),
  );

  // 라이트 테마용 텍스트 테마
  static TextTheme get light => base.apply(
        bodyColor: AppColors.lightColorScheme.onSurface,
        displayColor: AppColors.lightColorScheme.onSurface,
      );

  // 다크 테마용 텍스트 테마
  static TextTheme get dark => base.apply(
        bodyColor: AppColors.darkColorScheme.onSurface,
        displayColor: AppColors.darkColorScheme.onSurface,
      );
}
