import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_theme_variant.dart';
import 'currency_provider.dart';

const _prefsKey = 'theme_variant';

class ThemeVariantNotifier extends StateNotifier<AppThemeVariant> {
  ThemeVariantNotifier(this._prefs)
      : super(AppThemeVariant.fromStorageKey(_prefs.getString(_prefsKey)));

  final SharedPreferences _prefs;

  Future<void> setVariant(AppThemeVariant variant) async {
    state = variant;
    await _prefs.setString(_prefsKey, variant.storageKey);
  }
}

final themeVariantProvider =
    StateNotifierProvider<ThemeVariantNotifier, AppThemeVariant>((ref) {
  return ThemeVariantNotifier(ref.watch(sharedPreferencesProvider));
});
