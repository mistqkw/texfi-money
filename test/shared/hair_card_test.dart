import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/core/constants/app_font.dart';
import 'package:texfi_money/core/constants/app_theme_variant.dart';
import 'package:texfi_money/core/theme/app_theme.dart';
import 'package:texfi_money/presentation/shared/hair_card.dart';
import 'package:texfi_money/presentation/shared/hair_divider.dart';

Widget _wrap(Widget child, {AppThemeVariant variant = AppThemeVariant.dark}) {
  return MaterialApp(
    theme: AppTheme.build(variant: variant, font: AppFont.system),
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(20), child: child),
    ),
  );
}

void main() {
  testWidgets('HairCard без метки рендерится без ошибок', (tester) async {
    await tester.pumpWidget(_wrap(const HairCard(child: Text('содержимое'))));
    expect(tester.takeException(), isNull);
    expect(find.text('содержимое'), findsOneWidget);
  });

  testWidgets('HairCard с меткой и промптом рендерится без ошибок', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const HairCard(label: 'баланс', child: Text('12 000 ₽'))),
    );
    expect(tester.takeException(), isNull);
    expect(find.textContaining('БАЛАНС'), findsOneWidget);
  });

  for (final variant in AppThemeVariant.values) {
    testWidgets('HairCard рендерится в теме $variant', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const HairCard(label: 'тест', child: SizedBox(height: 40)),
          variant: variant,
        ),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('HairLabelDivider рендерится без ошибок', (tester) async {
    await tester.pumpWidget(_wrap(const HairLabelDivider(label: 'сегодня')));
    expect(tester.takeException(), isNull);
    expect(find.text('СЕГОДНЯ'), findsOneWidget);
  });
}
