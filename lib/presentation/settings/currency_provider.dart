import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/currencies.dart';

const _prefsKey = 'currency_code';

/// Переопределяется в main() реальным экземпляром SharedPreferences.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider должен быть переопределён в main()');
});

class CurrencyNotifier extends StateNotifier<AppCurrency> {
  CurrencyNotifier(this._prefs)
      : super(AppCurrency.fromCode(_prefs.getString(_prefsKey)));

  final SharedPreferences _prefs;

  Future<void> setCurrency(AppCurrency currency) async {
    state = currency;
    await _prefs.setString(_prefsKey, currency.code);
  }
}

final currencyProvider = StateNotifierProvider<CurrencyNotifier, AppCurrency>((ref) {
  return CurrencyNotifier(ref.watch(sharedPreferencesProvider));
});
