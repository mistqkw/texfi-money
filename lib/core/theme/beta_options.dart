import 'package:flutter/material.dart';

/// Знак на фоне беты.
enum BetaGlyphChoice {
  /// «$» — как на аватарке.
  dollar(r'$'),

  /// «m» — от m0ney.
  m('m'),

  /// Без знака: только лист с зерном.
  none(null);

  const BetaGlyphChoice(this.glyph);

  /// Символ знака; `null` — знака нет.
  final String? glyph;

  /// Знак для анимаций — заставки и занавеса включения. Им нужен знак
  /// всегда: без него заставка — пустой экран с названием. Если на фоне
  /// знака нет, анимации берут «$».
  String get animationGlyph => glyph ?? r'$';

  static BetaGlyphChoice fromName(String? name) => BetaGlyphChoice.values
      .firstWhere((c) => c.name == name, orElse: () => BetaGlyphChoice.dollar);
}

/// Насколько заметен знак на фоне.
enum BetaGlyphStrength {
  quiet,
  normal,
  bold,

  /// Как на аватарке: эталонные 27/78% без приглушения.
  full;

  /// Непрозрачность слоя знака на тёмном листе.
  double get darkLayer => switch (this) {
        quiet => 0.25,
        normal => 0.45,
        bold => 0.7,
        full => 1.0,
      };

  /// Множитель чернильного знака на светлом листе.
  double get lightFactor => switch (this) {
        quiet => 0.5,
        normal => 1.0,
        bold => 1.7,
        full => 2.6,
      };

  static BetaGlyphStrength fromName(String? name) => BetaGlyphStrength.values
      .firstWhere((s) => s.name == name, orElse: () => BetaGlyphStrength.normal);
}

/// Кегль знака на фоне — доля ширины экрана.
enum BetaGlyphSize {
  small(0.6),

  /// Как на аватарке: 600 к 736.
  normal(600 / 736),
  large(1.05);

  const BetaGlyphSize(this.toWidth);

  final double toWidth;

  static BetaGlyphSize fromName(String? name) => BetaGlyphSize.values
      .firstWhere((s) => s.name == name, orElse: () => BetaGlyphSize.normal);
}

/// Переход между экранами в бете.
enum BetaTransition {
  /// Перелистывание: новая страница задвигается справа.
  pageTurn,

  /// Проявление: страница всплывает и проявляется.
  fade,

  /// Без анимации — экран меняется сразу.
  instant;

  static BetaTransition fromName(String? name) => BetaTransition.values
      .firstWhere((t) => t.name == name, orElse: () => BetaTransition.pageTurn);
}

/// Пятна на фоне коллажа.
enum CollageBlobs {
  /// Сплошные, как на картинке.
  bold,

  /// Приглушённые — текст поверх читается легче.
  soft,

  /// Без пятен: белый лист и прямоугольник.
  none;

  double get opacity => switch (this) {
        bold => 1.0,
        soft => 0.35,
        none => 0.0,
      };

  static CollageBlobs fromName(String? name) => CollageBlobs.values
      .firstWhere((b) => b.name == name, orElse: () => CollageBlobs.soft);
}

/// Настройки бета-стиля из меню разработчика.
///
/// Живут в теме, а не читаются из хранилища на месте: фон, заставка и
/// переход между экранами рисуются там, где до настроек не дотянуться
/// (переход — в слое темы, фон — над навигатором), а тема есть везде.
class BetaOptions extends ThemeExtension<BetaOptions> {
  const BetaOptions({
    this.glyph = BetaGlyphChoice.dollar,
    this.strength = BetaGlyphStrength.normal,
    this.size = BetaGlyphSize.normal,
    this.grain = true,
    this.transition = BetaTransition.pageTurn,
    this.serifBody = true,
    this.collageBlobs = CollageBlobs.soft,
    this.collageRemix = true,
    this.collageShuffle = true,
  });

  final BetaGlyphChoice glyph;
  final BetaGlyphStrength strength;
  final BetaGlyphSize size;

  /// Зерно бумаги на фоне.
  final bool grain;
  final BetaTransition transition;

  /// Основной текст антиквой. Выключено — основной текст Inter, антиква
  /// остаётся в заголовках и суммах.
  final bool serifBody;

  /// Коллаж: пятна на фоне.
  final CollageBlobs collageBlobs;

  /// Коллаж: смешивать шрифты в заголовках.
  final bool collageRemix;

  /// Коллаж: перебор шрифтов при появлении заголовка.
  final bool collageShuffle;

  @override
  BetaOptions copyWith({
    BetaGlyphChoice? glyph,
    BetaGlyphStrength? strength,
    BetaGlyphSize? size,
    bool? grain,
    BetaTransition? transition,
    bool? serifBody,
    CollageBlobs? collageBlobs,
    bool? collageRemix,
    bool? collageShuffle,
  }) {
    return BetaOptions(
      glyph: glyph ?? this.glyph,
      strength: strength ?? this.strength,
      size: size ?? this.size,
      grain: grain ?? this.grain,
      transition: transition ?? this.transition,
      serifBody: serifBody ?? this.serifBody,
      collageBlobs: collageBlobs ?? this.collageBlobs,
      collageRemix: collageRemix ?? this.collageRemix,
      collageShuffle: collageShuffle ?? this.collageShuffle,
    );
  }

  /// Настройки дискретные — перетекать нечему, переключаются на середине.
  @override
  BetaOptions lerp(ThemeExtension<BetaOptions>? other, double t) {
    if (other is! BetaOptions) return this;
    return t < 0.5 ? this : other;
  }
}

extension BetaOptionsContextX on BuildContext {
  /// Настройки беты текущей темы; без расширения — значения по умолчанию.
  BetaOptions get betaOptions =>
      Theme.of(this).extension<BetaOptions>() ?? const BetaOptions();
}
