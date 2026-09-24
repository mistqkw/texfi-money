import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/beta_options.dart';
import 'currency_provider.dart';

/// Настройки меню разработчика.
///
/// Меню спрятано за пятью нажатиями на номер версии — как в Android, —
/// потому что всё здесь либо диагностика, либо эксперимент. Обычному
/// пользователю эти переключатели ничего не дают, а бета-стиль ещё и
/// меняет приложение до неузнаваемости.
///
/// Каждый флаг хранится в SharedPreferences под своим ключом с префиксом
/// `dev_`: так «сбросить настройки разработчика» чистит ровно их и не
/// задевает ни тему, ни валюту.
class BoolPrefNotifier extends StateNotifier<bool> {
  BoolPrefNotifier(this._prefs, this.key, {bool fallback = false})
      : super(_prefs.getBool(key) ?? fallback);

  final SharedPreferences _prefs;
  final String key;

  Future<void> set(bool value) async {
    state = value;
    await _prefs.setBool(key, value);
  }
}

StateNotifierProvider<BoolPrefNotifier, bool> _boolPref(
  String key, {
  bool fallback = false,
}) {
  return StateNotifierProvider<BoolPrefNotifier, bool>((ref) {
    return BoolPrefNotifier(
      ref.watch(sharedPreferencesProvider),
      key,
      fallback: fallback,
    );
  });
}

const String devPrefsPrefix = 'dev_';

/// Меню разработчика открыто (версию уже нажали пять раз).
final devMenuUnlockedProvider = _boolPref('${devPrefsPrefix}menu_unlocked');

/// Бета-стиль: антиква, тёплая бежевая палитра, мягкая геометрия.
final betaStyleProvider = _boolPref('${devPrefsPrefix}beta_style');

/// Графики времени кадра поверх приложения.
final perfOverlayProvider = _boolPref('${devPrefsPrefix}perf_overlay');

/// Шахматка поверх картинок, попавших в растровый кэш.
final rasterCheckerboardProvider =
    _boolPref('${devPrefsPrefix}raster_checkerboard');

/// Шахматка поверх слоёв, отрисованных вне экрана (saveLayer).
final layerCheckerboardProvider =
    _boolPref('${devPrefsPrefix}layer_checkerboard');

/// Дерево доступности вместо интерфейса.
final semanticsDebuggerProvider =
    _boolPref('${devPrefsPrefix}semantics_debugger');

/// Пропустить заставку при запуске.
final skipSplashProvider = _boolPref('${devPrefsPrefix}skip_splash');

/// Фоновый крап. Выключается, чтобы сравнивать скриншоты без фактуры.
final backgroundNoiseProvider =
    _boolPref('${devPrefsPrefix}background_noise', fallback: true);

/// Лента «DEV» в углу — чтобы на скриншоте было видно, что меню открыто.
final devBannerProvider = _boolPref('${devPrefsPrefix}banner');

/// Строковая настройка — для выборов из нескольких вариантов (enum по
/// имени). `null` — значение по умолчанию, ключ в хранилище не пишется.
class StringPrefNotifier extends StateNotifier<String?> {
  StringPrefNotifier(this._prefs, this.key) : super(_prefs.getString(key));

  final SharedPreferences _prefs;
  final String key;

  Future<void> set(String value) async {
    state = value;
    await _prefs.setString(key, value);
  }
}

StateNotifierProvider<StringPrefNotifier, String?> _stringPref(String key) {
  return StateNotifierProvider<StringPrefNotifier, String?>((ref) {
    return StringPrefNotifier(ref.watch(sharedPreferencesProvider), key);
  });
}

// --- Бета-стиль ------------------------------------------------------

/// Знак на фоне беты: `dollar`, `m` или `none` (см. BetaGlyphChoice).
final betaGlyphProvider = _stringPref('${devPrefsPrefix}beta_glyph');

/// Заметность знака: quiet / normal / bold / full.
final betaGlyphStrengthProvider =
    _stringPref('${devPrefsPrefix}beta_glyph_strength');

/// Размер знака: small / normal / large.
final betaGlyphSizeProvider = _stringPref('${devPrefsPrefix}beta_glyph_size');

