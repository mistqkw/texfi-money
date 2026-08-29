import 'package:flutter/services.dart';

/// Сила отклика для денежных событий — подбирается по величине суммы
/// относительно привычной, чтобы крупная трата ощущалась весомее мелкой.
enum HapticWeight { light, normal, heavy }

/// Единая точка тактильной обратной связи. Отклик здесь не одиночный тик,
/// а короткий «жест»: последовательность импульсов с паузами, у каждого
/// события — свой ритм, узнаваемый вслепую. Всё уважает общий выключатель
/// (см. haptics_provider.dart).
abstract final class Haptics {
  /// Общий выключатель — синхронизируется с настройкой пользователя.
  static bool enabled = true;

  /// Проигрывает последовательность: импульс, пауза, импульс...
  /// Ошибки платформы намеренно проглатываются — вибрация не критична,
  /// и на устройстве без вибромотора приложение работать не перестанет.
  static Future<void> _pattern(List<_Beat> beats) async {
    if (!enabled) return;
    for (var i = 0; i < beats.length; i++) {
      if (i > 0) await Future<void>.delayed(beats[i].gapBefore);
      if (!enabled) return;
      try {
        await beats[i].fire();
      } catch (_) {
        return;
      }
    }
  }

  /// Лёгкий одиночный тик — переключение вкладки, сегмента, шаг онбординга,
  /// печатающийся текст на сплэше. Самое частое событие, поэтому — самое
  /// незаметное.
  static void select() {
    if (enabled) HapticFeedback.selectionClick();
  }

  /// Нейтральное подтверждение — двойной лёгкий тик, «готово».
  static void success() => _pattern(const [
        _Beat.light(),
        _Beat.light(gapBefore: Duration(milliseconds: 70)),
      ]);

  /// Деньги пришли — восходящий ритм, от лёгкого к более полному.
  static void income([HapticWeight weight = HapticWeight.normal]) => _pattern(switch (weight) {
        HapticWeight.light => const [_Beat.light()],
        HapticWeight.normal => const [
            _Beat.light(),
            _Beat.medium(gapBefore: Duration(milliseconds: 75)),
          ],
        HapticWeight.heavy => const [
            _Beat.light(),
            _Beat.medium(gapBefore: Duration(milliseconds: 70)),
            _Beat.heavy(gapBefore: Duration(milliseconds: 80)),
          ],
      });

  /// Деньги ушли — нисходящий ритм, зеркало [income].
  static void expense([HapticWeight weight = HapticWeight.normal]) => _pattern(switch (weight) {
        HapticWeight.light => const [_Beat.light()],
        HapticWeight.normal => const [
            _Beat.medium(),
            _Beat.light(gapBefore: Duration(milliseconds: 75)),
          ],
        HapticWeight.heavy => const [
            _Beat.heavy(),
            _Beat.medium(gapBefore: Duration(milliseconds: 70)),
            _Beat.light(gapBefore: Duration(milliseconds: 80)),
          ],
      });

  /// Удаление — короткий «срыв»: плотный импульс, затухающий хвост.
  static void delete() => _pattern(const [
        _Beat.medium(),
        _Beat.light(gapBefore: Duration(milliseconds: 55)),
      ]);

  /// Ошибка ввода — два плотных импульса подряд, «нет-нет».
  static void error() => _pattern(const [
        _Beat.heavy(),
        _Beat.heavy(gapBefore: Duration(milliseconds: 110)),
      ]);

  /// Необратимое действие — один тяжёлый удар, без ритма.
  static void warning() {
    if (enabled) HapticFeedback.heavyImpact();
  }

  /// Цель достигнута — короткий восходящий «фанфарный» ритм.
  static void celebrate() => _pattern(const [
        _Beat.light(),
        _Beat.light(gapBefore: Duration(milliseconds: 60)),
        _Beat.medium(gapBefore: Duration(milliseconds: 60)),
        _Beat.heavy(gapBefore: Duration(milliseconds: 90)),
      ]);

  /// Подсказка появилась — деликатное касание, чтобы заметить, но не вздрогнуть.
  static void nudge() => _pattern(const [
        _Beat.light(),
        _Beat.light(gapBefore: Duration(milliseconds: 130)),
      ]);

  /// Подбирает вес отклика: во сколько раз сумма больше привычной.
  /// [reference] — типичная сумма (например, средняя по категории); при
  /// нуле или отсутствии данных возвращается обычный вес.
  static HapticWeight weightFor({required double amount, required double reference}) {
    if (reference <= 0 || amount <= 0) return HapticWeight.normal;
    final ratio = amount / reference;
    if (ratio >= 2.5) return HapticWeight.heavy;
    if (ratio <= 0.4) return HapticWeight.light;
    return HapticWeight.normal;
  }
}

/// Один импульс последовательности: пауза перед ним и его сила.
class _Beat {
  const _Beat.light({this.gapBefore = Duration.zero}) : _kind = 0;
  const _Beat.medium({this.gapBefore = Duration.zero}) : _kind = 1;
  const _Beat.heavy({this.gapBefore = Duration.zero}) : _kind = 2;

  final Duration gapBefore;
  final int _kind;

  Future<void> fire() => switch (_kind) {
        0 => HapticFeedback.lightImpact(),
        1 => HapticFeedback.mediumImpact(),
        _ => HapticFeedback.heavyImpact(),
      };
}
