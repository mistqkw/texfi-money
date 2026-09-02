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

  /// Компактное пиксельное акцентное число вне основной шкалы сумм —
  /// проценты на донат-чарте и подобные короткие бейджи.
  TextStyle get pixelAccent => _tt.titleLarge!;
  TextStyle get title => _tt.titleMedium!;
  TextStyle get body => _tt.bodyMedium!;
  TextStyle get caption => _tt.bodySmall!;
  TextStyle get label => _tt.labelMedium!;

  /// Моноширинный текст для терминальных меток/метаданных — всегда
  /// JetBrains Mono, независимо от выбранного пользователем основного шрифта.
  TextStyle get mono => _tt.labelSmall!;
}
