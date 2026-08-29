import 'package:flutter/material.dart';

import '../entities/account_entity.dart';

abstract class AccountRepository {
  Stream<List<AccountEntity>> watchAll();

  /// Баланс счёта: сумма подписанных сумм всех привязанных транзакций.
  Stream<double> watchBalance(String accountId);

  Future<String> create({required String name, required Color color, String? bankId});

  Future<void> update(AccountEntity account);

  Future<void> delete(String id);
}
