import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/domain/entities/transaction_type.dart';
import 'package:texfi_money/domain/quick_entry_parser.dart';

void main() {
  group('parseQuickEntry', () {
    test('разбирает расход с категорией и заметкой', () {
      final raw = parseQuickEntry('-350 продукты обед');
      expect(raw, isNotNull);
      expect(raw!.type, TransactionType.expense);
      expect(raw.amount, 350);
      expect(raw.isYesterday, isFalse);
      expect(raw.remainder, 'продукты обед');
    });

    test('разбирает доход без категории', () {
      final raw = parseQuickEntry('+5000 зарплата');
      expect(raw, isNotNull);
      expect(raw!.type, TransactionType.income);
      expect(raw.amount, 5000);
      expect(raw.remainder, 'зарплата');
    });

    test('разбирает голую сумму без остатка', () {
      final raw = parseQuickEntry('-1200');
      expect(raw, isNotNull);
      expect(raw!.amount, 1200);
      expect(raw.remainder, isEmpty);
    });

    test('понимает "вчера" в начале строки', () {
      final raw = parseQuickEntry('вчера -200 такси домой');
      expect(raw, isNotNull);
      expect(raw!.isYesterday, isTrue);
      expect(raw.amount, 200);
      expect(raw.remainder, 'такси домой');
    });

    test('понимает "today"/"yesterday" на английском', () {
      expect(parseQuickEntry('yesterday -10 coffee')!.isYesterday, isTrue);
      expect(parseQuickEntry('today -10 coffee')!.isYesterday, isFalse);
    });

    test('принимает запятую как десятичный разделитель', () {
      final raw = parseQuickEntry('-350,50 такси');
      expect(raw!.amount, closeTo(350.5, 0.0001));
    });

    test('без ведущего +/- возвращает null', () {
      expect(parseQuickEntry('350 продукты'), isNull);
    });

    test('пустая строка возвращает null', () {
      expect(parseQuickEntry(''), isNull);
      expect(parseQuickEntry('   '), isNull);
    });

    test('нулевая или отрицательная сумма после знака возвращает null', () {
      expect(parseQuickEntry('-0'), isNull);
      expect(parseQuickEntry('-abc'), isNull);
    });
  });

  group('resolveQuickEntry', () {
    const categories = [
      (id: 'cat_groceries', name: 'Продукты'),
      (id: 'cat_transport', name: 'Транспорт'),
      (id: 'cat_other_expense', name: 'Прочее'),
    ];

    test('находит категорию по началу первого слова остатка', () {
      final raw = parseQuickEntry('-350 продукты обед')!;
      final result = resolveQuickEntry(raw: raw, categoriesOfType: categories);

      expect(result.categoryId, 'cat_groceries');
      expect(result.note, 'обед');
    });

    test('находит категорию по частичному вхождению, если нет совпадения по началу', () {
      final raw = parseQuickEntry('-350 продукт обед')!;
      final result = resolveQuickEntry(raw: raw, categoriesOfType: categories);

      expect(result.categoryId, 'cat_groceries');
    });

    test('без совпадения категория null, весь остаток становится заметкой', () {
      final raw = parseQuickEntry('-350 кофе с другом')!;
      final result = resolveQuickEntry(raw: raw, categoriesOfType: categories);

      expect(result.categoryId, isNull);
      expect(result.note, 'кофе с другом');
    });

    test('пустой остаток — категория и заметка не заданы', () {
      final raw = parseQuickEntry('-1200')!;
      final result = resolveQuickEntry(raw: raw, categoriesOfType: categories);

      expect(result.categoryId, isNull);
      expect(result.note, isNull);
    });

    test('дата вчера переносится в результат', () {
      final raw = parseQuickEntry('вчера -200 такси')!;
      final result = resolveQuickEntry(raw: raw, categoriesOfType: categories);

      final expectedDate = DateTime.now().subtract(const Duration(days: 1));
      expect(result.date.year, expectedDate.year);
      expect(result.date.month, expectedDate.month);
      expect(result.date.day, expectedDate.day);
    });
  });
}
