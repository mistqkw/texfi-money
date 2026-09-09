import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/core/constants/category_icons.dart';
import 'package:texfi_money/presentation/shared/pixel_icon.dart';

/// Инварианты набора иконок.
///
/// Проверяется не красота — её тест не увидит, — а ровно то, что ломается
/// незаметно и всплывает потом на экране: съехавший размер сетки, опечатка
/// в символе, забытая при добавлении категории иконка и, главное, две
/// одинаковые картинки под разными именами. Последнее и было исходной
/// болезнью набора: пока иконки рисовались на восьми клетках, «зарплата»
/// и «накопления» отличались парой пикселей и в списке читались одинаково.
void main() {
  /// Все спрайты по именам. Собран вручную: `PixelIcons` — набор
  /// констант, и перечислить их отражением в Dart нельзя.
  const all = <String, List<String>>{
    'home': PixelIcons.home,
    'history': PixelIcons.history,
    'budgets': PixelIcons.budgets,
    'goals': PixelIcons.goals,
    'statistics': PixelIcons.statistics,
    'groceries': PixelIcons.groceries,
    'restaurant': PixelIcons.restaurant,
    'food': PixelIcons.food,
    'transport': PixelIcons.transport,
    'health': PixelIcons.health,
    'education': PixelIcons.education,
    'entertainment': PixelIcons.entertainment,
    'travel': PixelIcons.travel,
    'pets': PixelIcons.pets,
    'fitness': PixelIcons.fitness,
    'gifts': PixelIcons.gifts,
    'bills': PixelIcons.bills,
    'clothes': PixelIcons.clothes,
    'salary': PixelIcons.salary,
    'freelance': PixelIcons.freelance,
    'investments': PixelIcons.investments,
    'savings': PixelIcons.savings,
    'money': PixelIcons.money,
    'other': PixelIcons.other,
    'add': PixelIcons.add,
    'check': PixelIcons.check,
    'chevronRight': PixelIcons.chevronRight,
    'chevronDown': PixelIcons.chevronDown,
    'close': PixelIcons.close,
    'category': PixelIcons.category,
    'settings': PixelIcons.settings,
    'language': PixelIcons.language,
    'themeDark': PixelIcons.themeDark,
    'themeLight': PixelIcons.themeLight,
    'themeContrast': PixelIcons.themeContrast,
    'font': PixelIcons.font,
    'profiles': PixelIcons.profiles,
    'backupUp': PixelIcons.backupUp,
    'backupDown': PixelIcons.backupDown,
    'danger': PixelIcons.danger,
    'creditCard': PixelIcons.creditCard,
  };

  group('сетка', () {
    test('каждая иконка — квадрат объявленного размера', () {
      for (final entry in all.entries) {
        expect(
          entry.value.length,
          PixelIcons.grid,
          reason: '${entry.key}: строк не ${PixelIcons.grid}',
        );
        for (final row in entry.value) {
          expect(
            row.length,
            PixelIcons.grid,
            reason: '${entry.key}: строка "$row" не ${PixelIcons.grid} клеток',
          );
        }
      }
    });

    test('в сетке только заливка, полутон и пустота', () {
      // Любой другой символ рисовальщик молча считает пустотой — то есть
      // опечатка не упала бы, а просто выела бы кусок иконки.
      for (final entry in all.entries) {
        for (final row in entry.value) {
          for (final char in row.split('')) {
            expect(
              const {'#', '+', '.'},
              contains(char),
              reason: '${entry.key}: неизвестный символ "$char"',
            );
          }
        }
      }
    });

    test('пустых иконок нет', () {
      for (final entry in all.entries) {
        expect(
          entry.value.any((row) => row.contains('#')),
          isTrue,
          reason: '${entry.key}: ни одного закрашенного пикселя',
        );
      }
    });
  });

  group('различимость', () {
    test('нет двух иконок с одинаковым рисунком', () {
      final seen = <String, String>{};
      for (final entry in all.entries) {
        // `wallet` — намеренный алиас `budgets`, и совпадение рисунка у них
        // не ошибка, а смысл. В карту он не входит, но напоминание тут.
        final signature = entry.value.join('|');
        final twin = seen[signature];
        expect(
          twin,
          isNull,
          reason: '${entry.key} рисуется ровно как $twin',
        );
        seen[signature] = entry.key;
      }
    });

    test('соседи по списку категорий не совпадают почти полностью', () {
      // «Почти» ловит то, чего не поймает точное сравнение: иконки,
      // отличающиеся парой клеток, в списке читаются как одна и та же.
      final keys = PixelIcons.categoryCatalog.keys.toList();
      for (var i = 0; i < keys.length; i++) {
        for (var j = i + 1; j < keys.length; j++) {
          final a = PixelIcons.categoryCatalog[keys[i]]!.join();
          final b = PixelIcons.categoryCatalog[keys[j]]!.join();
          var same = 0;
          for (var k = 0; k < a.length; k++) {
            if (a[k] == b[k]) same++;
          }
          final ratio = same / a.length;
          expect(
            ratio,
            lessThan(0.95),
            reason: '${keys[i]} и ${keys[j]} совпадают на '
                '${(ratio * 100).round()}% клеток',
          );
        }
      }
    });
  });

  group('каталог категорий', () {
    test('у каждого ключа из CategoryIcons есть свой спрайт', () {
      for (final key in CategoryIcons.catalog.keys) {
        expect(
          PixelIcons.categoryCatalog.containsKey(key),
          isTrue,
          reason: 'ключ "$key" остался без пиксельной иконки',
        );
      }
    });

    test('лишних ключей в пиксельном каталоге нет', () {
      for (final key in PixelIcons.categoryCatalog.keys) {
        expect(
          CategoryIcons.catalog.containsKey(key),
          isTrue,
          reason: 'ключ "$key" не существует в CategoryIcons',
        );
      }
    });

    test('неизвестный ключ отдаёт запасную иконку, а не падает', () {
      expect(PixelIcons.forCategoryKey('нет такого'), PixelIcons.other);
    });
  });
}
