import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Скрывает содержимое приложения от системы.
///
/// Android показывает в переключателе задач последний кадр приложения. Для
/// трекера расходов это значит, что баланс и список трат видны любому, кто
/// взял телефон со стола, — причём даже тогда, когда само приложение
/// заблокировано и открыть его нельзя. `FLAG_SECURE` заменяет этот кадр
/// пустым экраном и заодно запрещает скриншоты.
///
/// На десктопе такого механизма нет, и вызовы там просто ничего не делают:
/// приложение собирается из одного кода под все платформы.
class ScreenPrivacy {
  const ScreenPrivacy({@visibleForTesting this.supportedOverride});

  /// Подмена ответа [isSupported] в тестах: они идут на хосте, где
  /// `Platform.isAndroid` ложно всегда.
  @visibleForTesting
  final bool? supportedOverride;

  static const String channelName = 'com.texfi.texfi_money/screen_privacy';

  static const MethodChannel _channel = MethodChannel(channelName);

  bool get isSupported =>
      supportedOverride ?? (!kIsWeb && Platform.isAndroid);

  /// Включить или снять скрытие.
  ///
  /// Возвращает `false`, если платформа этого не умеет или вызов не прошёл.
  /// Ошибка здесь не повод падать: скрытие — усиление, а не условие работы.
  Future<bool> setSecure(bool enabled) async {
    if (!isSupported) return false;
    try {
      return await _channel
              .invokeMethod<bool>('setSecure', {'enabled': enabled}) ??
          false;
    } on PlatformException catch (error) {
      debugPrint('ScreenPrivacy.setSecure failed: ${error.message}');
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
