import 'package:flutter/material.dart';

/// Именованный доступ к типографике поверх стандартного [TextTheme],
/// чтобы шрифт и тема применялись автоматически. Доступ — `context.text`.
extension AppTextStylesContextX on BuildContext {
  AppTextStyles get text => AppTextStyles(Theme.of(this).textTheme);
}

class AppTextStyles {
  const AppTextStyles(this._tt);

  final TextTheme _tt;

  TextStyle get balance => _tt.displayLarge!;
  TextStyle get amountLarge => _tt.displayMedium!;
  TextStyle get amountMedium => _tt.displaySmall!;
  TextStyle get headline => _tt.headlineMedium!;
  TextStyle get title => _tt.titleMedium!;
  TextStyle get body => _tt.bodyMedium!;
  TextStyle get caption => _tt.bodySmall!;
  TextStyle get label => _tt.labelMedium!;
}
