import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:texfi_money/core/constants/currencies.dart';
import 'package:texfi_money/presentation/settings/currency_provider.dart';

void main() {
  group('CurrencyNotifier', () {
    test('по умолчанию RUB, если ничего не сохранено', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final notifier = CurrencyNotifier(prefs);

      expect(notifier.state, AppCurrency.rub);
    });

    test('загружает ранее сохранённую валюту', () async {
      SharedPreferences.setMockInitialValues({'currency_code': 'USD'});
      final prefs = await SharedPreferences.getInstance();

      final notifier = CurrencyNotifier(prefs);

      expect(notifier.state, AppCurrency.usd);
    });

    test('setCurrency обновляет состояние и сохраняет выбор на устройстве', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final notifier = CurrencyNotifier(prefs);

      await notifier.setCurrency(AppCurrency.uah);

      expect(notifier.state, AppCurrency.uah);
      expect(prefs.getString('currency_code'), 'UAH');
    });
  });
}