/// Переход между экранами в бете: pageTurn / fade / instant.
final betaTransitionProvider =
    _stringPref('${devPrefsPrefix}beta_transition');

/// Зерно бумаги на фоне беты.
final betaGrainProvider =
    _boolPref('${devPrefsPrefix}beta_grain', fallback: true);

/// Основной текст беты антиквой (выключено — Inter).
final betaSerifBodyProvider =
    _boolPref('${devPrefsPrefix}beta_serif_body', fallback: true);

// --- Отладка интерфейса ----------------------------------------------

/// Сетка 8dp и поля экрана поверх интерфейса — проверять выравнивание.
final layoutGridProvider = _boolPref('${devPrefsPrefix}layout_grid');

/// Кружки под пальцем — для записи экрана.
final touchIndicatorsProvider =
    _boolPref('${devPrefsPrefix}touch_indicators');

/// Масштаб текста поверх системного: 0 — как в системе.
class TextScaleNotifier extends StateNotifier<double> {
  TextScaleNotifier(this._prefs) : super(_prefs.getDouble(_key) ?? 0);

  static const _key = '${devPrefsPrefix}text_scale';

  /// 0 — системный масштаб.
  static const List<double> options = [0, 0.85, 1.0, 1.15, 1.3];

  final SharedPreferences _prefs;

  Future<void> set(double value) async {
    state = value;
    await _prefs.setDouble(_key, value);
  }
}

final textScaleOverrideProvider =
    StateNotifierProvider<TextScaleNotifier, double>((ref) {
  return TextScaleNotifier(ref.watch(sharedPreferencesProvider));
});

/// Замедление всех анимаций. Работает и в релизной сборке: это
/// [timeDilation] планировщика, а не отладочный флаг.
class AnimationSpeedNotifier extends StateNotifier<double> {
  AnimationSpeedNotifier(this._prefs)
      : super(_prefs.getDouble(_key) ?? 1.0) {
    timeDilation = state;
  }

  static const _key = '${devPrefsPrefix}time_dilation';

  /// Во сколько раз медленнее. 1 — обычная скорость.
  static const List<double> options = [1, 2, 5, 10];

  final SharedPreferences _prefs;

  Future<void> set(double value) async {
    state = value;
    timeDilation = value;
    await _prefs.setDouble(_key, value);
  }
}

final animationSpeedProvider =
    StateNotifierProvider<AnimationSpeedNotifier, double>((ref) {
  return AnimationSpeedNotifier(ref.watch(sharedPreferencesProvider));
});

/// Сбрасывает все `dev_`-настройки, кроме самого факта, что меню открыто.
Future<void> resetDeveloperSettings(WidgetRef ref) async {
  final prefs = ref.read(sharedPreferencesProvider);
  for (final key in prefs.getKeys().toList()) {
    if (key.startsWith(devPrefsPrefix) &&
        key != ref.read(devMenuUnlockedProvider.notifier).key) {
      await prefs.remove(key);
    }
  }
  timeDilation = 1;
  for (final provider in [
    betaStyleProvider,
    perfOverlayProvider,
    rasterCheckerboardProvider,
    layerCheckerboardProvider,
    semanticsDebuggerProvider,
    skipSplashProvider,
    backgroundNoiseProvider,
    devBannerProvider,
    animationSpeedProvider,
    betaGlyphProvider,
    betaGlyphStrengthProvider,
    betaGlyphSizeProvider,
    betaTransitionProvider,
    betaGrainProvider,
    betaSerifBodyProvider,
    layoutGridProvider,
    touchIndicatorsProvider,
    textScaleOverrideProvider,
  ]) {
    ref.invalidate(provider);
  }
}

/// Настройки беты, собранные для темы.
final betaOptionsProvider = Provider<BetaOptions>((ref) {
  return BetaOptions(
    glyph: BetaGlyphChoice.fromName(ref.watch(betaGlyphProvider)),
    strength: BetaGlyphStrength.fromName(ref.watch(betaGlyphStrengthProvider)),
    size: BetaGlyphSize.fromName(ref.watch(betaGlyphSizeProvider)),
    transition: BetaTransition.fromName(ref.watch(betaTransitionProvider)),
    grain: ref.watch(betaGrainProvider),
    serifBody: ref.watch(betaSerifBodyProvider),
  );
});
