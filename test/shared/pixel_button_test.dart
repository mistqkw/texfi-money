import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/core/constants/app_font.dart';
import 'package:texfi_money/core/constants/app_theme_variant.dart';
import 'package:texfi_money/core/theme/app_colors_ext.dart';
import 'package:texfi_money/core/theme/app_theme.dart';
import 'package:texfi_money/presentation/shared/pixel_button.dart';

Widget _wrap(Widget child, {AppThemeVariant variant = AppThemeVariant.dark}) {
  return MaterialApp(
    theme: AppTheme.build(variant: variant, font: AppFont.system),
    home: Scaffold(body: Padding(padding: const EdgeInsets.all(20), child: child)),
  );
}

/// Геометрия кнопки: сдвиг контейнера и размер тени.
({double offset, double shadow}) _geometry(WidgetTester tester) {
  final container = tester.widget<AnimatedContainer>(
    find.descendant(
      of: find.byType(PixelButton),
      matching: find.byType(AnimatedContainer),
    ),
  );
  final decoration = container.decoration! as BoxDecoration;
  return (
    offset: container.transform!.getTranslation().x,
    shadow: decoration.boxShadow!.single.offset.dx,
  );
}

void main() {
  testWidgets('нажатие вдавливает кнопку: тень схлопывается на тот же сдвиг',
      (tester) async {
    await tester.pumpWidget(
      _wrap(PixelButton(label: 'Сохранить', onPressed: () {})),
    );

    final rest = _geometry(tester);
    expect(rest.offset, 0);
    expect(rest.shadow, greaterThan(0));

    final gesture = await tester.press(find.byType(PixelButton));
    await tester.pumpAndSettle();

    final pressed = _geometry(tester);
    expect(pressed.shadow, 0);
    // Суммарный габарит не меняется: сколько кнопка ушла вниз-вправо,
    // столько же отдала тень. Иначе соседи в форме дёргались бы.
    expect(pressed.offset, rest.shadow);

    await gesture.up();
    await tester.pumpAndSettle();
    expect(_geometry(tester).offset, 0);
  });

  testWidgets('выключенная кнопка гасит тень и не реагирует на нажатие',
      (tester) async {
    await tester.pumpWidget(
      _wrap(const PixelButton(label: 'Сохранить', onPressed: null)),
    );

    final container = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(PixelButton),
        matching: find.byType(AnimatedContainer),
      ),
    );
    final decoration = container.decoration! as BoxDecoration;
    // Тень не убрана из списка, а обесцвечена: убери её совсем — и кнопка
    // на время недоступности поехала бы на три пикселя вбок.
    expect(decoration.boxShadow!.single.color, Colors.transparent);

    await tester.tap(find.byType(PixelButton));
    await tester.pump();
    // Нажатие не вдавливает выключенную кнопку.
    expect(_geometry(tester).offset, 0);
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
