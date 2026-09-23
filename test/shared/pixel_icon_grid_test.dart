import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Спрайты разбираются прямо из исходника: набор объявлен константами, и
/// сверять его через публичный API значило бы перечислять каждый спрайт
/// в тесте руками — список разъедется в первый же день.
///
/// Повод для проверки конкретный: солнце в `themeLight` было набрано в
/// тринадцать строк вместо двенадцати. Единственный спрайт не по сетке
/// сжимался по вертикали и читался не как солнце, а как насекомое —
/// глазами в списке настроек это не ловится, размер иконки 24px.
void main() {
  test('каждый спрайт — сетка 12×12 из символов #, + и .', () {
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
      if (rows.length != 12 || rows.any((r) => r.length != 12)) {
        offGrid.add('$name: ${rows.length} строк, ширины ${rows.map((r) => r.length).toSet()}');
      }
      for (final row in rows) {
        expect(
          RegExp(r'^[#+.]*$').hasMatch(row),
          isTrue,
          reason: 'спрайт $name использует символы вне алфавита «#+.»: $row',
        );
      }
    }

    expect(checked, greaterThan(20), reason: 'разбор исходника ничего не нашёл — изменился формат объявления');
    expect(offGrid, isEmpty, reason: 'спрайты не по сетке 12×12:\n${offGrid.join('\n')}');
  });
}
