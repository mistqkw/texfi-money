import 'package:flutter/material.dart';

/// Пиксельные силуэты экосистемы TexFi (как `PixelSprite`/`PixelIcon`
/// в TexFi f0kus): узнаваемые формы без сглаживания и лишней
/// детализации — категории, таббар, иконки настроек.
///
/// Каждый спрайт — квадратная сетка строк одинаковой длины: `#` —
/// закрашенный пиксель, любой другой символ — пусто. Большинство сеток —
/// 8×8, но иконки категорий и часть настроек — 10×10: силуэт важнее
/// строгого единообразия размера сетки, `PixelSprite` масштабирует любую
/// сетку под нужный размер виджета одинаково. Ключи для категорий
/// совпадают с ключами [CategoryIcons] в `core/constants/category_icons.dart`,
/// чтобы отрисовка подтягивалась прямо по `CategoryEntity.iconKey`.
abstract final class PixelIcons {
  static const int grid = 8;

  // --- Навигация -----------------------------------------------------
  static const home = [
    '....##....',
    '...####...',
    '..######..',
    '.########.',
    '##########',
    '##.####.##',
    '##.####.##',
    '##..##..##',
    '##..##..##',
    '##########',
  ];

  static const history = [
    '.######.',
    '.######.',
    '.#....#.',
    '.######.',
    '.#....#.',
    '.######.',
    '.#....#.',
    '.######.',
  ];

  static const budgets = [
    '........',
    '.######.',
    '.#....#.',
    '.#....#.',
    '.####.#.',
    '.#..#.#.',
    '.#....#.',
    '.######.',
  ];

  static const goals = [
    '.#......',
    '.#####..',
    '.#...#..',
    '.#####..',
    '.#......',
    '.#......',
    '.#......',
    '.#......',
  ];

  static const statistics = [
    '........',
    '....##..',
    '....##..',
    '..#.##..',
    '..#.##..',
    '.##.##..',
    '.##.##..',
    '########',
  ];

  // --- Категории транзакций -------------------------------------------
  // Иконки ниже — на сетке 10×10: силуэт (тележка, крест, машина...)
  // должен читаться сразу, крупнее, чем позволяет 8×8.
  static const groceries = [
    '#.........',
    '##........',
    '#.########',
    '#.#......#',
    '#.#......#',
    '#.########',
    '....#..#..',
    '...##.##..',
    '....#..#..',
    '..........',
  ];

  static const restaurant = [
    '.##.##....',
    '.##.##....',
    '..........',
    '.######...',
    '#......#..',
    '#......#..',
    '#......##.',
    '#......#..',
    '.######...',
    '..........',
  ];

  static const transport = [
    '..........',
    '...####...',
    '..######..',
    '.########.',
    '##########',
    '##########',
    '#.######.#',
    '##########',
    '..#....#..',
    '.##....##.',
  ];

  static const health = [
    '..........',
    '...####...',
    '...####...',
    '...####...',
    '##########',
    '##########',
    '...####...',
    '...####...',
    '...####...',
    '..........',
  ];

  static const education = [
    '...##...',
    '..####..',
    '.######.',
    '########',
    '...##...',
    '........',
    '..####..',
    '........',
  ];

  static const entertainment = [
    '##.##.##..',
    '##########',
    '..........',
    '#........#',
    '#........#',
    '#........#',
    '#........#',
    '#........#',
    '#........#',
    '##########',
  ];

  static const travel = [
    '....#...',
    '....#...',
    '..#####.',
    '..#####.',
    '....#...',
    '...#.#..',
    '..#...#.',
    '........',
  ];

  static const pets = [
    '........',
    '.#.##.#.',
    '.#.##.#.',
    '........',
    '..####..',
    '.######.',
    '.######.',
    '........',
  ];

  static const fitness = [
    '........',
    '#..##..#',
    '#..##..#',
    '##.##.##',
    '##.##.##',
    '#..##..#',
    '#..##..#',
    '........',
  ];

  static const gifts = [
    '.######.',
    '#.#..#.#',
    '########',
    '#..##..#',
    '#..##..#',
    '#..##..#',
    '#..##..#',
    '########',
  ];

