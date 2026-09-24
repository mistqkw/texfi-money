@Tags(['golden'])
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/core/constants/app_font.dart';
import 'package:texfi_money/core/constants/app_theme_variant.dart';
import 'package:texfi_money/core/theme/app_page_transitions.dart';
import 'package:texfi_money/core/theme/app_theme.dart';
import 'package:texfi_money/presentation/shared/beta_glyph.dart';
import 'package:texfi_money/presentation/shared/beta_launch_splash.dart';

/// Кадры движения бета-стиля: заставка и перелистывание. Анимацию на этой
/// машине иначе не увидеть — Android SDK нет, десктопной цели тоже.
Future<void> _loadFont(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final path in paths) {
    loader.addFont(File(path).readAsBytes().then((b) => ByteData.view(b.buffer)));
  }
  await loader.load();
}

Widget _app(Widget home, {AppThemeVariant variant = AppThemeVariant.dark}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.build(variant: variant, font: AppFont.inter, beta: true),
    builder: (context, child) => BetaBackground(child: child!),
    home: home,
  );
}

void main() {
  setUpAll(() async {
    await _loadFont('SourceSerif4', [
      'assets/fonts/SourceSerif4-Regular.ttf',
      'assets/fonts/SourceSerif4-Semibold.ttf',
    ]);
    PixelDissolveTransition.betaSheetBuilder =
        (child) => BetaBackground(child: child);
  });

  for (final variant in [AppThemeVariant.dark, AppThemeVariant.light]) {
    testWidgets('заставка беты, ${variant.name}', (tester) async {
      tester.view.physicalSize = const Size(1080, 2280);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      var finished = false;
      await tester.pumpWidget(
        _app(BetaLaunchSplash(onFinished: () => finished = true), variant: variant),
      );
      for (var frame = 1; frame <= 4; frame++) {
        await tester.pump(const Duration(milliseconds: 300));
        await expectLater(
          find.byType(BetaLaunchSplash),
          matchesGoldenFile('beta/splash_${variant.name}_$frame.png'),
        );
      }
      await tester.pump(const Duration(milliseconds: 200));
      expect(finished, isTrue);
    });
  }

  testWidgets('перелистывание: середина перехода', (tester) async {
    tester.view.physicalSize = const Size(1080, 2280);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    Widget page(String title) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              for (var i = 1; i <= 8; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('$title · строка $i'),
                ),
            ],
          ),
        );

    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => page('Вторая')),
            ),
            child: page('Первая'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Первая · строка 1'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('beta/page_turn_mid.png'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Вторая'), findsOneWidget);
  });
}
