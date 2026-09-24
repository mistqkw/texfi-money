import 'package:flutter/material.dart';

import '../../core/theme/app_motion.dart';
import '../../core/theme/app_palettes.dart';
import '../../core/theme/app_typography.dart';

/// Текст беты «коллаж»: слово собрано из разных шрифтов, как на
/// картинке автора — «StyLE», «obscure», «ABSTRact».
///
/// Правила сняты с картинки:
/// * у каждого слова своё начертание: гротеск, жирный гротеск, курсив
///   с засечками, тонкий моноширинный или широкие капители;
/// * часть слов разрезана — начало одним шрифтом, конец другим;
/// * одна буква на строку выше остальных, как «I» в «It»;
/// * в названиях семьи отдельные буквы синие: T и F в «TexFi», ноль в
///   «m0ney».
///
/// Раскладка детерминирована — одно и то же слово всегда собрано одинаково,
/// иначе заголовок экрана менялся бы при каждом открытии. [shuffle]
/// включает короткий перебор шрифтов при появлении: буквы «примеряют»
/// начертания и встают на своё.
class CollageText extends StatefulWidget {
  const CollageText(
    this.text, {
    super.key,
    required this.style,
    this.shuffle = false,
    this.maxLines = 1,
    this.remix = true,
    this.tallLetter = true,
  });

  final String text;

  /// Основа: кегль и цвет. Семейство подменяется начертаниями.
  final TextStyle style;
  final bool shuffle;
  final int maxLines;

  /// Выключено — текст набирается основой, без смешения.
  final bool remix;

  /// Одна буква выше строки.
  final bool tallLetter;

  @override
  State<CollageText> createState() => _CollageTextState();
}

class _CollageTextState extends State<CollageText>
    with SingleTickerProviderStateMixin {
  AnimationController? _shuffle;

  @override
  void initState() {
    super.initState();
    if (widget.shuffle && widget.remix) {
      _shuffle = AnimationController(vsync: this, duration: AppMotion.reveal)
        ..forward();
    }
  }

  @override
  void dispose() {
    _shuffle?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _shuffle;
    if (controller == null) return _build(0);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        // Семь смен начертания за время появления, последняя — итоговая.
        final frame = controller.isCompleted ? 0 : 7 - (controller.value * 7).floor();
        return _build(frame);
      },
    );
  }

  Widget _build(int shuffleFrame) {
    final spans = widget.remix
        ? collageSpans(
            widget.text,
            widget.style,
            salt: shuffleFrame,
            tallLetter: widget.tallLetter,
          )
        : [TextSpan(text: widget.text, style: widget.style)];
    return Text.rich(
      TextSpan(children: spans),
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
      textScaler: MediaQuery.textScalerOf(context),
    );
  }
}

/// Начертания коллажа.
enum _Face { grotesk, bold, italic, mono, wide }

/// Раскладывает [text] на куски разными начертаниями. [salt] сдвигает
/// раскладку — им пользуется перебор шрифтов при появлении.
List<InlineSpan> collageSpans(
  String text,
  TextStyle base, {
  int salt = 0,
  bool tallLetter = true,
}) {
  final size = base.fontSize ?? 16;
  final color = base.color;
  final spans = <InlineSpan>[];
  final words = text.split(' ');

  // Какое слово получит высокую букву: самое длинное, при равенстве —
  // первое. Высокая буква в коротком слове из двух букв выглядела бы
  // опечаткой.
  var tallWord = -1;
  if (tallLetter && words.length > 1) {
    var best = 0;
    for (var i = 0; i < words.length; i++) {
      if (words[i].length > best) {
        best = words[i].length;
        tallWord = i;
      }
    }
  }

  for (var w = 0; w < words.length; w++) {
    final word = words[w];
    if (w > 0) spans.add(TextSpan(text: ' ', style: _style(_Face.grotesk, size, color)));
    if (word.isEmpty) continue;

    final brand = _brandSpans(word, size, color);
    if (brand != null) {
      spans.addAll(brand);
      continue;
    }

    final h = _hash(word) + salt * 131 + w * 17;
    final face = _pick(h);

    // Разрез слова: начало одним начертанием, конец другим — «Sty|LE».
    final canSplit = word.length >= 5 && (h >> 4) % 3 == 0;
    final cut = canSplit ? 2 + (h >> 7) % (word.length - 3) : word.length;
    final second = _pick(h >> 9, not: face);

    // Высокая буква — в середине слова, не на краю.
    final tallAt = w == tallWord ? (word.length > 2 ? 1 + (h >> 11) % (word.length - 2) : -1) : -1;

    for (var i = 0; i < word.length; ) {
      final f = i < cut ? face : second;
      final end = i < cut ? cut : word.length;
      if (tallAt >= i && tallAt < end && f != _Face.wide) {
        if (tallAt > i) {
          spans.add(TextSpan(text: _case(word.substring(i, tallAt), f), style: _style(f, size, color)));
        }
        spans.add(TextSpan(
          text: _case(word[tallAt], f),
          style: _style(f, size * 1.4, color),
        ));
        if (tallAt + 1 < end) {
          spans.add(TextSpan(
            text: _case(word.substring(tallAt + 1, end), f),
            style: _style(f, size, color),
          ));
        }
      } else {
        spans.add(TextSpan(text: _case(word.substring(i, end), f), style: _style(f, size, color)));
      }
      i = end;
    }
  }
  return spans;
}

