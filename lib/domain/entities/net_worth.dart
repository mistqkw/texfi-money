import 'asset_entity.dart';
import 'cash_flow_type.dart';

/// Доля какой-то части капитала в общем.
class WealthShare<T> {
  const WealthShare({
    required this.key,
    required this.amount,
    required this.percent,
  });

  /// По чему разложено: категория, тип потока, уровень риска.
  final T key;

  /// Сумма стоимостей, а не вклад в капитал.
  ///
  /// Разница видна на пассивах: у ипотеки стоимость положительна — это
  /// размер долга. Доли считаются по стоимостям, потому что вопрос
  /// «сколько у меня в высоком риске» — про объём, а не про знак; иначе
  /// пассив уменьшал бы долю той категории, в которой он лежит.
  final double amount;

  /// Доля от суммы всех стоимостей, 0..100.
  final double percent;
}

/// Срез капитала на конкретный момент.
class NetWorthSnapshot {
  const NetWorthSnapshot({
    required this.total,
    required this.assets,
    required this.liabilities,
  });

  /// Капитал: активы минус пассивы.
  final double total;

  /// Сумма всего, что не пассив.
  final double assets;

  /// Сумма пассивов, положительным числом.
  final double liabilities;
}

/// Изменение капитала между двумя моментами.
class NetWorthChange {
  const NetWorthChange({required this.from, required this.to});

  final double from;
  final double to;

  double get absolute => to - from;

  /// Изменение в процентах.
  ///
  /// `null`, когда считать не от чего: капитал был нулевым или
  /// отрицательным. Показать «рост на 400%» при переходе от минус десяти
  /// тысяч к плюс тридцати было бы арифметически объяснимо и совершенно
  /// бессмысленно — процент от долга не значит ничего.
  double? get percent {
    if (from <= 0) return null;
    return absolute / from * 100;
  }
}

/// Расчёты капитала.
///
/// Чистые функции без Flutter и без базы: цифры, по которым человек судит
/// о своём положении, должны проверяться тестами целиком.
abstract final class NetWorth {
  /// Капитал по списку активов.
  static NetWorthSnapshot snapshot(Iterable<AssetEntity> assets) {
    var positive = 0.0;
    var liabilities = 0.0;
    for (final asset in assets) {
      if (asset.cashFlowType == CashFlowType.liability) {
        liabilities += asset.currentValue;
      } else {
        positive += asset.currentValue;
      }
    }
    return NetWorthSnapshot(
      total: positive - liabilities,
      assets: positive,
      liabilities: liabilities,
    );
  }

  /// Разложение по произвольному признаку.
  ///
  /// Возвращает доли, отсортированные по убыванию суммы: в списке
  /// распределения первым должно стоять то, чего больше всего.
  static List<WealthShare<K>> shares<K>(
    Iterable<AssetEntity> assets,
    K Function(AssetEntity asset) by,
  ) {
    final totals = <K, double>{};
    for (final asset in assets) {
      totals[by(asset)] = (totals[by(asset)] ?? 0) + asset.currentValue;
    }
    final sum = totals.values.fold<double>(0, (acc, value) => acc + value);
    final result = [
      for (final entry in totals.entries)
        WealthShare<K>(
          key: entry.key,
          amount: entry.value,
          // Ноль в знаменателе — не исключительная ситуация, а пустой
          // список активов или активы с нулевой стоимостью.
          percent: sum == 0 ? 0 : entry.value / sum * 100,
        ),
    ];
    result.sort((a, b) => b.amount.compareTo(a.amount));
    return result;
  }

  /// Стоимость актива на заданный момент по его истории оценок.
  ///
  /// Берётся последняя оценка не позже [moment]. Если таких нет — актива
  /// тогда ещё не было, и он не участвует в капитале того дня. Именно это
  /// делает динамику за год честной: купленная в июне квартира не должна
  /// выглядеть как прошлогодний рост.
  static double? valueAt(List<AssetValuePoint> history, DateTime moment) {
    double? value;
    DateTime? best;
    for (final point in history) {
      if (point.recordedAt.isAfter(moment)) continue;
      if (best == null || point.recordedAt.isAfter(best)) {
        best = point.recordedAt;
        value = point.value;
      }
    }
    return value;
  }
}
