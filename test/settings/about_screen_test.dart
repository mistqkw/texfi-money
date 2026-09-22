import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/core/constants/app_font.dart';
import 'package:texfi_money/core/constants/app_theme_variant.dart';
import 'package:texfi_money/core/theme/app_theme.dart';
import 'package:texfi_money/l10n/app_localizations.dart';
import 'package:texfi_money/presentation/settings/about_screen.dart';

Widget _wrap({AppThemeVariant variant = AppThemeVariant.dark, Locale? locale}) {
  return MaterialApp(
    theme: AppTheme.build(variant: variant, font: AppFont.system),
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: const AboutScreen(),
  );
}

void main() {
  testWidgets('экран «О приложении» рендерится без переполнений',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('показаны все три ссылки: исходники, лицензия, экосистема',
      (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle();

    expect(find.textContaining('github.com/mistqkw/texfi-money'), findsOneWidget);
    expect(find.textContaining('texfi-hub.vercel.app'), findsOneWidget);
    expect(find.textContaining('AGPL-3.0'), findsOneWidget);
  });

  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('экран собирается на языке ${locale.languageCode}',
        (tester) async {
      await tester.pumpWidget(_wrap(locale: locale));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  for (final variant in AppThemeVariant.values) {
    testWidgets('экран собирается в теме $variant', (tester) async {
      await tester.pumpWidget(_wrap(variant: variant));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