/// Название семьи с синими буквами — как «TexFi» на картинке.
List<InlineSpan>? _brandSpans(String word, double size, Color? color) {
  final Set<int> blue;
  if (word == 'TexFi') {
    blue = {0, 3};
  } else if (word == 'm0ney') {
    blue = {1};
  } else {
    return null;
  }
  return [
    for (var i = 0; i < word.length; i++)
      TextSpan(
        text: word[i],
        style: _style(_Face.mono, size * 1.1, blue.contains(i) ? AppPalettes.collageBlue : color),
      ),
  ];
}

/// Гротеск чаще остальных: он — основа, остальные начертания — акценты.
/// Если все слова набирать разным, глазу не за что зацепиться.
_Face _pick(int h, {_Face? not}) {
  const weighted = [
    _Face.grotesk,
    _Face.grotesk,
    _Face.grotesk,
    _Face.bold,
    _Face.italic,
    _Face.mono,
    _Face.wide,
  ];
  var face = weighted[h.abs() % weighted.length];
  if (face == not) face = weighted[(h.abs() + 3) % weighted.length];
  if (face == not) face = _Face.grotesk == not ? _Face.mono : _Face.grotesk;
  return face;
}

String _case(String s, _Face face) => face == _Face.wide ? s.toUpperCase() : s;

TextStyle _style(_Face face, double size, Color? color) {
  return _faceStyle(face, size, color).copyWith(
    // Коллаж набирают и там, где над текстом нет DefaultTextStyle
    // (заставка, занавес) — без этого Flutter подчёркивает его жёлтым.
    decoration: TextDecoration.none,
  );
}

TextStyle _faceStyle(_Face face, double size, Color? color) {
  return switch (face) {
    _Face.grotesk => TextStyle(
        fontFamily: kBodyFamily,
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.1,
      ),
    _Face.bold => TextStyle(
        fontFamily: kBodyFamily,
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.1,
      ),
    // Курсив с засечками на глаз мельче гротеска того же кегля — чуть
    // подрастим, как «ty» в «StyLE».
    _Face.italic => TextStyle(
        fontFamily: kSerifFamily,
        fontStyle: FontStyle.italic,
        fontSize: size * 1.12,
        color: color,
        height: 1.1,
      ),
    _Face.mono => TextStyle(
        fontFamily: kMonoFamily,
        fontSize: size * 0.95,
        color: color,
        height: 1.1,
        fontVariations: const [FontVariation('wght', 280)],
      ),
    // Широкие капители крупнее по очку — кегль меньше, чтобы строка не
    // разъезжалась, как «ABSTR» на картинке.
    _Face.wide => TextStyle(
        fontFamily: kWideFamily,
        fontSize: size * 0.78,
        color: color,
        height: 1.1,
        letterSpacing: 0.5,
        fontVariations: const [FontVariation('wght', 300)],
      ),
  };
}

/// Устойчивый хеш строки: одинаковый между запусками (у `String.hashCode`
/// такой гарантии нет).
int _hash(String s) {
  var h = 0x811C9DC5;
  for (final unit in s.codeUnits) {
    h ^= unit;
    h = (h * 0x01000193) & 0x7FFFFFFF;
  }
  return h;
}
