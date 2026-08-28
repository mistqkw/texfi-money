import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_font.dart';
import 'currency_provider.dart';

const _prefsKey = 'app_font';

class FontNotifier extends StateNotifier<AppFont> {
  FontNotifier(this._prefs) : super(AppFont.fromStorageKey(_prefs.getString(_prefsKey)));

  final SharedPreferences _prefs;

  Future<void> setFont(AppFont font) async {
    state = font;
    await _prefs.setString(_prefsKey, font.storageKey);
  }
}

final fontProvider = StateNotifierProvider<FontNotifier, AppFont>((ref) {
  return FontNotifier(ref.watch(sharedPreferencesProvider));
});
