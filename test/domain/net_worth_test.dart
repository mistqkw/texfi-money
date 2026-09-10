import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/domain/entities/asset_entity.dart';
import 'package:texfi_money/domain/entities/cash_flow_type.dart';
import 'package:texfi_money/domain/entities/net_worth.dart';

/// Расчёты капитала.
///
/// Проверяется то, на что человек смотрит, принимая решения о собственных
/// деньгах, и то, где легче всего ошибиться незаметно: знак пассива,
/// деление на ноль и выбор оценки на дату.
void main() {
  const category = AssetCategoryEntity(
    id: 'c1',
    name: 'Недвижимость',
    iconKey: 'home',
    color: Colors.blue,
    isCustom: false,
  );
  const otherCategory = AssetCategoryEntity(
    id: 'c2',
    name: 'Наличные',
    iconKey: 'money',
    color: Colors.green,
    isCustom: false,
  );
  const lowRisk = RiskLevelEntity(
    id: 'r1',
    name: 'Низкий',
    rank: 0,
    color: Colors.green,
    maxSharePercent: null,
    isCustom: false,
  );
  const highRisk = RiskLevelEntity(
    id: 'r2',
    name: 'Высокий',
    rank: 2,
    color: Colors.red,
    maxSharePercent: 30,
    isCustom: false,
  );

  AssetEntity asset({
    required String id,
    required double value,
    CashFlowType flow = CashFlowType.neutral,
    AssetCategoryEntity cat = category,
    RiskLevelEntity risk = lowRisk,
  }) {
    return AssetEntity(
      id: id,
      name: id,
      category: cat,
      riskLevel: risk,
      cashFlowType: flow,
      currentValue: value,
      createdAt: DateTime(2026),
    );
  }

  group('капитал', () {
    test('пассив вычитается, остальное складывается', () {
      final snapshot = NetWorth.snapshot([
        asset(id: 'квартира', value: 5000000),
        asset(id: 'аренда', value: 1000000, flow: CashFlowType.income),
        asset(id: 'ипотека', value: 3000000, flow: CashFlowType.liability),
      ]);

      expect(snapshot.assets, 6000000);
      expect(snapshot.liabilities, 3000000);
      expect(snapshot.total, 3000000);
    });

    test('стоимость пассива положительна, а вклад в капитал — нет', () {
      // Ровно то место, где «сколько стоит» и «сколько прибавляет»
      // расходятся: у долга размер положительный, а капитал он уменьшает.
      final debt = asset(id: 'кредит', value: 200000, flow: CashFlowType.liability);
      expect(debt.currentValue, 200000);
      expect(debt.netWorthContribution, -200000);
    });

    test('пустой список — нули, а не падение', () {
      final snapshot = NetWorth.snapshot(const []);
      expect(snapshot.total, 0);
      expect(snapshot.assets, 0);
      expect(snapshot.liabilities, 0);
    });

    test('капитал может быть отрицательным', () {
      // Долгов больше, чем имущества. Обрезать это до нуля значило бы
      // соврать в приятную сторону там, где правда важнее всего.
      final snapshot = NetWorth.snapshot([
        asset(id: 'машина', value: 500000),
        asset(id: 'кредит', value: 900000, flow: CashFlowType.liability),
      ]);
      expect(snapshot.total, -400000);
    });
  });

  group('распределение', () {
    test('доли считаются по стоимостям и сортируются по убыванию', () {
      final shares = NetWorth.shares(
        [
          asset(id: 'а', value: 250, cat: otherCategory),
          asset(id: 'б', value: 750),
        ],
        (a) => a.category.id,
      );

      expect(shares.first.key, 'c1');
      expect(shares.first.percent, 75);
      expect(shares.last.key, 'c2');
      expect(shares.last.percent, 25);
    });

    test('пассив не уменьшает долю своей категории', () {
      // Иначе выходило бы, что чем больше долг в рискованной категории,
      // тем спокойнее выглядит картина.
      final shares = NetWorth.shares(
        [
          asset(id: 'вклад', value: 100, risk: lowRisk),
          asset(id: 'кредит', value: 100, risk: highRisk, flow: CashFlowType.liability),
        ],
        (a) => a.riskLevel.id,
      );

      expect(shares.every((s) => s.percent == 50), isTrue);
    });

    test('нулевые стоимости не приводят к делению на ноль', () {
      final shares = NetWorth.shares(
        [asset(id: 'пустой', value: 0)],
        (a) => a.category.id,
      );
      expect(shares.single.percent, 0);
    });
  });

  group('оценка на дату', () {
    final history = [
      AssetValuePoint(id: '1', value: 100, recordedAt: DateTime(2025, 1, 1)),
      AssetValuePoint(id: '2', value: 150, recordedAt: DateTime(2025, 6, 1)),
      AssetValuePoint(id: '3', value: 120, recordedAt: DateTime(2026, 1, 1)),
    ];

    test('берётся последняя оценка не позже даты', () {
      expect(NetWorth.valueAt(history, DateTime(2025, 8, 1)), 150);
      expect(NetWorth.valueAt(history, DateTime(2025, 6, 1)), 150);
      expect(NetWorth.valueAt(history, DateTime(2026, 5, 1)), 120);
    });

    test('до первой оценки актива не существует', () {
      // Не ноль, а «нет»: купленная в июне квартира не должна выглядеть
      // как прошлогодний рост капитала.
      expect(NetWorth.valueAt(history, DateTime(2024, 12, 31)), isNull);
    });

    test('пустая история не даёт значения', () {
      expect(NetWorth.valueAt(const [], DateTime(2026)), isNull);
    });
  });

  group('изменение капитала', () {
    test('считает абсолют и процент', () {
      const change = NetWorthChange(from: 1000, to: 1250);
      expect(change.absolute, 250);
      expect(change.percent, 25);
    });

    test('падение показывается отрицательным', () {
      const change = NetWorthChange(from: 1000, to: 800);
      expect(change.absolute, -200);
      expect(change.percent, -20);
    });

    test('от нуля и от долга процент не считается', () {
      // «Рост на 400%» при переходе от минус десяти тысяч к плюс тридцати
      // арифметически объясним и совершенно бессмыслен.
      expect(const NetWorthChange(from: 0, to: 500).percent, isNull);
      expect(const NetWorthChange(from: -10000, to: 30000).percent, isNull);
      expect(const NetWorthChange(from: 0, to: 500).absolute, 500);
    });
  });
}
