/// Валюты, доступные для отображения сумм в приложении.
/// Это единица отображения, а не мультивалютный учёт с конвертацией —
/// все суммы в БД хранятся как числа без привязки к валюте.
enum AppCurrency {
  rub('RUB', '₽', 'Российский рубль'),
  usd('USD', '\$', 'Доллар США'),
  eur('EUR', '€', 'Евро'),
  uah('UAH', '₴', 'Украинская гривна'),
  pln('PLN', 'zł', 'Польский злотый'),
  byn('BYN', 'Br', 'Белорусский рубль'),
  kzt('KZT', '₸', 'Казахстанский тенге'),
  gbp('GBP', '£', 'Фунт стерлингов'),
  cny('CNY', '¥', 'Китайский юань'),
  tryLira('TRY', '₺', 'Турецкая лира');

  const AppCurrency(this.code, this.symbol, this.displayName);

  final String code;
  final String symbol;
  final String displayName;

  static AppCurrency fromCode(String? code) {
    return AppCurrency.values.firstWhere(
      (c) => c.code == code,
      orElse: () => AppCurrency.rub,
    );
  }
}
