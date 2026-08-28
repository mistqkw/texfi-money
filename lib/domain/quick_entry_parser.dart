import 'entities/transaction_type.dart';

/// Сырой разбор строки быстрого ввода — без обращения к списку категорий,
/// поэтому легко тестируется в изоляции.
///
/// Грамматика: `[вчера|сегодня] <+|-><сумма> [категория] [заметка...]`.
/// Примеры: "-350 продукты обед", "+5000 зарплата", "вчера -200 такси".
class RawQuickEntry {
  const RawQuickEntry({
    required this.isYesterday,
    required this.type,
    required this.amount,
    required this.remainder,
  });

  final bool isYesterday;
  final TransactionType type;
  final double amount;

  /// Всё, что осталось после суммы — ещё не разделено на категорию/заметку.
  final String remainder;
}

const _yesterdayWords = ['вчера', 'yesterday', 'учора', 'wczoraj'];
const _todayWords = ['сегодня', 'today', 'сьогодні', 'dzisiaj'];

final _amountPattern = RegExp(r'^(\d+(?:[.,]\d+)?)\s*(.*)$', dotAll: true);

/// Возвращает `null`, если строка не распознана как быстрый ввод
/// (нет ведущего +/- перед суммой, сумма нечисловая или <= 0).
RawQuickEntry? parseQuickEntry(String input) {
  var text = input.trim();
  if (text.isEmpty) return null;

  var isYesterday = false;
  for (final word in _yesterdayWords) {
    if (_startsWithWord(text, word)) {
      isYesterday = true;
      text = text.substring(word.length).trim();
      break;
    }
  }
  if (!isYesterday) {
    for (final word in _todayWords) {
      if (_startsWithWord(text, word)) {
        text = text.substring(word.length).trim();
        break;
      }
    }
  }

  if (text.isEmpty) return null;

  final sign = text[0];
  if (sign != '+' && sign != '-') return null;
  final type = sign == '+' ? TransactionType.income : TransactionType.expense;

  final match = _amountPattern.firstMatch(text.substring(1));
  if (match == null) return null;

  final amount = double.tryParse(match.group(1)!.replaceAll(',', '.'));
  if (amount == null || amount <= 0) return null;

  return RawQuickEntry(
    isYesterday: isYesterday,
    type: type,
    amount: amount,
    remainder: (match.group(2) ?? '').trim(),
  );
}

bool _startsWithWord(String text, String word) {
  final lower = text.toLowerCase();
  return lower == word || lower.startsWith('$word ');
}

/// Итог разбора строки быстрого ввода после сопоставления с категориями.
class QuickEntryResult {
  const QuickEntryResult({
    required this.amount,
    required this.type,
    required this.date,
    this.categoryId,
    this.note,
  });

  final double amount;
  final TransactionType type;
  final DateTime date;

  /// `null`, если ни одна категория не подошла под первое слово остатка —
  /// тогда вызывающая сторона должна подставить категорию по умолчанию
  /// ("Прочее"), а весь остаток становится заметкой.
  final String? categoryId;
  final String? note;
}

/// Сопоставляет [raw.remainder] со списком категорий заданного типа.
/// [nameOf] — функция локализованного названия категории (нужен BuildContext
/// на вызывающей стороне, поэтому не зашита внутрь парсера).
QuickEntryResult resolveQuickEntry({
  required RawQuickEntry raw,
  required List<({String id, String name})> categoriesOfType,
}) {
  final now = DateTime.now();
  final date = raw.isYesterday ? now.subtract(const Duration(days: 1)) : now;

  if (raw.remainder.isEmpty) {
    return QuickEntryResult(amount: raw.amount, type: raw.type, date: date);
  }

  final words = raw.remainder.split(RegExp(r'\s+'));
  final firstWord = words.first.toLowerCase();

  ({String id, String name})? matched;
  for (final c in categoriesOfType) {
    if (c.name.toLowerCase().startsWith(firstWord)) {
      matched = c;
      break;
    }
  }
  matched ??= _firstWhereOrNull(
    categoriesOfType,
    (c) => c.name.toLowerCase().contains(firstWord),
  );

  if (matched != null) {
    final note = words.length > 1 ? words.sublist(1).join(' ') : null;
    return QuickEntryResult(
      amount: raw.amount,
      type: raw.type,
      date: date,
      categoryId: matched.id,
      note: note,
    );
  }

  return QuickEntryResult(amount: raw.amount, type: raw.type, date: date, note: raw.remainder);
}

T? _firstWhereOrNull<T>(List<T> list, bool Function(T) test) {
  for (final item in list) {
    if (test(item)) return item;
  }
  return null;
}
