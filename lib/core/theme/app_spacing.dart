import 'package:flutter/widgets.dart';

/// Единая шкала отступов — сетка 4pt. Все расстояния в приложении берутся
/// отсюда, а не подбираются на глаз: иначе на разных экранах одно и то же
/// «немного отступить» превращается в 6, 8 и 10 пикселей, и интерфейс
/// выглядит собранным из кусков.
abstract final class AppSpacing {
  /// 4 — микро-зазор: между иконкой и её подписью.
  static const double xs = 4;

  /// 8 — зазор внутри одного смыслового блока (подпись → поле).
  static const double sm = 8;

  /// 12 — между соседними карточками в списке.
  static const double md = 12;

  /// 16 — между блоками одного раздела.
  static const double lg = 16;

  /// 20 — горизонтальные поля экрана.
  static const double page = 20;

  /// 24 — между разделами формы.
  static const double xl = 24;

  /// 32 — перед итоговым действием, вокруг пустых состояний.
  static const double xxl = 32;

  /// 40 — крупная пауза на приветственных экранах.
  static const double huge = 40;

  /// Нижний отступ прокручиваемых списков с плавающей кнопкой: 96 = FAB (56)
  /// + поля, чтобы кнопка не накрывала последнюю строку.
  static const double fabSafeBottom = 96;

  /// Стандартные поля экрана со списком.
  static const EdgeInsets screen = EdgeInsets.fromLTRB(page, sm, page, xxl);

  /// Поля экрана, у которого есть плавающая кнопка.
  static const EdgeInsets screenWithFab =
      EdgeInsets.fromLTRB(page, sm, page, fabSafeBottom);

  /// Внутренние поля стандартной карточки.
  static const EdgeInsets card = EdgeInsets.fromLTRB(14, lg, 14, md + 2);

  // Готовые вертикальные промежутки — короче и нагляднее, чем SizedBox
  // с числом в каждом файле.
  static const Widget gapXs = SizedBox(height: xs);
  static const Widget gapSm = SizedBox(height: sm);
  static const Widget gapMd = SizedBox(height: md);
  static const Widget gapLg = SizedBox(height: lg);
  static const Widget gapXl = SizedBox(height: xl);
  static const Widget gapXxl = SizedBox(height: xxl);
}