  static const bills = [
    '.########.',
    '.#......#.',
    '.#.####.#.',
    '.#......#.',
    '.#.####.#.',
    '.#......#.',
    '.#.####.#.',
    '.#......#.',
    '.########.',
    '..........',
  ];

  static const clothes = [
    '....##....',
    '...#..#...',
    '....##....',
    '..######..',
    '.##....##.',
    '#........#',
    '#........#',
    '##########',
    '..........',
    '..........',
  ];

  static const salary = [
    '........',
    '..####..',
    '.######.',
    '#......#',
    '#......#',
    '########',
    '#......#',
    '########',
  ];

  static const freelance = [
    '........',
    '########',
    '#......#',
    '#......#',
    '#......#',
    '########',
    '.######.',
    '........',
  ];

  static const investments = [
    '........',
    '......##',
    '.....##.',
    '....##..',
    '.##.##..',
    '.###....',
    '.##.....',
    '........',
  ];

  static const savings = [
    '.####...',
    '#....##.',
    '#.....#.',
    '#..#..#.',
    '#.....#.',
    '#.....#.',
    '.#####..',
    '.#..#...',
  ];

  // Монета с крестообразной насечкой — узнаётся и как деньги/доход,
  // и как иконка «Currency» в настройках (там же переиспользуется).
  static const money = [
    '..######..',
    '.##....##.',
    '#...##...#',
    '#..####..#',
    '#..#..#..#',
    '#..#..#..#',
    '#..####..#',
    '#...##...#',
    '.##....##.',
    '..######..',
  ];

  // Нейтральный дефолт для пользовательских категорий без явной иконки —
  // простая узнаваемая звезда, а не абстрактный узор.
  static const other = [
    '....##....',
    '....##....',
    '#...##...#',
    '.#..##..#.',
    '..#.##.#..',
    '##########',
    '..#.##.#..',
    '.#..##..#.',
    '#...##...#',
    '....##....',
  ];

  /// Ключи совпадают с `CategoryIcons.catalog` из `core/constants`.
  static const Map<String, List<String>> categoryCatalog = {
    'groceries': groceries,
    'restaurant': restaurant,
    'transport': transport,
    'home': home,
    'health': health,
    'education': education,
    'entertainment': entertainment,
    'travel': travel,
    'pets': pets,
    'fitness': fitness,
    'gifts': gifts,
    'bills': bills,
    'clothes': clothes,
    'salary': salary,
    'freelance': freelance,
    'investments': investments,
    'savings': savings,
    'money': money,
    'other': other,
  };

  static List<String> forCategoryKey(String key) => categoryCatalog[key] ?? other;

  // --- Служебные / settings --------------------------------------------
  static const add = [
    '........',
    '...##...',
    '...##...',
    '.######.',
    '.######.',
    '...##...',
    '...##...',
    '........',
  ];

  static const check = [
    '........',
    '.......#',
    '......##',
    '.#...##.',
    '.##.##..',
    '..###...',
    '...#....',
    '........',
  ];

  static const chevronRight = [
    '..#.....',
    '...#....',
    '....#...',
    '.....#..',
    '....#...',
    '...#....',
    '..#.....',
    '........',
  ];

  static const chevronDown = [
    '........',
    '........',
    '#......#',
    '.#....#.',
    '..#..#..',
    '...##...',
    '........',
    '........',
  ];

  static const close = [
    '........',
    '#.....#.',
    '.#...#..',
    '..#.#...',
    '..#.#...',
    '.#...#..',
    '#.....#.',
    '........',
  ];

  static const category = [
    '........',
    '.##..##.',
    '.##..##.',
    '........',
    '.##..##.',
    '.##..##.',
    '........',
    '........',
  ];

  static const settings = [
    '...##...',
    '.#.##.#.',
    '##....##',
    '#.####.#',
    '#.####.#',
    '##....##',
    '.#.##.#.',
    '...##...',
  ];

