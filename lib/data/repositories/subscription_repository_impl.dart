import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/subscription_entity.dart';
import '../../domain/entities/subscription_period.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../local/database.dart';
import 'category_repository_impl.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl(this._db, this._categories);

  final AppDatabase _db;
  final CategoryRepositoryImpl _categories;
  final _uuid = const Uuid();

  /// Категории подтягиваются одной выборкой на весь список, а не по одной
  /// на подписку: их десяток, а запросов иначе было бы столько же, сколько
  /// строк на экране.
  Future<List<SubscriptionEntity>> _mapAll(List<Subscription> rows) async {
    if (rows.isEmpty) return const [];
    final categories = {
      for (final row in await _db.select(_db.categories).get())
        row.id: _categories.mapRow(row),
    };
    return [
      for (final row in rows)
        SubscriptionEntity(
          id: row.id,
          name: row.name,
          amount: row.amount,
          period: SubscriptionPeriod.fromStorageKey(row.period),
          customDays: row.customDays,
          nextChargeAt: row.nextChargeAt,
          category: categories[row.categoryId],
          isActive: row.isActive,
          createdAt: row.createdAt,
        ),
    ];
  }

  @override
  Stream<List<SubscriptionEntity>> watchActive() {
    return (_db.select(_db.subscriptions)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm(expression: t.nextChargeAt)]))
        .watch()
        .asyncMap(_mapAll);
  }

  @override
  Stream<List<SubscriptionEntity>> watchAll() {
    return (_db.select(_db.subscriptions)
          ..orderBy([(t) => OrderingTerm(expression: t.nextChargeAt)]))
        .watch()
        .asyncMap(_mapAll);
  }

  @override
  Future<List<SubscriptionEntity>> allOnce() async {
    final rows = await _db.select(_db.subscriptions).get();
    return _mapAll(rows);
  }

  @override
  Future<String> create({
    required String name,
    required double amount,
    required SubscriptionPeriod period,
    int? customDays,
    required DateTime nextChargeAt,
    String? categoryId,
  }) async {
    final id = _uuid.v4();
    await _db.into(_db.subscriptions).insert(
          SubscriptionsCompanion.insert(
            id: id,
            name: name,
            amount: amount,
            period: period.storageKey,
            customDays: Value(customDays),
            nextChargeAt: nextChargeAt,
            categoryId: Value(categoryId),
          ),
        );
    return id;
  }

  @override
  Future<void> update({
    required String id,
    required String name,
    required double amount,
    required SubscriptionPeriod period,
    int? customDays,
    required DateTime nextChargeAt,
    String? categoryId,
  }) async {
    await (_db.update(_db.subscriptions)..where((t) => t.id.equals(id))).write(
      SubscriptionsCompanion(
        name: Value(name),
        amount: Value(amount),
        period: Value(period.storageKey),
        customDays: Value(customDays),
        nextChargeAt: Value(nextChargeAt),
        categoryId: Value(categoryId),
      ),
    );
  }

  @override
  Future<void> setActive({required String id, required bool isActive}) async {
    await (_db.update(_db.subscriptions)..where((t) => t.id.equals(id)))
        .write(SubscriptionsCompanion(isActive: Value(isActive)));
  }

  @override
  Future<void> advanceCharge(String id) async {
    final row = await (_db.select(_db.subscriptions)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return;

    final period = SubscriptionPeriod.fromStorageKey(row.period);
    var next = row.nextChargeAt;
    // Циклом, а не одним прибавлением: подписку могли не открывать
    // несколько периодов, и одна прибавка оставила бы дату в прошлом.
    // Потолок — страховка от вырожденного периода в ноль дней, а не
    // ожидаемый режим.
    for (var guard = 0; guard < 512; guard++) {
      next = switch (period) {
        SubscriptionPeriod.monthly =>
          DateTime(next.year, next.month + 1, next.day),
        SubscriptionPeriod.yearly =>
          DateTime(next.year + 1, next.month, next.day),
        SubscriptionPeriod.custom =>
          next.add(Duration(days: (row.customDays ?? 30).clamp(1, 3650))),
      };
      if (next.isAfter(DateTime.now())) break;
    }

    await (_db.update(_db.subscriptions)..where((t) => t.id.equals(id)))
        .write(SubscriptionsCompanion(nextChargeAt: Value(next)));
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.subscriptions)..where((t) => t.id.equals(id))).go();
  }
}
