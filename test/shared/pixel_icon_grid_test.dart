import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/presentation/shared/pixel_icon.dart';

/// Разбирает исходник `pixel_icon.dart` и достаёт из него каждый спрайт —
/// не только те, что попали в каталог категорий.
///
/// Проверять список вручную бессмысленно: смесь сеток появляется ровно
/// тогда, когда кто-то добавляет новый знак и не сверяется с остальными.
/// Разбор источника ловит любой будущий спрайт сам, без правки теста.
Map<String, List<String>> _spritesFromSource() {
  final file = File('lib/presentation/shared/pixel_icon.dart');
  final source = file.readAsStringSync();

  // `static const <имя> = [ '...', '...' ];` — только литералы-списки строк.
  // Псевдонимы вроде `static const wallet = budgets;` сюда не попадают: у них
  // нет собственной сетки, они делят её с оригиналом.
  final pattern = RegExp(
    r"static const (\w+) = \[\s*((?:'[^']*',\s*)+)\];",
    multiLine: true,
  );

  final result = <String, List<String>>{};
  for (final match in pattern.allMatches(source)) {
    final rows = RegExp("'([^']*)'")
        .allMatches(match.group(2)!)
        .map((m) => m.group(1)!)
        .toList();
    result[match.group(1)!] = rows;
  }
  return result;
}

void main() {
  final sprites = _spritesFromSource();

  test('разбор источника нашёл спрайты', () {
    // Нижняя граница — защита от того, что регулярка перестанет совпадать
    // после рефакторинга и тест начнёт молча проверять пустоту.
    expect(sprites.length, greaterThan(30));
    expect(sprites.keys, contains('info'));
    expect(sprites.keys, contains('danger'));
  });

  group('сетка одна на весь набор', () {
    for (final entry in sprites.entries) {
      test('${entry.key} — ${PixelIcons.grid}×${PixelIcons.grid}', () {
        expect(
          entry.value.length,
          PixelIcons.grid,
          reason: '${entry.key}: строк ${entry.value.length}, а не ${PixelIcons.grid}',
        );
        for (final row in entry.value) {
          expect(
            row.length,
            PixelIcons.grid,
            reason: '${entry.key}: строка "$row" — ${row.length} клеток',
          );
        }
      });
    }
  });

  test('в спрайтах нет символов вне алфавита «#», «+» и пустоты', () {
    final allowed = RegExp(r'^[#+.]*$');
    for (final entry in sprites.entries) {
      for (final row in entry.value) {
        expect(
          allowed.hasMatch(row),
          isTrue,
          reason: '${entry.key}: строка "$row" содержит посторонний символ',
        );
      }
    }
  });

  test('каждый спрайт не пустой — у знака есть силуэт', () {
    for (final entry in sprites.entries) {
      final filled = entry.value.join().replaceAll('.', '').length;
      expect(filled, greaterThan(0), reason: '${entry.key}: пустая сетка');
    }
  });
}
