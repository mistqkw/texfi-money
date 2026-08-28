import 'package:flutter/material.dart';

class AccountEntity {
  const AccountEntity({
    required this.id,
    required this.name,
    required this.color,
    required this.createdAt,
  });

  final String id;
  final String name;
  final Color color;
  final DateTime createdAt;

  AccountEntity copyWith({String? name, Color? color}) => AccountEntity(
        id: id,
        name: name ?? this.name,
        color: color ?? this.color,
        createdAt: createdAt,
      );
}
