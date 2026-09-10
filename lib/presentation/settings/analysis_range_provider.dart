import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'currency_provider.dart';

const _yearsKey = 'analysis_range_years';
const _fromKey = 'analysis_range_from';
const _toKey = 'analysis_range_to';

/// Насколько далеко назад смотрят исторические графики.
///
/// Настройка одна на всё приложение, а не своя у каждого экрана, и это
/// требование по существу: динамика капитала за пять лет рядом с
/// движением денег за год — это два графика, которые нельзя сопоставить,
/// хотя стоят они рядом и выглядят одинаково.
class AnalysisRange {
  const AnalysisRange({this.years, this.from, this.to});

  /// Сколько последних лет показывать. `null` — задан явный диапазон.
  final int? years;

  /// Явные границы. Осмысленны только когда [years] пуст.
  final DateTime? from;
  final DateTime? to;

  static const int defaultYears = 5;

  static const AnalysisRange initial = AnalysisRange(years: defaultYears);

  bool get isExplicit => years == null && from != null && to != null;

  /// Границы диапазона на текущий момент.
  ///
  /// Считается от [now], а не от «сегодня» внутри: иначе тест на границе
  /// суток зависел бы от того, когда его запустили.
  ({DateTime from, DateTime to}) resolve(DateTime now) {
    if (isExplicit) {
      final start = from!;
      final end = to!;
      // Перевёрнутые границы — не ошибка ввода, а результат того, что
      // человек поменял одну дату и не поменял вторую. Разворачиваем, а
      // не показываем пустой график.
      return start.isAfter(end)
          ? (from: end, to: start)
          : (from: start, to: end);
    }
    final span = years ?? defaultYears;
    return (from: DateTime(now.year - span, now.month, now.day), to: now);
  }
}

class AnalysisRangeNotifier extends StateNotifier<AnalysisRange> {
  AnalysisRangeNotifier(this._prefs) : super(_read(_prefs));

  final SharedPreferences _prefs;

  static AnalysisRange _read(SharedPreferences prefs) {
    final from = prefs.getInt(_fromKey);
    final to = prefs.getInt(_toKey);
    if (from != null && to != null) {
      return AnalysisRange(
        from: DateTime.fromMillisecondsSinceEpoch(from),
        to: DateTime.fromMillisecondsSinceEpoch(to),
      );
    }
    return AnalysisRange(
      years: prefs.getInt(_yearsKey) ?? AnalysisRange.defaultYears,
    );
  }

  Future<void> setYears(int years) async {
    state = AnalysisRange(years: years);
    await _prefs.setInt(_yearsKey, years);
    // Явные границы снимаются: два способа задать одно и то же не должны
    // храниться одновременно — иначе непонятно, какой из них главный.
    await _prefs.remove(_fromKey);
    await _prefs.remove(_toKey);
  }

  Future<void> setExplicit({required DateTime from, required DateTime to}) async {
    state = AnalysisRange(from: from, to: to);
    await _prefs.setInt(_fromKey, from.millisecondsSinceEpoch);
    await _prefs.setInt(_toKey, to.millisecondsSinceEpoch);
  }
}

final analysisRangeProvider =
    StateNotifierProvider<AnalysisRangeNotifier, AnalysisRange>((ref) {
  return AnalysisRangeNotifier(ref.watch(sharedPreferencesProvider));
});
