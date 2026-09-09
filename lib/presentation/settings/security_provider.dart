import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/security/app_lock.dart';
import '../../core/security/screen_privacy.dart';
import 'currency_provider.dart';

const _lockKey = 'security_app_lock';
const _hideInSwitcherKey = 'security_hide_in_switcher';

final appLockProvider = Provider<AppLock>((ref) => AppLock());
final screenPrivacyProvider = Provider<ScreenPrivacy>(
  (ref) => const ScreenPrivacy(),
);

/// Есть ли на устройстве чем подтвердить личность.
///
/// Отдельным провайдером: замок могут завести или снять в системных
/// настройках, пока приложение открыто, и ответ меняется вне приложения.
final appLockAvailableProvider = FutureProvider<bool>((ref) {
  return ref.watch(appLockProvider).isAvailable();
});

/// Спрашивать ли замок при открытии приложения.
///
/// По умолчанию выключено. Блокировка, включённая без ведома человека, —
/// это в лучшем случае неожиданность, в худшем потерянный доступ к своим
/// же данным на устройстве, где замок настроен криво.
class AppLockNotifier extends StateNotifier<bool> {
  AppLockNotifier(this._prefs) : super(_prefs.getBool(_lockKey) ?? false);

  final SharedPreferences _prefs;

  Future<void> set(bool value) async {
    state = value;
    await _prefs.setBool(_lockKey, value);
  }
}

final appLockEnabledProvider =
    StateNotifierProvider<AppLockNotifier, bool>((ref) {
  return AppLockNotifier(ref.watch(sharedPreferencesProvider));
});

/// Прятать ли содержимое в переключателе задач.
///
/// Включено по умолчанию, и это единственная настройка безопасности,
/// которая включена сразу. Причина в цене ошибки: забытая блокировка стоит
/// одного лишнего касания, а забытое скрытие — того, что баланс и последние
/// траты видит любой, кто открыл список задач на лежащем телефоне. Платит
/// за это только запрет скриншотов, который замечают редко и отключают
/// одним переключателем.
class HideInSwitcherNotifier extends StateNotifier<bool> {
  HideInSwitcherNotifier(this._prefs)
      : super(_prefs.getBool(_hideInSwitcherKey) ?? true);

  final SharedPreferences _prefs;

  Future<void> set(bool value) async {
    state = value;
    await _prefs.setBool(_hideInSwitcherKey, value);
  }
}

final hideInSwitcherProvider =
    StateNotifierProvider<HideInSwitcherNotifier, bool>((ref) {
  return HideInSwitcherNotifier(ref.watch(sharedPreferencesProvider));
});
