import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'currency_provider.dart';

const _prefsKey = 'locale_code';

/// Поддерживаемые языки приложения.
const supportedLocales = [Locale('ru'), Locale('en'), Locale('pl'), Locale('uk')];

/// Родные названия языков — не переводятся: носитель любого языка
/// узнаёт своё название лучше, чем перевод на текущий язык интерфейса.
const nativeLanguageNames = {
  'ru': 'Русский',
  'en': 'English',
  'pl': 'Polski',
  'uk': 'Українська',
};

/// `null` означает «следовать системному языку устройства».
class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier(this._prefs) : super(_read(_prefs));

  final SharedPreferences _prefs;

  static Locale? _read(SharedPreferences prefs) {
    final code = prefs.getString(_prefsKey);
    if (code == null) return null;
    return supportedLocales.firstWhere(
      (l) => l.languageCode == code,
      orElse: () => supportedLocales.first,
    );
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    if (locale == null) {
      await _prefs.remove(_prefsKey);
    } else {
      await _prefs.setString(_prefsKey, locale.languageCode);
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier(ref.watch(sharedPreferencesProvider));
});
