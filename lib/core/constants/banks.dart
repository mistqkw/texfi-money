import 'package:flutter/material.dart';

/// Пресет банка для быстрого выбора счёта: имя + акцентный цвет.
/// Бейдж в UI — стилизованная монограмма (первая буква названия),
/// НЕ официальный логотип банка — в приложении не используются чужие
/// товарные знаки/логотипы, только собственное оформление в фирменном
/// стиле TexFi.
class BankPreset {
  const BankPreset({required this.id, required this.name, required this.colorValue});

  final String id;
  final String name;
  final int colorValue;

  Color get color => Color(colorValue);
  String get monogram => name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
}

/// Подборка банков, покрывающая валюты, доступные в приложении. Список не
/// привязан к стране жёстко — пользователь просто ищет свой банк по имени.
abstract final class BankCatalog {
  static const List<BankPreset> all = [
    BankPreset(id: 'sber', name: 'Сбербанк', colorValue: 0xFF21A038),
    BankPreset(id: 'tbank', name: 'Т-Банк', colorValue: 0xFFFFDD2D),
    BankPreset(id: 'vtb', name: 'ВТБ', colorValue: 0xFF00509E),
    BankPreset(id: 'alfa', name: 'Альфа-Банк', colorValue: 0xFFEF3124),
    BankPreset(id: 'raiffeisen', name: 'Райффайзен Банк', colorValue: 0xFFFFED00),
    BankPreset(id: 'gazprombank', name: 'Газпромбанк', colorValue: 0xFF0033A0),
    BankPreset(id: 'chase', name: 'Chase', colorValue: 0xFF117ACA),
    BankPreset(id: 'bofa', name: 'Bank of America', colorValue: 0xFFE31837),
    BankPreset(id: 'wellsfargo', name: 'Wells Fargo', colorValue: 0xFFD71E28),
    BankPreset(id: 'citibank', name: 'Citibank', colorValue: 0xFF003D79),
    BankPreset(id: 'deutschebank', name: 'Deutsche Bank', colorValue: 0xFF0018A8),
    BankPreset(id: 'bnpparibas', name: 'BNP Paribas', colorValue: 0xFF00915A),
    BankPreset(id: 'ing', name: 'ING', colorValue: 0xFFFF6200),
    BankPreset(id: 'santander', name: 'Santander', colorValue: 0xFFEC0000),
    BankPreset(id: 'privatbank', name: 'ПриватБанк', colorValue: 0xFF5EB92C),
    BankPreset(id: 'monobank', name: 'monobank', colorValue: 0xFF000000),
    BankPreset(id: 'oschadbank', name: 'Ощадбанк', colorValue: 0xFF00A651),
    BankPreset(id: 'pkobp', name: 'PKO BP', colorValue: 0xFFC00A27),
    BankPreset(id: 'mbank', name: 'mBank', colorValue: 0xFF000000),
    BankPreset(id: 'barclays', name: 'Barclays', colorValue: 0xFF00AEEF),
    BankPreset(id: 'hsbc', name: 'HSBC', colorValue: 0xFFDB0011),
    BankPreset(id: 'lloyds', name: 'Lloyds Bank', colorValue: 0xFF024731),
    BankPreset(id: 'natwest', name: 'NatWest', colorValue: 0xFF5A287D),
    BankPreset(id: 'kaspi', name: 'Kaspi Bank', colorValue: 0xFFE41E26),
    BankPreset(id: 'halyk', name: 'Halyk Bank', colorValue: 0xFF00A651),
    BankPreset(id: 'ziraat', name: 'Ziraat Bankası', colorValue: 0xFFC8102E),
    BankPreset(id: 'isbank', name: 'İş Bankası', colorValue: 0xFF002F6C),
    BankPreset(id: 'icbc', name: 'ICBC', colorValue: 0xFFC7000B),
    BankPreset(id: 'ccb', name: 'CCB', colorValue: 0xFF003399),
    BankPreset(id: 'other', name: 'Другой банк', colorValue: 0xFF6D94FB),
  ];

  static BankPreset? byId(String? id) {
    if (id == null) return null;
    for (final bank in all) {
      if (bank.id == id) return bank;
    }
    return null;
  }
}
