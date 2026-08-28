import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../constants/currencies.dart';
import '../theme/app_l10n_ext.dart';

/// Полный ICU-локаль для нашего двухбуквенного кода языка.
String intlLocale(String languageCode) => switch (languageCode) {
      'en' => 'en_US',
      'pl' => 'pl_PL',
      'uk' => 'uk_UA',
      _ => 'ru_RU',
    };

/// Форматирует сумму без копеек, если они нулевые: «1 234 ₽» / «1 234,50 ₽».
String formatAmount(double value, AppCurrency currency, BuildContext context) {
  final hasCents = (value - value.truncateToDouble()).abs() > 0.001;
  final format = NumberFormat.currency(
    locale: intlLocale(context.localeCode),
    symbol: currency.symbol,
    decimalDigits: hasCents ? 2 : 0,
  );
  return format.format(value);
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String formatDate(DateTime date, BuildContext context) {
  final now = DateTime.now();
  if (_isSameDay(date, now)) return context.l10n.dateToday;

  final yesterday = now.subtract(const Duration(days: 1));
  if (_isSameDay(date, yesterday)) return context.l10n.dateYesterday;

  final locale = intlLocale(context.localeCode);
  final format = date.year == now.year
      ? DateFormat('d MMMM', locale)
      : DateFormat('d MMMM yyyy', locale);
  return format.format(date);
}

String formatMonthShort(DateTime date, BuildContext context) {
  return DateFormat('LLL', intlLocale(context.localeCode)).format(date);
}

String formatFullDate(DateTime date, BuildContext context) {
  return DateFormat('d MMMM yyyy', intlLocale(context.localeCode)).format(date);
}
