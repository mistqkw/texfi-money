import 'package:flutter/material.dart';

import '../entities/debt_profile_entity.dart';

abstract class DebtProfileRepository {
  Stream<List<DebtProfileEntity>> watchAll();

  Future<String> create({required String name, required Color color});

  /// Записывает операцию: [delta] > 0 — человек занял у пользователя ещё,
  /// [delta] < 0 — человек вернул часть долга (или пользователь занял у
  /// него, если баланс уходит в минус).
  Future<void> adjustBalance({required String id, required double delta});

  Future<void> update(DebtProfileEntity profile);

  Future<void> delete(String id);
}
