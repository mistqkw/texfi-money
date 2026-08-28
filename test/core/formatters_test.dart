import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/core/constants/currencies.dart';
import 'package:texfi_money/core/utils/formatters.dart';

Future<String> _format(WidgetTester tester, double value, AppCurrency currency) async {
  late String result;
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('ru'),
      supportedLocales: const [Locale('ru'), Locale('en'), Locale('pl'), Locale('uk')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(
        builder: (context) {
          result = formatAmount(value, currency, context);
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return result;
}

void main() {
  group('formatAmount', () {
    testWidgets('использует символ выбранной валюты', (tester) async {
      expect(await _format(tester, 1234, AppCurrency.rub), contains('₽'));
      expect(await _format(tester, 1234, AppCurrency.usd), contains('\$'));
      expect(await _format(tester, 1234, AppCurrency.eur), contains('€'));
      expect(await _format(tester, 1234, AppCurrency.uah), contains('₴'));
      expect(await _format(tester, 1234, AppCurrency.pln), contains('zł'));
    });

    testWidgets('скрывает дробную часть для целой суммы', (tester) async {
      expect(await _format(tester, 1000, AppCurrency.rub), isNot(contains(',')));
    });

    testWidgets('показывает дробную часть, если сумма не целая', (tester) async {
      expect(await _format(tester, 1000.5, AppCurrency.rub), contains(','));
    });
  });

  group('AppCurrency.fromCode', () {
    test('находит валюту по коду', () {
      expect(AppCurrency.fromCode('USD'), AppCurrency.usd);
      expect(AppCurrency.fromCode('PLN'), AppCurrency.pln);
    });

    test('возвращает рубль по умолчанию для неизвестного или отсутствующего кода', () {
      expect(AppCurrency.fromCode(null), AppCurrency.rub);
      expect(AppCurrency.fromCode('XXX'), AppCurrency.rub);
    });
  });
}
