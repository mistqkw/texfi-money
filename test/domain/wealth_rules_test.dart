import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/domain/entities/asset_entity.dart';
import 'package:texfi_money/domain/entities/cash_flow_type.dart';
import 'package:texfi_money/domain/entities/subscription_entity.dart';
import 'package:texfi_money/domain/entities/subscription_period.dart';
import 'package:texfi_money/domain/entities/wealth_rules.dart';

/// Пороговые правила и советы.
///
/// Главное, что здесь проверяется, — что приложение молчит, когда сказать
/// нечего. Советчик, срабатывающий на каждое колебание, перестают читать
/// через неделю, и тогда он не работает вовсе.
void main() {
  const category = AssetCategoryEntity(
    id: 'c1',
    name: 'Крипта',
    iconKey: 'investments',
    color: Colors.blue,
    isCustom: false,
  );
  const low = RiskLevelEntity(
    id: 'low',
    name: 'Низкий',
    rank: 0,
    color: Colors.green,
    maxSharePercent: null,
    isCustom: false,
  );
  const high = RiskLevelEntity(
    id: 'high',
    name: 'Высокий',
    rank: 2,
    color: Colors.red,
    maxSharePercent: 30,
    isCustom: false,
  );

  AssetEntity asset(String id, double value, RiskLevelEntity risk) => AssetEntity(
        id: id,
        name: id,
        category: category,
        riskLevel: risk,
        cashFlowType: CashFlowType.neutral,
        currentValue: value,
        createdAt: DateTime(2026),
      );

  group('пороги риска', () {
    test('превышение замечается и считается в процентных пунктах', () {
      final breaches = WealthRules.riskBreaches([
        asset('вклад', 400, low),
        asset('крипта', 600, high),
      ]);

      expect(breaches, hasLength(1));
      expect(breaches.single.level.id, 'high');
      expect(breaches.single.actualPercent, 60);
      expect(breaches.single.limitPercent, 30);
      expect(breaches.single.overBy, 30);
    });

    test('ровно на пороге — это ещё не превышение', () {
      final breaches = WealthRules.riskBreaches([
        asset('вклад', 700, low),
        asset('крипта', 300, high),
      ]);
      expect(breaches, isEmpty);
    });

    test('уровень без заданного порога молчит всегда', () {
      // Порога нет — значит человек не говорил, сколько для него много,
      // и придумывать это за него не из чего.
      final breaches = WealthRules.riskBreaches([asset('всё', 1000, low)]);
      expect(breaches, isEmpty);
    });

    test('пустой портфель не порождает предупреждений', () {
      expect(WealthRules.riskBreaches(const []), isEmpty);
    });
  });

  group('рост', () {
    test('считается в процентах от прошлого значения', () {
      expect(WealthRules.growthPercent(before: 100, after: 115), 15);
      expect(WealthRules.growthPercent(before: 200, after: 100), -50);
    });

    test('рост с нуля — это не бесконечность, а «раньше не было»', () {
      expect(WealthRules.growthPercent(before: 0, after: 500), isNull);
    });
  });

  group('советы', () {
    test('без поводов список пуст', () {
      final advice = WealthRules.advise(
        breaches: const [],
        uselessBefore: 100,
        uselessAfter: 105,
        savingsRate: 20,
        savingsRateAverage: 21,
      );
      expect(advice, isEmpty);
    });

    test('мелкое колебание трат не повод', () {
      // Четырнадцать процентов — ещё шум; порог заметности пятнадцать.
      final advice = WealthRules.advise(
        breaches: const [],
        uselessBefore: 100,
        uselessAfter: 114,
      );
      expect(advice, isEmpty);
    });

    test('заметный рост бесполезных трат — повод', () {
      final advice = WealthRules.advise(
        breaches: const [],
        uselessBefore: 100,
        uselessAfter: 130,
      );
      expect(advice.single.kind, AdviceKind.uselessSpendingUp);
      expect(advice.single.percent, 30);
    });

    test('просадка сбережений считается в пунктах, а не в процентах', () {
      // 20 → 16 это четыре пункта: ещё не повод, хотя «на пятую часть
      // меньше» звучало бы тревожно.
      expect(
        WealthRules.advise(
          breaches: const [],
          savingsRate: 16,
          savingsRateAverage: 20,
        ),
        isEmpty,
      );
      expect(
        WealthRules.advise(
          breaches: const [],
          savingsRate: 15,
          savingsRateAverage: 20,
        ).single.kind,
        AdviceKind.savingsBelowOwnAverage,
      );
    });

    test('превышение порога риска попадает в советы вместе с числами', () {
      final breaches = WealthRules.riskBreaches([
        asset('вклад', 400, low),
        asset('крипта', 600, high),
      ]);
      final advice = WealthRules.advise(breaches: breaches);

      expect(advice.single.kind, AdviceKind.riskOverLimit);
      expect(advice.single.label, 'Высокий');
      expect(advice.single.percent, 60);
      expect(advice.single.limit, 30);
    });

    test('неизвестные величины не превращаются в поводы', () {
      // Нет прошлого периода — не с чем сравнивать, и это не «всё хорошо»
      // и не «всё плохо», а молчание.
      final advice = WealthRules.advise(breaches: const []);
      expect(advice, isEmpty);
    });
  });

  group('процент сбережений', () {
    test('обычный случай', () {
      expect(SavingsRate.forPeriod(income: 100000, expense: 75000), 25);
    });

    test('перерасход даёт отрицательный процент, а не ноль', () {
      expect(SavingsRate.forPeriod(income: 100, expense: 150), -50);
    });

    test('месяц без дохода — это не ноль процентов', () {
      // Делить не на что. Ноль здесь смешал бы месяц без поступлений с
      // месяцем, где всё потрачено подчистую.
      expect(SavingsRate.forPeriod(income: 0, expense: 500), isNull);
    });

    test('среднее берётся только по месяцам, где процент есть', () {
      expect(SavingsRate.average([20, null, 30]), 25);
      expect(SavingsRate.average([null, null]), isNull);
      expect(SavingsRate.average(const []), isNull);
    });
  });

  group('подписки', () {
    SubscriptionEntity sub(
      double amount,
      SubscriptionPeriod period, {
      int? customDays,
    }) =>
        SubscriptionEntity(
          id: 's',
          name: 's',
          amount: amount,
          period: period,
          customDays: customDays,
          nextChargeAt: DateTime(2026, 9, 20),
          isActive: true,
          createdAt: DateTime(2026),
        );

    test('годовая приводится к месячной', () {
      final yearly = sub(1200, SubscriptionPeriod.yearly);
      expect(yearly.monthlyCost, closeTo(100, 1));
    });

    test('месячная остаётся собой', () {
      expect(sub(500, SubscriptionPeriod.monthly).monthlyCost, closeTo(500, 0.01));
    });

    test('свой период тоже нормализуется', () {
      // Раз в две недели — это чуть больше двух списаний в месяц.
      final biweekly = sub(100, SubscriptionPeriod.custom, customDays: 14);
      expect(biweekly.monthlyCost, closeTo(217.4, 0.5));
    });

    test('дни до списания считаются по датам, а не по часам', () {
      final s = sub(100, SubscriptionPeriod.monthly);
      expect(s.daysUntilCharge(DateTime(2026, 9, 18, 23, 59)), 2);
      expect(s.daysUntilCharge(DateTime(2026, 9, 20, 0, 1)), 0);
      // Дата прошла, а сдвинуть ещё не успели.
      expect(s.daysUntilCharge(DateTime(2026, 9, 22)), -2);
    });
  });
}
