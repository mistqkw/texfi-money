import 'package:flutter/material.dart';

class AccountEntity {
  const AccountEntity({
    required this.id,
    required this.name,
    required this.color,
    required this.createdAt,
    this.bankId,
  });

  final String id;
  final String name;
  final Color color;
  final DateTime createdAt;
  final String? bankId;

  AccountEntity copyWith({
    String? name,
    Color? color,
    String? bankId,
    bool clearBank = false,
  }) =>
      AccountEntity(
        id: id,
        name: name ?? this.name,
        color: color ?? this.color,
        createdAt: createdAt,
        bankId: clearBank ? null : (bankId ?? this.bankId),
      );
}
