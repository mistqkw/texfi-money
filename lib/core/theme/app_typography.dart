import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Типографика: крупные плотные цифры для сумм, лёгкие подписи для текста.
abstract final class AppTypography {
  static TextStyle _inter({
    required double size,
    required FontWeight weight,
    Color color = AppColors.textPrimary,
    double? letterSpacing,
    List<FontFeature>? features,
  }) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      fontFeatures: features ?? const [FontFeature.tabularFigures()],
      height: 1.15,
    );
  }

  /// Баланс на главном экране.
  static TextStyle get balance =>
      _inter(size: 44, weight: FontWeight.w700, letterSpacing: -1);

  /// Крупная сумма (карточка транзакции, цель).
  static TextStyle get amountLarge =>
      _inter(size: 28, weight: FontWeight.w700, letterSpacing: -0.5);

  /// Сумма в строке списка.
  static TextStyle get amountMedium =>
      _inter(size: 17, weight: FontWeight.w600);

  static TextStyle get headline =>
      _inter(size: 20, weight: FontWeight.w600, features: const []);

  static TextStyle get title => _inter(
        size: 16,
        weight: FontWeight.w500,
        features: const [],
      );

  static TextStyle get body => _inter(
        size: 14,
        weight: FontWeight.w400,
        color: AppColors.textSecondary,
        features: const [],
      );

  static TextStyle get caption => _inter(
        size: 12,
        weight: FontWeight.w400,
        color: AppColors.textTertiary,
        letterSpacing: 0.2,
        features: const [],
      );

  static TextStyle get label => _inter(
        size: 13,
        weight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 0.1,
        features: const [],
      );
}
