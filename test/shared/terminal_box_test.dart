import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/core/constants/app_font.dart';
import 'package:texfi_money/core/constants/app_theme_variant.dart';
import 'package:texfi_money/core/theme/app_theme.dart';
import 'package:texfi_money/presentation/shared/terminal_box.dart';
import 'package:texfi_money/presentation/shared/terminal_divider.dart';

Widget _wrap(Widget child, {AppThemeVariant variant = AppThemeVariant.dark}) {
  return MaterialApp(
    theme: AppTheme.build(variant: variant, font: AppFont.system),
    home: Scaffold(body: Padding(padding: const EdgeInsets.all(20), child: child)),
  );
}

void main() {
  testWidgets('TerminalBox без метки рендерится без ошибок', (tester) async {
    await tester.pumpWidget(_wrap(const TerminalBox(child: Text('содержимое'))));
    expect(tester.takeException(), isNull);
    expect(find.text('содержимое'), findsOneWidget);
  });

  testWidgets('TerminalBox с меткой и промптом рендерится без ошибок', (tester) async {
    await tester.pumpWidget(_wrap(const TerminalBox(label: 'баланс', child: Text('12 000 ₽'))));
    expect(tester.takeException(), isNull);
    expect(find.textContaining('баланс'), findsOneWidget);
  });

  for (final variant in AppThemeVariant.values) {
    testWidgets('TerminalBox рендерится в теме $variant', (tester) async {
      await tester.pumpWidget(
        _wrap(const TerminalBox(label: 'тест', child: SizedBox(height: 40)), variant: variant),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('TerminalDivider рендерится без ошибок', (tester) async {
    await tester.pumpWidget(_wrap(const TerminalDivider(label: 'сегодня')));
    expect(tester.takeException(), isNull);
    expect(find.text('СЕГОДНЯ'), findsOneWidget);
  });
}
