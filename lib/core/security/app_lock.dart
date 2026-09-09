import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Блокировка приложения замком устройства.
///
/// Приложение не заводит своего пароля и не хранит ни одного
/// биометрического признака: оно спрашивает у системы «это владелец
/// устройства?» и получает да или нет. Свой PIN означал бы ещё один секрет,
/// который надо где-то держать, — а держать его на том же устройстве, от
/// доступа к которому он и защищает, бессмысленно.
///
/// Отпечаток или лицо здесь не обязательны: [authenticate] разрешает и
/// обычный код разблокировки. Требовать именно биометрию значило бы
/// отрезать тех, у кого её нет или кто ей не пользуется.
class AppLock {
  AppLock({
    LocalAuthentication? auth,
    @visibleForTesting this.supportedOverride,
  }) : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  /// Подмена ответа [isSupported] в тестах: они идут на хосте, где
  /// `Platform.isAndroid` ложно всегда.
  @visibleForTesting
  final bool? supportedOverride;

  bool get isSupported =>
      supportedOverride ?? (!kIsWeb && (Platform.isAndroid || Platform.isIOS));

  /// Есть ли на устройстве чем подтвердить личность.
  ///
  /// Если замка нет вовсе — ни кода, ни отпечатка, — включать блокировку
  /// нечем, и настройка не должна этого предлагать: она бы просто не
  /// срабатывала, и человек считал бы себя защищённым зря.
  Future<bool> isAvailable() async {
    if (!isSupported) return false;
    try {
      return await _auth.isDeviceSupported();
    } on LocalAuthException catch (error) {
      debugPrint('AppLock.isAvailable failed: ${error.code}');
      return false;
    } on PlatformException catch (error) {
      debugPrint('AppLock.isAvailable failed: ${error.code}');
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  /// Спросить подтверждение. `true` — открыть приложение.
  ///
  /// Любая ошибка читается как отказ, и это осознанно: сломавшийся датчик
  /// или неожиданный код не должны становиться способом обойти замок.
  ///
  /// Исключение одно — платформа, где замка нет вовсе (десктоп). Там
  /// блокировка не предлагается в настройках, и отказывать было бы нечему:
  /// приложение просто не открылось бы никогда.
  Future<bool> authenticate({required String reason}) async {
    if (!isSupported) return true;
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        // Код устройства разрешён наравне с биометрией — см. выше.
        biometricOnly: false,
        // Системный запрос уводит приложение в фон сам по себе. Без этого
        // флага он на своём же уходе и обрывался бы с ошибкой.
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException catch (error) {
      debugPrint('AppLock.authenticate failed: ${error.code}');
      return false;
    } on PlatformException catch (error) {
      debugPrint('AppLock.authenticate failed: ${error.code}');
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
