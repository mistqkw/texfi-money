import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/core/security/app_lock.dart';
import 'package:texfi_money/core/security/screen_privacy.dart';

/// Безопасность.
///
/// Проверяется главное правило замка: ошибка — это отказ. Сломавшийся
/// датчик, неожиданный код от системы или отсутствующая нативная часть не
/// должны становиться способом открыть чужие деньги — а именно так ведёт
/// себя код, который на исключении возвращает «ну ладно, пускай».
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('замок приложения', () {
    test('на платформе без замка не мешает открыть приложение', () async {
      // Десктоп: блокировка там не предлагается в настройках, и отказывать
      // было бы нечему — приложение просто не открылось бы никогда.
      final lock = AppLock(supportedOverride: false);
      expect(lock.isSupported, isFalse);
      expect(await lock.isAvailable(), isFalse);
      expect(await lock.authenticate(reason: 'тест'), isTrue);
    });

    test('на поддерживаемой платформе отсутствие плагина — это отказ',
        () async {
      // Нативной части нет: `authenticate` не может ничего подтвердить,
      // и «не смог подтвердить» обязано читаться как «не пускать».
      final lock = AppLock(supportedOverride: true);
      expect(await lock.authenticate(reason: 'тест'), isFalse);
      expect(await lock.isAvailable(), isFalse);
    });
  });

  group('скрытие от системы', () {
    const channel = MethodChannel(ScreenPrivacy.channelName);
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    final calls = <MethodCall>[];

    tearDown(() {
      messenger.setMockMethodCallHandler(channel, null);
      calls.clear();
    });

    test('на неподдерживаемой платформе вызов не уходит', () async {
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        return true;
      });

      const privacy = ScreenPrivacy(supportedOverride: false);
      expect(await privacy.setSecure(true), isFalse);
      expect(calls, isEmpty);
    });

    test('передаёт нативной стороне то, что от неё хотят', () async {
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        return true;
      });

      const privacy = ScreenPrivacy(supportedOverride: true);
      expect(await privacy.setSecure(true), isTrue);
      expect(await privacy.setSecure(false), isTrue);

      expect(calls.map((c) => c.method), ['setSecure', 'setSecure']);
      expect(calls.map((c) => c.arguments['enabled']), [true, false]);
    });

    test('ошибка платформы не роняет приложение', () async {
      messenger.setMockMethodCallHandler(channel, (call) async {
        throw PlatformException(code: 'WRONG_THREAD');
      });

      const privacy = ScreenPrivacy(supportedOverride: true);
      expect(await privacy.setSecure(true), isFalse);
    });
  });
}