  static const language = [
    '..####..',
    '.#....#.',
    '#.####.#',
    '########',
    '#.####.#',
    '.#....#.',
    '..####..',
    '........',
  ];

  static const themeDark = [
    '...####...',
    '..######..',
    '.###....#.',
    '.###...##.',
    '.###..###.',
    '.###..###.',
    '.###...##.',
    '.###....#.',
    '..######..',
    '...####...',
  ];

  static const themeLight = [
    '..#....#..',
    '...####...',
    '.#.####.#.',
    '..######..',
    '###....###',
    '###....###',
    '..######..',
    '.#.####.#.',
    '...####...',
    '..#....#..',
  ];

  // «Контраст» / OLED-режим — квадрат, разделённый на закрашенную и
  // полую половины, читается как split day/night лучше сплошного клина.
  static const themeContrast = [
    '##########',
    '##...#....',
    '##...#....',
    '##...#....',
    '##...#....',
    '##...#....',
    '##...#....',
    '##...#....',
    '##...#....',
    '##########',
  ];

  static const font = [
    '....##....',
    '...####...',
    '..##..##..',
    '..##..##..',
    '.########.',
    '.##....##.',
    '.##....##.',
    '..........',
    '..........',
    '..........',
  ];

  static const wallet = budgets;

  static const profiles = [
    '........',
    '.##..##.',
    '.##..##.',
    '........',
    '###.###.',
    '#.#.#.#.',
    '#.#.#.#.',
    '........',
  ];

  static const backupUp = [
    '...##...',
    '..####..',
    '.######.',
    '...##...',
    '...##...',
    '........',
    '########',
    '........',
  ];

  static const backupDown = [
    '........',
    '########',
    '........',
    '...##...',
    '...##...',
    '.######.',
    '..####..',
    '...##...',
  ];

  // Треугольник опасности с прорезанным «!» — узнаваемее сплошного клина.
  static const danger = [
    '....##....',
    '...####...',
    '..##..##..',
    '.##....##.',
    '##..##..##',
    '##..##..##',
    '##......##',
    '##..##..##',
    '##########',
    '..........',
  ];

  static const creditCard = [
    '........',
    '########',
    '#......#',
    '########',
    '#......#',
    '#......#',
    '#......#',
    '########',
  ];
}

/// Рендерит спрайт [PixelIcons] сплошными квадратами на сетке 8×8 —
/// без сглаживания, `size` делится поровну между пикселями.
class PixelSprite extends StatelessWidget {
  const PixelSprite({
    super.key,
    required this.pattern,
    this.size = 20,
    this.color,
  });

  final List<String> pattern;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? IconTheme.of(context).color ?? Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PixelSpritePainter(pattern: pattern, color: resolvedColor),
      ),
    );
  }
}

class _PixelSpritePainter extends CustomPainter {
  _PixelSpritePainter({required this.pattern, required this.color});

  final List<String> pattern;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rows = pattern.length;
    if (rows == 0) return;
    final cols = pattern.first.length;
    final cellW = size.width / cols;
    final cellH = size.height / rows;
    final paint = Paint()..color = color;

    for (var y = 0; y < rows; y++) {
      final row = pattern[y];
      for (var x = 0; x < cols && x < row.length; x++) {
        if (row[x] == '#') {
          canvas.drawRect(
            Rect.fromLTWH(x * cellW, y * cellH, cellW + 0.5, cellH + 0.5),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PixelSpritePainter oldDelegate) {
    return color != oldDelegate.color || pattern != oldDelegate.pattern;
  }
}

/// Готовый drop-in вместо `Icon(IconData)` для мест, уже завязанных на
/// каталог [PixelIcons] по строковому ключу (категории).
class PixelIcon extends StatelessWidget {
  const PixelIcon(this.pattern, {super.key, this.size = 20, this.color});

  factory PixelIcon.category(String key, {Key? key2, double size = 20, Color? color}) {
    return PixelIcon(PixelIcons.forCategoryKey(key), key: key2, size: size, color: color);
  }

  final List<String> pattern;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return PixelSprite(pattern: pattern, size: size, color: color);
  }
}
