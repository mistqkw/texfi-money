import 'package:drift/drift.dart';

import '../../core/theme/app_colors.dart';
import 'database.dart';

/// Предустановленные категории активов.
///
/// Список намеренно короткий и общий. Он не пытается покрыть все способы
/// хранить капитал — он даёт то, с чего можно начать, не изобретая
/// классификацию на пустом экране. Всё остальное человек заводит сам, как
/// и категории трат.
///
/// Названия на английском: справочник заполняется один раз при создании
/// базы, когда язык интерфейса ещё не выбран, и переименовать категорию
/// проще, чем объяснять, почему она пришла на чужом языке. Ровно так же
/// устроены категории транзакций.
List<AssetCategoriesCompanion> buildDefaultAssetCategories() {
  final palette = AppColors.categoryPalette;
  var i = 0;
  int nextColor() => palette[i++ % palette.length].toARGB32();

  AssetCategoriesCompanion item(String id, String name, String iconKey) =>
      AssetCategoriesCompanion.insert(
        id: id,
        name: name,
        iconKey: iconKey,
        colorValue: nextColor(),
        isCustom: const Value(false),
      );

  return [
    item('asset_cash', 'Cash', 'money'),
    item('asset_property', 'Property', 'home'),
    item('asset_investments', 'Investments', 'investments'),
    item('asset_savings', 'Savings', 'savings'),
    item('asset_business', 'Business', 'freelance'),
    item('asset_transport', 'Transport', 'transport'),
    item('asset_other', 'Other', 'other'),
  ];
}

/// Предустановленные уровни риска.
///
/// Три ступени и порог только у верхней. Порог у среднего и низкого риска
/// по умолчанию не задан осознанно: предупреждение имеет смысл там, где
/// человек сам решил, что дальше — слишком, а решать это за него на
/// пустой базе не из чего.
///
/// Тридцать процентов у высокого риска — не рекомендация и не норма. Это
/// значение, от которого удобно оттолкнуться и которое сразу видно, где
/// менять; без него порог остался бы пустым, и раздел риск-менеджмента
/// молчал бы до тех пор, пока о нём не вспомнят.
///
/// Цвета берутся из семантической пары дохода и расхода, а не из акцента.
/// Зелёный и красный здесь читаются как «спокойно» и «опасно» — та же
/// шкала, к которой человек уже привык на суммах, только про другое.
List<RiskLevelsCompanion> buildDefaultRiskLevels() {
  return [
    RiskLevelsCompanion.insert(
      id: 'risk_low',
      name: 'Low',
      rank: 0,
      colorValue: AppColors.income.toARGB32(),
      isCustom: const Value(false),
    ),
    RiskLevelsCompanion.insert(
      id: 'risk_medium',
      name: 'Medium',
      rank: 1,
      colorValue: AppColors.warning.toARGB32(),
      isCustom: const Value(false),
    ),
    RiskLevelsCompanion.insert(
      id: 'risk_high',
      name: 'High',
      rank: 2,
      colorValue: AppColors.expense.toARGB32(),
      maxSharePercent: const Value(30),
      isCustom: const Value(false),
    ),
  ];
}
