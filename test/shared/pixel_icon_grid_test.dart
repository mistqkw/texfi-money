import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Спрайты разбираются прямо из исходника: набор объявлен константами, и
/// сверять его через публичный API значило бы перечислять каждый спрайт
/// в тесте руками — список разъедется в первый же день.
///
/// Повод для проверки конкретный: солнце в `themeLight` однажды было
/// набрано на строку длиннее сетки. Единственный спрайт не по сетке
/// сжимался по вертикали и читался не как солнце, а как насекомое —
/// глазами в списке настроек это не ловится, размер иконки 20px.
void main() {
  test('каждый спрайт — сетка 16×16 из символов #, *, o, + и .', () {
    final source = File('lib/presentation/shared/pixel_icon.dart').readAsStringSync();
    final sprites = RegExp(
      r"static const (?:List<String> )?(\w+) = \[\s*((?:'[^']*',\s*)+)\];",
    );

    final offGrid = <String>[];
    var checked = 0;
    for (final match in sprites.allMatches(source)) {
      final name = match.group(1)!;
      final rows = RegExp(r"'([^']*)'")
          .allMatches(match.group(2)!)
          .map((m) => m.group(1)!)
          .toList();
      checked++;
      if (rows.length != 16 || rows.any((r) => r.length != 16)) {
        offGrid.add('$name: ${rows.length} строк, ширины ${rows.map((r) => r.length).toSet()}');
      }
      for (final row in rows) {
        expect(
          RegExp(r'^[#*o+.]*$').hasMatch(row),
          isTrue,
          reason: 'спрайт $name использует символы вне алфавита «#*o+.»: $row',
        );
      }
    }

    expect(checked, greaterThan(20), reason: 'разбор исходника ничего не нашёл — изменился формат объявления');
    expect(offGrid, isEmpty, reason: 'спрайты не по сетке 16×16:\n${offGrid.join('\n')}');
  });
}
