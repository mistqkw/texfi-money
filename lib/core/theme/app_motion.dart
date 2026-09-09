import 'package:flutter/animation.dart';

/// Длительности и кривые анимаций.
///
/// Набор намеренно совпадает по именам и значениям с TexFi f0kus: у
/// приложений одна стилистика, и «нормальная» длительность в одном не
/// должна отличаться от «нормальной» в другом — иначе переход между ними
/// ощущается как переход между разными продуктами.
///
/// Ретро-эффекты держим короткими: стилистика должна читаться, а не
/// задерживать пользователя.
abstract final class AppMotion {
  static const Duration instant = Duration(milliseconds: 90);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 300);

  /// Разовый акцент — например, «списание» на балансе после удаления.
  static const Duration flourish = Duration(milliseconds: 600);

  /// Переход между экранами с pixel-dissolve.
  static const Duration route = Duration(milliseconds: 260);

  /// Короткий удар подтверждения: просадка кнопки, «поп» переключателя.
  /// Всё, что обязано успеть до того, как палец оторвался от экрана.
  static const Duration pop = Duration(milliseconds: 180);

  /// Накрутка числа — суммы на балансе, остатка бюджета. Достаточно, чтобы
  /// цифру было видно растущей, и мало, чтобы её не пришлось ждать.
  static const Duration count = Duration(milliseconds: 700);

  /// Появление редкого события во весь экран — достигнутая цель.
  /// Единственная длительность в наборе, которая не обязана быть незаметной.
  static const Duration reveal = Duration(milliseconds: 420);

  /// Задержка между появлением соседних элементов списка.
  ///
  /// Сорок миллисекунд — не украшение: список операций приезжает разом, и
  /// без сдвига глазу не за что зацепиться, чтобы заметить, что он
  /// перестроился. Больше сотни — и список уже не появляется, а выезжает.
  static const Duration stagger = Duration(milliseconds: 40);

  /// Пиксельные анимации не сглаживаем по времени сильнее, чем нужно:
  /// «ступенчатость» — часть стиля.
  static const Curve standard = Curves.easeOutCubic;
  static const Curve enter = Curves.easeOut;
  static const Curve exit = Curves.easeIn;
  static const Curve snap = Curves.easeOutBack;

  /// Прежнее имя [snap]. Оставлено, чтобы переименование не потащило за
  /// собой правку вызовов, к анимациям отношения не имеющих.
  static const Curve spring = snap;
}
