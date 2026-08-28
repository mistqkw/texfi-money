import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/core/constants/currencies.dart';
import 'package:texfi_money/core/utils/formatters.dart';

void main() {
  group('formatAmount', () {
    test('использует символ выбранной валюты', () {
      expect(formatAmount(1234, AppCurrency.rub), contains('₽'));
      expect(formatAmount(1234, AppCurrency.usd), contains('\$'));
      expect(formatAmount(1234, AppCurrency.eur), contains('€'));
      expect(formatAmount(1234, AppCurrency.uah), contains('₴'));
      expect(formatAmount(1234, AppCurrency.pln), contains('zł'));
    });

    test('скрывает дробную часть для целой суммы', () {
      expect(formatAmount(1000, AppCurrency.rub), isNot(contains(',')));
    });

    test('показывает дробную часть, если сумма не целая', () {
      expect(formatAmount(1000.5, AppCurrency.rub), contains(','));
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
