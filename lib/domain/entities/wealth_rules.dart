import 'asset_entity.dart';
import 'net_worth.dart';

/// Превышение порога по уровню риска.
class RiskBreach {
  const RiskBreach({
    required this.level,
    required this.actualPercent,
    required this.limitPercent,
  });

  final RiskLevelEntity level;

  /// Фактическая доля капитала в этом уровне, 0..100.
  final double actualPercent;

  /// Порог, который человек задал сам.
  final double limitPercent;

  double get overBy => actualPercent - limitPercent;
}

/// О чём приложение может сказать, глядя на цифры.
///
/// Не совет и не оценка — повод. Текст к нему подставляет слой интерфейса,
/// потому что текст переводится, а правило нет.
enum AdviceKind {
  /// Доля капитала в каком-то уровне риска выше заданного порога.
  riskOverLimit,

  /// Доля «бесполезных» трат заметно выросла против прошлого периода.
  uselessSpendingUp,

  /// Процент сбережений ниже собственного среднего за последние месяцы.
  savingsBelowOwnAverage,

  /// Расходы на подписки выросли против прошлого месяца.
  subscriptionsUp,
}

/// Повод сказать что-то, с числами для подстановки в текст.
class Advice {
  const Advice({
    required this.kind,
    this.amount,
    this.percent,
    this.limit,
    this.label,
  });

  final AdviceKind kind;

  /// Числа для подстановки. Какие именно осмысленны — зависит от [kind];
  /// лишние остаются пустыми.
  final double? amount;
  final double? percent;
  final double? limit;

  /// Имя того, о чём речь: уровень риска, категория. Не переводится —
  /// это то, как человек назвал вещь сам.
  final String? label;
}

/// Пороговые правила поверх собственных чисел пользователя.
///
/// Никакой рыночной аналитики и никакой оценки инструментов: всё, что
/// здесь происходит, — сравнение того, что человек ввёл, с тем, что он же
/// задал как порог, и с его собственной историей. Это сознательный
/// потолок возможностей, а не упрощение до поры.
abstract final class WealthRules {
  /// Уровни, доля которых вышла за собственный порог.
  ///
  /// Считается по стоимостям, а не по вкладу в капитал: вопрос «сколько у
  /// меня в высоком риске» — про объём вложенного. Иначе пассив в
  /// рискованной категории уменьшал бы её долю, то есть чем больше долг,
  /// тем спокойнее выглядела бы картина.
  static List<RiskBreach> riskBreaches(Iterable<AssetEntity> assets) {
    final shares = NetWorth.shares(assets, (asset) => asset.riskLevel.id);
    final levels = <String, RiskLevelEntity>{
      for (final asset in assets) asset.riskLevel.id: asset.riskLevel,
    };

    final breaches = <RiskBreach>[];
    for (final share in shares) {
      final level = levels[share.key];
      final limit = level?.maxSharePercent;
      if (level == null || limit == null) continue;
      if (share.percent <= limit) continue;
      breaches.add(
        RiskBreach(
          level: level,
          actualPercent: share.percent,
          limitPercent: limit,
        ),
      );
    }
    // Сначала то, где превышение больше: если порогов пробито несколько,
    // разбираться логично с самого явного.
    breaches.sort((a, b) => b.overBy.compareTo(a.overBy));
    return breaches;
  }

  /// Насколько заметным должен быть рост, чтобы о нём говорить, в процентах.
  ///
  /// Пятнадцать — не истина, а граница между шумом и событием. Траты
  /// колеблются от месяца к месяцу сами по себе, и приложение, замечающее
  /// каждое колебание, перестают читать через неделю.
  static const double noticeableGrowthPercent = 15;

  /// Насколько процент сбережений должен просесть против собственного
  /// среднего, чтобы об этом стоило сказать, в процентных пунктах.
  ///
  /// Пять пунктов, а не проценты от среднего: разница между 20% и 15%
  /// сбережений — это пять пунктов и заметное изменение жизни, а «на
  /// четверть меньше» звучит одинаково и для 20→15, и для 4→3.
  static const double savingsDropPoints = 5;

  /// Рост в процентах между двумя величинами.
  ///
  /// `null`, когда сравнивать не с чем: в прошлом периоде было ноль. Рост
  /// с нуля — это не «бесконечный процент», а просто «раньше не было».
  static double? growthPercent({required double before, required double after}) {
    if (before <= 0) return null;
    return (after - before) / before * 100;
  }

  /// Собрать поводы из уже посчитанных чисел.
  ///
  /// Функция ничего не считает сама и ни к чему не обращается — она
  /// принимает готовые величины и решает, о чём стоит сказать. Так её
  /// можно проверить целиком, не поднимая ни базы, ни экрана.
  static List<Advice> advise({
    required List<RiskBreach> breaches,
    double? uselessBefore,
    double? uselessAfter,
    double? subscriptionsBefore,
    double? subscriptionsAfter,
    double? savingsRate,
    double? savingsRateAverage,
  }) {
    final advice = <Advice>[
      for (final breach in breaches)
        Advice(
          kind: AdviceKind.riskOverLimit,
          label: breach.level.name,
          percent: breach.actualPercent,
          limit: breach.limitPercent,
        ),
    ];

    final uselessGrowth = (uselessBefore != null && uselessAfter != null)
        ? growthPercent(before: uselessBefore, after: uselessAfter)
        : null;
    if (uselessGrowth != null && uselessGrowth >= noticeableGrowthPercent) {
      advice.add(
        Advice(
          kind: AdviceKind.uselessSpendingUp,
          percent: uselessGrowth,
          amount: uselessAfter,
        ),
      );
    }

    final subsGrowth = (subscriptionsBefore != null && subscriptionsAfter != null)
        ? growthPercent(before: subscriptionsBefore, after: subscriptionsAfter)
        : null;
    if (subsGrowth != null && subsGrowth >= noticeableGrowthPercent) {
      advice.add(
        Advice(
          kind: AdviceKind.subscriptionsUp,
          percent: subsGrowth,
          amount: subscriptionsAfter,
        ),
      );
    }

    if (savingsRate != null &&
        savingsRateAverage != null &&
        savingsRateAverage - savingsRate >= savingsDropPoints) {
      advice.add(
        Advice(
          kind: AdviceKind.savingsBelowOwnAverage,
          percent: savingsRate,
          limit: savingsRateAverage,
        ),
      );
    }

    return advice;
  }
}

/// Процент сбережений за период.
abstract final class SavingsRate {
  /// (доход − расход) / доход × 100.
  ///
  /// `null` при нулевом доходе: месяц без поступлений — это не «сберёг
  /// ноль процентов», а «делить не на что». Показать там ноль значило бы
  /// смешать месяц без дохода с месяцем, где всё потрачено подчистую.
  ///
  /// Значение может быть отрицательным — когда потратили больше, чем
  /// получили. Обрезать его до нуля было бы враньём в приятную сторону.
  static double? forPeriod({required double income, required double expense}) {
    if (income <= 0) return null;
    return (income - expense) / income * 100;
  }

  /// Среднее по месяцам, у которых процент вообще посчитался.
  ///
  /// Месяцы без дохода не занижают среднее, а выпадают из него: они не
  /// говорят о том, как человек распоряжается деньгами, — они говорят,
  /// что денег не приходило.
  static double? average(Iterable<double?> rates) {
    final known = rates.whereType<double>().toList();
    if (known.isEmpty) return null;
    return known.reduce((a, b) => a + b) / known.length;
  }
}
