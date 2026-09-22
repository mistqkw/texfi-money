import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Material-иконки и Material-навигация вне пиксельного языка.
///
/// Это не педантизм: именно смесь сглаженных контуров Material со своими
/// рублеными спрайтами — и круглая «пилюля» NavigationBar под активной
/// вкладкой — делала интерфейс похожим на собранный из чужих деталей.
/// Вычистить их один раз мало: следующая иконка добавляется на автомате,
/// потому что `Icons.` короче, чем нарисовать спрайт.
void main() {
  final files = Directory('lib/presentation')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  test('в presentation не осталось Material-иконок', () {
    // `PixelIcons.` тоже оканчивается на `Icons.`, поэтому слева от
    // совпадения не должно быть буквы.
    final pattern = RegExp(r'(?<![A-Za-z])Icons\.[a-z_]+');
    final hits = <String>[];
    for (final file in files) {
      for (final match in pattern.allMatches(file.readAsStringSync())) {
        hits.add('${file.path}: ${match.group(0)}');
      }
    }
    expect(
      hits,
      isEmpty,
      reason: 'Нарисуйте спрайт в PixelIcons вместо Material-иконки:\n'
          '${hits.join('\n')}',
    );
  });

  test('нижняя навигация своя, а не Material', () {
    final banned = ['NavigationBar(', 'BottomNavigationBar(', 'NavigationDestination('];
    final hits = <String>[];
    for (final file in files) {
      final source = file.readAsStringSync();
      for (final name in banned) {
        if (source.contains(name)) hits.add('${file.path}: $name');
      }
    }
    expect(hits, isEmpty, reason: 'Используйте PixelNavBar:\n${hits.join('\n')}');
  });

  test('терминальная карточка не вернулась', () {
    // Ищем вызов, а не упоминание: в доке PixelCard имя старой карточки
    // названо намеренно — чтобы было понятно, что и на что заменили.
    final hits = files
        .where((f) => f.readAsStringSync().contains('TerminalBox('))
        .map((f) => f.path)
        .toList();
    expect(hits, isEmpty, reason: 'Используйте PixelCard:\n${hits.join('\n')}');
  });
}
