import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/core/constants/app_font.dart';
import 'package:texfi_money/core/constants/app_theme_variant.dart';
import 'package:texfi_money/core/theme/app_colors_ext.dart';
import 'package:texfi_money/core/theme/app_radius.dart';
import 'package:texfi_money/core/theme/app_theme.dart';
import 'package:texfi_money/presentation/shared/pixel_button.dart';
import 'package:texfi_money/presentation/shared/pixel_icon.dart';
import 'package:texfi_money/presentation/shared/pixel_shadow.dart';

Widget _wrap(Widget child, {AppThemeVariant variant = AppThemeVariant.dark}) {
  return MaterialApp(
    theme: AppTheme.build(variant: variant, font: AppFont.system),
    home: Scaffold(body: Padding(padding: const EdgeInsets.all(20), child: child)),
  );
}

PixelShadowBox _shadow(WidgetTester tester) {
  return tester.widget<PixelShadowBox>(
    find.descendant(
      of: find.byType(PixelButton),
      matching: find.byType(PixelShadowBox),
    ),
  );
}

/// Насколько содержимое кнопки уехало вниз-вправо прямо сейчас.
double _shift(WidgetTester tester) {
  final transform = tester.widget<Transform>(
    find.descendant(
      of: find.byType(PixelShadowBox),
      matching: find.byType(Transform),
    ),
  );
  return transform.transform.getTranslation().x;
}

void main() {
  testWidgets('кнопка утапливается на высоту тени и возвращается',
      (tester) async {
    await tester.pumpWidget(
      _wrap(PixelButton(label: 'Сохранить', onPressed: () {})),
    );

    expect(_shadow(tester).pressed, isFalse);
    expect(_shift(tester), 0);

    final gesture = await tester.press(find.byType(PixelButton));
    await tester.pumpAndSettle();

    expect(_shadow(tester).pressed, isTrue);
    // Содержимое уходит ровно на смещение тени: общий габарит не меняется,
    // соседи в форме не дёргаются.
    expect(_shift(tester), AppRadius.pixelShadowOffset);

    await gesture.up();
    await tester.pumpAndSettle();
    expect(_shift(tester), 0);
  });

  testWidgets('выключенная кнопка не отбрасывает тень и не нажимается',
      (tester) async {
    await tester.pumpWidget(
      _wrap(const PixelButton(label: 'Сохранить', onPressed: null)),
    );

    expect(_shadow(tester).enabled, isFalse);

    await tester.tap(find.byType(PixelButton));
    await tester.pump();
    expect(_shadow(tester).pressed, isFalse);
  });

  testWidgets('во время сохранения кнопка не принимает нажатий',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(PixelButton(label: 'Сохранить', busy: true, onPressed: () => taps++)),
    );
    await tester.tap(find.byType(PixelButton));
    await tester.pump();
    expect(taps, 0);
    // Подпись остаётся в дереве прозрачной — высота кнопки не схлопывается
    // до размера индикатора, и форма под ней не прыгает.
    expect(find.text('Сохранить'), findsOneWidget);
  });

  testWidgets('знак на кнопке — спрайт, а не Material-иконка', (tester) async {
    await tester.pumpWidget(
      _wrap(PixelButton(
        label: 'Добавить',
        sprite: PixelIcons.add,
        onPressed: () {},
      )),
    );
    expect(find.byType(PixelIcon), findsOneWidget);
    expect(find.byType(Icon), findsNothing);
  });

  for (final variant in AppThemeVariant.values) {
    testWidgets('тень акцентной кнопки отличается от самой кнопки в теме $variant',
        (tester) async {
      await tester.pumpWidget(
        _wrap(PixelButton(label: 'Сохранить', onPressed: () {}), variant: variant),
      );
      final colors = Theme.of(
        tester.element(find.byType(PixelButton)),
      ).extension<AppColorsExt>()!;
      // На кремовом фоне светлой темы синий блок под синей кнопкой слился
      // бы с ней в одно пятно — там тень тёплая.
      expect(colors.accentShadow, isNot(colors.accent));
    });
  }
}
