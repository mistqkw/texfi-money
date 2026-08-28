import 'package:intl/intl.dart';

final _amountFormat = NumberFormat.currency(
  locale: 'ru_RU',
  symbol: '₽',
  decimalDigits: 0,
);

final _amountFormatPrecise = NumberFormat.currency(
  locale: 'ru_RU',
  symbol: '₽',
  decimalDigits: 2,
);

/// Форматирует сумму без копеек, если они нулевые: «1 234 ₽» / «1 234,50 ₽».
String formatAmount(double value) {
  final hasCents = (value - value.truncateToDouble()).abs() > 0.001;
  return hasCents ? _amountFormatPrecise.format(value) : _amountFormat.format(value);
}

final _dateFormat = DateFormat('d MMMM', 'ru_RU');
final _dateFormatWithYear = DateFormat('d MMMM yyyy', 'ru_RU');

String formatDate(DateTime date) {
  final now = DateTime.now();
  if (date.year == now.year && date.month == now.month && date.day == now.day) {
    return 'Сегодня';
  }
  final yesterday = now.subtract(const Duration(days: 1));
  if (date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day) {
    return 'Вчера';
  }
  return date.year == now.year ? _dateFormat.format(date) : _dateFormatWithYear.format(date);
}

final _monthFormat = DateFormat('LLLL yyyy', 'ru_RU');

String formatMonth(DateTime date) => _monthFormat.format(date);
