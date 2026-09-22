import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/core/constants/app_font.dart';
import 'package:texfi_money/core/constants/app_theme_variant.dart';
import 'package:texfi_money/core/theme/app_theme.dart';
import 'package:texfi_money/presentation/shared/pixel_card.dart';
import 'package:texfi_money/presentation/shared/pixel_divider.dart';

Widget _wrap(Widget child, {AppThemeVariant variant = AppThemeVariant.dark}) {
  return MaterialApp(
    theme: AppTheme.build(variant: variant, font: AppFont.system),
    home: Scaffold(body: Padding(padding: const EdgeInsets.all(20), child: child)),
  );
}

void main() {
  testWidgets('PixelCard без метки рендерится без ошибок', (tester) async {
    await tester.pumpWidget(_wrap(const PixelCard(child: Text('содержимое'))));
    expect(tester.takeException(), isNull);
    expect(find.text('содержимое'), findsOneWidget);
  });

  testWidgets('PixelCard с меткой и промптом рендерится без ошибок', (tester) async {
    await tester.pumpWidget(_wrap(const PixelCard(label: 'баланс', child: Text('12 000 ₽'))));
    expect(tester.takeException(), isNull);
    expect(find.textContaining('баланс'), findsOneWidget);
  });

  for (final variant in AppThemeVariant.values) {
    testWidgets('PixelCard рендерится в теме $variant', (tester) async {
      await tester.pumpWidget(
        _wrap(const PixelCard(label: 'тест', child: SizedBox(height: 40)), variant: variant),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('PixelLabelDivider рендерится без ошибок', (tester) async {
    await tester.pumpWidget(_wrap(const PixelLabelDivider(label: 'сегодня')));
    expect(tester.takeException(), isNull);
    expect(find.text('СЕГОДНЯ'), findsOneWidget);
  });
}
