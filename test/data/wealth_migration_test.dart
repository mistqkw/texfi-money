import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/data/local/database.dart';
import 'package:texfi_money/data/repositories/asset_repository_impl.dart';
import 'package:texfi_money/domain/entities/cash_flow_type.dart';

/// Учёт капитала на настоящей базе.
///
/// Проверяется то, что нельзя увидеть глазами до того, как станет поздно:
/// что новые таблицы создаются, что справочники наполняются, что оценка
/// задним числом не подменяет текущую стоимость и что справочник нельзя
/// выдернуть из-под уже созданных активов.
void main() {
  late AppDatabase db;
  late AssetRepositoryImpl assets;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    assets = AssetRepositoryImpl(db);
  });

  tearDown(() => db.close());

  group('схема', () {
    test('справочники наполнены на свежей базе', () async {
      // Пустой справочник — это экран, на котором нельзя создать актив.
      final categories = await db.select(db.assetCategories).get();
      final levels = await db.select(db.riskLevels).get();

      expect(categories, isNotEmpty);
      expect(levels, hasLength(3));
      expect(levels.map((l) => l.rank), [0, 1, 2]);
    });

    test('порог задан только у верхнего уровня', () async {
      final levels = await db.select(db.riskLevels).get();
      final withLimit = levels.where((l) => l.maxSharePercent != null);

      expect(withLimit, hasLength(1));
      expect(withLimit.single.rank, 2);
    });

    test('у старых транзакций оценки полезности нет, а не «нейтрально»', () async {
      await db.into(db.transactions).insert(
            TransactionsCompanion.insert(
              id: 't1',
              amount: 100,
              type: 'expense',
              categoryId: 'food',
              date: DateTime(2026, 9, 1),
            ),
          );

      final row = await db.select(db.transactions).getSingle();
      expect(row.usefulness, isNull);
    });
  });

  group('оценки актива', () {
    Future<String> createHouse() => assets.create(
          name: 'Квартира',
          categoryId: 'asset_property',
          riskLevelId: 'risk_low',
          cashFlowType: CashFlowType.neutral,
          value: 5000000,
          valuedAt: DateTime(2025, 1, 1),
        );

    test('создание сразу заводит точку истории', () async {
      // Без неё актив, стоимость которого ни разу не меняли, появлялся бы
      // в динамике капитала из ниоткуда.
      final id = await createHouse();
      final history = await assets.watchHistory(id).first;

      expect(history, hasLength(1));
      expect(history.single.value, 5000000);
    });

    test('переоценка добавляет точку, а не переписывает прошлую', () async {
      final id = await createHouse();
      await assets.revalue(
        assetId: id,
        value: 5500000,
        recordedAt: DateTime(2026, 1, 1),
      );

      final history = await assets.watchHistory(id).first;
      expect(history.map((p) => p.value), [5000000, 5500000]);
    });

    test('оценка задним числом не становится текущей', () async {
      // Человек вносит стоимость, которая была год назад. Текущей она от
      // этого не делается — иначе капитал сегодня показал бы прошлое.
      final id = await createHouse();
      await assets.revalue(
        assetId: id,
        value: 5500000,
        recordedAt: DateTime(2026, 1, 1),
      );
      await assets.revalue(
        assetId: id,
        value: 4000000,
        recordedAt: DateTime(2024, 6, 1),
      );

      final asset = (await assets.watchAll().first).single;
      expect(asset.currentValue, 5500000);
    });

    test('удаление точки возвращает стоимость к оставшейся свежей', () async {
      final id = await createHouse();
      await assets.revalue(
        assetId: id,
        value: 5500000,
        recordedAt: DateTime(2026, 1, 1),
      );

      final history = await assets.watchHistory(id).first;
      await assets.deleteValuePoint(history.last.id);

      final asset = (await assets.watchAll().first).single;
      expect(asset.currentValue, 5000000);
    });

    test('последнюю точку удалить нельзя', () async {
      // Актив без единой оценки не имеет стоимости, а значит и места в
      // капитале. Удалять надо сам актив.
      final id = await createHouse();
      final history = await assets.watchHistory(id).first;

      await assets.deleteValuePoint(history.single.id);
      expect(await assets.watchHistory(id).first, hasLength(1));
    });

    test('удаление актива уносит его историю', () async {
      final id = await createHouse();
      await assets.delete(id);

      expect(await db.select(db.assetValues).get(), isEmpty);
    });
  });

  group('справочники под нагрузкой', () {
    test('категорию с активами удалить нельзя', () async {
      await assets.create(
        name: 'Машина',
        categoryId: 'asset_transport',
        riskLevelId: 'risk_low',
        cashFlowType: CashFlowType.liability,
        value: 800000,
        valuedAt: DateTime(2026, 1, 1),
      );

      expect(await assets.deleteCategory('asset_transport'), isFalse);
      expect(await assets.deleteCategory('asset_business'), isTrue);
    });

    test('уровень риска с активами удалить нельзя', () async {
      await assets.create(
        name: 'Крипта',
        categoryId: 'asset_investments',
        riskLevelId: 'risk_high',
        cashFlowType: CashFlowType.neutral,
        value: 100000,
        valuedAt: DateTime(2026, 1, 1),
      );

      expect(await assets.deleteRiskLevel('risk_high'), isFalse);
      expect(await assets.deleteRiskLevel('risk_medium'), isTrue);
    });

    test('последний уровень риска удалить нельзя', () async {
      // Без единого уровня актив нельзя создать вовсе.
      expect(await assets.deleteRiskLevel('risk_medium'), isTrue);
      expect(await assets.deleteRiskLevel('risk_high'), isTrue);
      expect(await assets.deleteRiskLevel('risk_low'), isFalse);
    });
  });
}
