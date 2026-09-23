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

  test('в presentation нет Material-контролов с чужой геометрией', () {
    // Каждый из этих виджетов приносит свою геометрию: капсулу со
    // скруглением в половину высоты, сглаженную дугу спиннера, круглую
    // аватарку. По отдельности ни один не выглядит ошибкой — вместе они
    // и составляли ту смесь, из-за которой приложение читалось как
    // собранное из чужих деталей. У каждого есть пиксельная замена.
    const replacements = {
      r'SegmentedButton<': 'PixelSegments',
      r'ToggleButtons(': 'PixelSegments',
      r'CircularProgressIndicator(': 'PixelSpinner',
      r'LinearProgressIndicator(': 'AnimatedProgressBar',
      r'CircleAvatar(': 'Container с AppRadius',
      r'BoxShape.circle': 'AppRadius.controlSmallAll',
    };

    final hits = <String>[];
    for (final file in files) {
      final source = file.readAsStringSync();
      for (final entry in replacements.entries) {
        if (source.contains(entry.key)) {
          hits.add('${file.path}: ${entry.key} → ${entry.value}');
        }
      }
      // `Switch(` ловится отдельно: `PixelSwitch(` оканчивается так же.
      if (RegExp(r'(?<![A-Za-z])Switch\(').hasMatch(source)) {
        hits.add('${file.path}: Switch( → PixelSwitch');
      }
    }

    expect(
      hits,
      isEmpty,
      reason: 'Material-контролы вернулись в интерфейс:\n${hits.join('\n')}',
    );
  });
}
