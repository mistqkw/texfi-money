import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/core/constants/app_font.dart';
import 'package:texfi_money/core/constants/app_theme_variant.dart';
import 'package:texfi_money/core/theme/app_palettes.dart';
import 'package:texfi_money/core/theme/app_theme.dart';
import 'package:texfi_money/presentation/shared/beta_icons.dart';
import 'package:texfi_money/presentation/shared/pixel_icon.dart';

void main() {
  test('у каждого спрайта есть линейная пара', () {
    // Спрайты объявлены как `static const имя = [`; синонимы вроде
    // `wallet = budgets` — не отдельный рисунок и в счёт не идут.
    final source = File('lib/presentation/shared/pixel_icon.dart').readAsStringSync();
    final declared = RegExp(r'static const (\w+) = \[')
        .allMatches(source)
        .map((m) => m.group(1))
        .toList();
    expect(BetaIcons.covered.length, declared.length,
        reason: 'Новому спрайту нужен знак в BetaIcons: $declared');
  });

  testWidgets('в бета-стиле PixelIcon рисует перо, в основном — пиксели',
      (tester) async {
    Future<void> pump({required bool beta}) => tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.build(
              variant: AppThemeVariant.dark,
              font: AppFont.system,
              beta: beta,
            ),
            home: const PixelIcon(PixelIcons.home),
          ),
        );

    await pump(beta: true);
    expect(find.byType(BetaIcon), findsOneWidget);
    await pump(beta: false);
    // Тема перетекает анимацией — ждём, пока она закончится.
    await tester.pumpAndSettle();
    expect(find.byType(BetaIcon), findsNothing);
  });

  testWidgets('лист образцов: пиксель → перо', (tester) async {
    final patterns = BetaIcons.covered.toList();
    tester.view.physicalSize = const Size(1080, 1500);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    Widget pair(List<String> pattern) => Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PixelSprite(pattern: pattern, size: 24, color: const Color(0xFF85725D)),
              const SizedBox(width: 6),
              BetaIcon(pattern: pattern, size: 32, color: AppPalettes.betaStroke),
            ],
          ),
        );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: AppPalettes.beta.background,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(children: [for (final p in patterns) pair(p)]),
          ),
        ),
      ),
    );
    await expectLater(
      find.byType(ColoredBox).first,
      matchesGoldenFile('../goldens/shots/beta_icons.png'),
    );
  });
}
