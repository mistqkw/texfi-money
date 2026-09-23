import 'package:flutter/material.dart';

/// Знак приложения — та же пиксельная монета, что на иконке.
///
/// Сетка снята с `assets/icon/app_icon_foreground.png` — именно она едет
/// в адаптивную иконку Android, то есть её и видит пользователь на
/// домашнем экране. Содержимое там занимает 12×12 ячеек: та же сетка, что
/// у всех остальных спрайтов приложения. Знак живёт кодом, а не растровым
/// ассетом: масштабируется под любой размер без замыливания и правится в
/// одну строку.
///
/// Осторожно: `assets/icon/app_icon.png` (квадратная, legacy-иконка) несёт
/// другой, более ранний рисунок — монета крупная, а знак валюты мелкий
/// внутри неё. В настоящей иконке наоборот: знак валюты выходит за круг
/// сверху и снизу. Брать сетку оттуда нельзя.
///
/// До этого здесь были три растущих столбика — логотип из ранних сборок.
/// Иконку с тех пор перерисовали, а заставка осталась со старым знаком:
/// первое, что видел пользователь при запуске, не совпадало с тем, по
/// чему он только что ткнул на домашнем экране.
const List<String> kBrandMark = [
  '....#WW#....',
  '..###WWW##..',
  '.##WWWWWW##.',
  '.#WWWWW####.',
  '##WWWWW#####',
  '###WWWWWW###',
  '#####WWWWW##',
  '#####WW#WW##',
  '.#WWWWWWWW#.',
  '.##WWWWWW##.',
  '..###WW###..',
  '....#WW#....',
];

/// Сторона сетки знака в ячейках.
const int kBrandMarkGrid = 12;

/// Наименьшая и наибольшая диагональ `x + y` среди заполненных ячеек.
///
/// Нужны сборке на заставке: углы сетки пустые, и если считать волну от
/// нуля до `2 * (grid - 1)`, она заканчивается задолго до конца отведённого
/// интервала — знак успевал собраться, и дальше треть заставки на экране
/// ничего не происходило.
final (int, int) kBrandMarkDiagonalRange = () {
  var min = kBrandMarkGrid * 2, max = 0;
  for (var y = 0; y < kBrandMarkGrid; y++) {
    for (var x = 0; x < kBrandMarkGrid; x++) {
      if (kBrandMark[y][x] == '.') continue;
      final d = x + y;
      if (d < min) min = d;
      if (d > max) max = d;
    }
  }
  return (min, max);
}();

const Color kBrandBlue = Color(0xFF4A7DFB);

/// Знак целиком. Для собирающейся по ячейкам версии — `LaunchSplash`.
class BrandGlyph extends StatelessWidget {
  const BrandGlyph({super.key, this.size = 96, this.bodyColor, this.faceColor});

  final double size;

  /// Тело монеты. По умолчанию фирменный синий.
  final Color? bodyColor;

  /// Знак валюты внутри монеты.
  final Color? faceColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: BrandMarkPainter(
          body: bodyColor ?? kBrandBlue,
          face: faceColor ?? Colors.white,
        ),
      ),
    );
  }
}

/// Рисует [kBrandMark] по сетке.
class BrandMarkPainter extends CustomPainter {
  const BrandMarkPainter({required this.body, required this.face});

  final Color body;
  final Color face;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.shortestSide / kBrandMarkGrid;
    final paint = Paint();

    for (var y = 0; y < kBrandMarkGrid; y++) {
      final row = kBrandMark[y];
      for (var x = 0; x < kBrandMarkGrid; x++) {
        final code = row[x];
        if (code == '.') continue;
        paint.color = code == 'W' ? face : body;
        // С нахлёстом, а не с зазором: на субпиксельном рендере между
        // ячейками иначе появляются щели и контур рассыпается.
        canvas.drawRect(
          Rect.fromLTWH(x * cell, y * cell, cell + 0.5, cell + 0.5),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(BrandMarkPainter oldDelegate) =>
      oldDelegate.body != body || oldDelegate.face != face;
}
