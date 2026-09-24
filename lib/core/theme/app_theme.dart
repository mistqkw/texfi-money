import 'package:flutter/material.dart';

import '../constants/app_font.dart';
import '../constants/app_theme_variant.dart';
import 'app_page_transitions.dart';
import 'app_palettes.dart';
import 'app_radius.dart';
import 'app_style_ext.dart';
import 'app_typography.dart';
import 'beta_options.dart';

abstract final class AppTheme {
  /// [beta] — бета-стиль из меню разработчика: заменяет палитру на
  /// бумажную (светлую или тёмную — по выбранной теме), гарнитуру и
  /// геометрию примитивов.
  static ThemeData build({
    required AppThemeVariant variant,
    required AppFont font,
    bool beta = false,
    BetaOptions betaOptions = const BetaOptions(),
    StyleKind betaKind = StyleKind.paper,
  }) {
    final collage = beta && betaKind == StyleKind.collage;
    final colors = !beta
        ? AppPalettes.forVariant(variant)
        : collage
            ? AppPalettes.collageFor(variant)
            : AppPalettes.betaFor(variant);
    final style = !beta
        ? AppStyleExt.pixel
        : collage
            ? AppStyleExt.collage
            : AppStyleExt.paper;
    final textTheme = collage
        ? buildCollageTextTheme(colors)
        : buildAppTextTheme(
            font: font,
            colors: colors,
            beta: beta,
            serifBody: betaOptions.serifBody,
          );
    final brightness =
        variant == AppThemeVariant.light ? Brightness.light : Brightness.dark;
    final controlRadius = style.controlRadius;
    final borderWidth = style.borderWidth;

    final colorScheme = ColorScheme(
      brightness: brightness,
      surface: colors.background,
      onSurface: colors.textPrimary,
      primary: colors.accent,
      onPrimary: colors.onAccent,
      secondary: colors.accent,
      onSecondary: colors.onAccent,
      error: colors.expense,
      onError: colors.onAccent,
      surfaceContainerHighest: colors.surfaceVariant,
      outline: colors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      // В бета-стиле экраны прозрачные: фон с водяным знаком лежит один
      // под всем приложением (см. `BetaBackground`), и непрозрачный
      // Scaffold его бы закрыл. Уходящий экран при переходе гаснет сам —
      // см. PixelDissolveTransition.
      scaffoldBackgroundColor: beta ? Colors.transparent : colors.background,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      dividerColor: colors.divider,
      extensions: [colors, style, betaOptions],
      // iOS оставлен системным намеренно: там свайп-назад от края —
      // часть жеста, а не украшение, и подменять его на распад значило
      // бы сломать навигацию ради стиля.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PixelDissolvePageTransitionsBuilder(),
          TargetPlatform.linux: PixelDissolvePageTransitionsBuilder(),
          TargetPlatform.windows: PixelDissolvePageTransitionsBuilder(),
          TargetPlatform.macOS: PixelDissolvePageTransitionsBuilder(),
        },
      ),
      // Диалог в бете — лист, а не всплывающая капсула: почти прямые углы,
      // та же бумага, что под ним.
      dialogTheme: beta
          ? DialogThemeData(
              backgroundColor: colors.surface,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: controlRadius,
                side: BorderSide(color: colors.textPrimary),
              ),
            )
          : null,
      bottomSheetTheme: beta
          ? BottomSheetThemeData(
              backgroundColor: colors.surface,
              surfaceTintColor: Colors.transparent,
              shape: Border(top: BorderSide(color: colors.textPrimary)),
            )
          : null,
      snackBarTheme: beta
          ? SnackBarThemeData(
              backgroundColor: colors.textPrimary,
              contentTextStyle: textTheme.bodyMedium?.copyWith(
                color: colors.background,
              ),
              shape: RoundedRectangleBorder(borderRadius: controlRadius),
            )
          : null,
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: beta ? Colors.transparent : colors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineMedium,
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: beta ? style.cardRadius : AppRadius.cardSmallAll,
        ),
      ),
      textTheme: textTheme,
      iconTheme: IconThemeData(
        color: colors.textPrimary,
        weight: 400,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.accent,
          foregroundColor: colors.onAccent,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: controlRadius,
            side: BorderSide(
              color: colors.accentShadow,
              width: borderWidth,
            ),
          ),
          textStyle: textTheme.titleMedium,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.accent,
          textStyle: textTheme.titleMedium,
        ),
      ),
      // Поле ввода было Material-заливкой без рамки, а в фокусе получало
      // волосок в 1.5px. На экране, где у всего остального рамка ровно
      // 2px, это читалось как элемент из другого набора — и заметнее
      // всего в формах, то есть там, где пользователь проводит больше
      // всего времени.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: controlRadius,
          borderSide: BorderSide(
            color: colors.border,
            width: borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: controlRadius,
          borderSide: BorderSide(
            color: colors.border,
            width: borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: controlRadius,
          borderSide: BorderSide(
            color: colors.accent,
            width: borderWidth,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: controlRadius,
          borderSide: BorderSide(
            color: colors.expense,
            width: borderWidth,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: controlRadius,
          borderSide: BorderSide(
            color: colors.expense,
            width: borderWidth,
          ),
        ),
        hintStyle: textTheme.bodyMedium,
        labelStyle: textTheme.labelMedium,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.accent,
        unselectedItemColor: colors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.accent.withValues(alpha: 0.15),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.bodySmall?.copyWith(
            color: selected ? colors.accent : colors.textTertiary,
          );
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.accent,
        foregroundColor: colors.onAccent,
        elevation: 0,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.accent,
        linearTrackColor: colors.surfaceVariant,
      ),
    );
  }
}
