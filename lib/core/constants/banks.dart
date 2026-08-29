import 'package:flutter/material.dart';

/// Форма фирменного знака банка. Это собственная абстрактная графика
/// TexFi (кольцо, арка, столбики...), а НЕ логотип банка: чужие товарные
/// знаки в приложение не встраиваются. Если нужен настоящий логотип —
/// см. `assets/banks/README.md`, файл подставится автоматически.
enum BankGlyph { ring, arc, bars, shield, wave, diamond, blocks, dot }

class BankPreset {
  const BankPreset({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.glyph,
  });

  final String id;
  final String name;
  final int colorValue;
  final BankGlyph glyph;

  Color get color => Color(colorValue);

  /// Путь к пользовательскому логотипу, если он положен в assets.
  String get assetPath => 'assets/banks/$id.png';
}

/// Подборка банков, покрывающая валюты приложения. Список не привязан
/// к стране жёстко — пользователь просто находит свой банк по названию.
abstract final class BankCatalog {
  static const List<BankPreset> all = [
    BankPreset(id: 'sber', name: 'Сбербанк', colorValue: 0xFF21A038, glyph: BankGlyph.ring),
    BankPreset(id: 'tbank', name: 'Т-Банк', colorValue: 0xFFFFDD2D, glyph: BankGlyph.shield),
    BankPreset(id: 'vtb', name: 'ВТБ', colorValue: 0xFF00509E, glyph: BankGlyph.bars),
    BankPreset(id: 'alfa', name: 'Альфа-Банк', colorValue: 0xFFEF3124, glyph: BankGlyph.arc),
    BankPreset(id: 'raiffeisen', name: 'Райффайзен', colorValue: 0xFFFFCC00, glyph: BankGlyph.diamond),
    BankPreset(id: 'gazprombank', name: 'Газпромбанк', colorValue: 0xFF0033A0, glyph: BankGlyph.wave),
    BankPreset(id: 'chase', name: 'Chase', colorValue: 0xFF117ACA, glyph: BankGlyph.blocks),
    BankPreset(id: 'bofa', name: 'Bank of America', colorValue: 0xFFE31837, glyph: BankGlyph.wave),
    BankPreset(id: 'wellsfargo', name: 'Wells Fargo', colorValue: 0xFFD71E28, glyph: BankGlyph.shield),
    BankPreset(id: 'citibank', name: 'Citibank', colorValue: 0xFF003D79, glyph: BankGlyph.arc),
    BankPreset(id: 'deutschebank', name: 'Deutsche Bank', colorValue: 0xFF0018A8, glyph: BankGlyph.diamond),
    BankPreset(id: 'bnpparibas', name: 'BNP Paribas', colorValue: 0xFF00915A, glyph: BankGlyph.bars),
    BankPreset(id: 'ing', name: 'ING', colorValue: 0xFFFF6200, glyph: BankGlyph.ring),
    BankPreset(id: 'santander', name: 'Santander', colorValue: 0xFFEC0000, glyph: BankGlyph.arc),
    BankPreset(id: 'privatbank', name: 'ПриватБанк', colorValue: 0xFF5EB92C, glyph: BankGlyph.blocks),
    BankPreset(id: 'monobank', name: 'monobank', colorValue: 0xFF1A1A1A, glyph: BankGlyph.dot),
    BankPreset(id: 'oschadbank', name: 'Ощадбанк', colorValue: 0xFF00A651, glyph: BankGlyph.shield),
    BankPreset(id: 'pkobp', name: 'PKO BP', colorValue: 0xFFC00A27, glyph: BankGlyph.diamond),
    BankPreset(id: 'mbank', name: 'mBank', colorValue: 0xFF1A1A1A, glyph: BankGlyph.bars),
    BankPreset(id: 'barclays', name: 'Barclays', colorValue: 0xFF00AEEF, glyph: BankGlyph.wave),
    BankPreset(id: 'hsbc', name: 'HSBC', colorValue: 0xFFDB0011, glyph: BankGlyph.diamond),
    BankPreset(id: 'lloyds', name: 'Lloyds', colorValue: 0xFF024731, glyph: BankGlyph.ring),
    BankPreset(id: 'natwest', name: 'NatWest', colorValue: 0xFF5A287D, glyph: BankGlyph.blocks),
    BankPreset(id: 'kaspi', name: 'Kaspi Bank', colorValue: 0xFFE41E26, glyph: BankGlyph.dot),
    BankPreset(id: 'halyk', name: 'Halyk Bank', colorValue: 0xFF00A651, glyph: BankGlyph.arc),
    BankPreset(id: 'ziraat', name: 'Ziraat', colorValue: 0xFFC8102E, glyph: BankGlyph.shield),
    BankPreset(id: 'isbank', name: 'İş Bankası', colorValue: 0xFF002F6C, glyph: BankGlyph.ring),
    BankPreset(id: 'icbc', name: 'ICBC', colorValue: 0xFFC7000B, glyph: BankGlyph.bars),
    BankPreset(id: 'ccb', name: 'CCB', colorValue: 0xFF003399, glyph: BankGlyph.blocks),
    BankPreset(id: 'other', name: 'Другой банк', colorValue: 0xFF6D94FB, glyph: BankGlyph.dot),
  ];

  static BankPreset? byId(String? id) {
    if (id == null) return null;
    for (final bank in all) {
      if (bank.id == id) return bank;
    }
    return null;
  }
}
