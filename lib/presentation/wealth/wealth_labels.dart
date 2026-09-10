import '../../domain/entities/cash_flow_type.dart';
import '../../domain/entities/spend_usefulness.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/entities/subscription_period.dart';
import '../../domain/entities/wealth_rules.dart';
import '../../l10n/app_localizations.dart';
import '../shared/pixel_icon.dart';

/// Подписи и иконки для сущностей учёта капитала.
///
/// Отдельным файлом, потому что одни и те же значения подписываются на
/// пяти экранах, и разъехавшиеся формулировки — самый дешёвый способ
/// сделать так, чтобы «пассив» на одном экране и «забирает деньги» на
/// другом читались как разные вещи.
String cashFlowLabel(AppLocalizations l10n, CashFlowType type) =>
    switch (type) {
      CashFlowType.income => l10n.flowIncome,
      CashFlowType.liability => l10n.flowLiability,
      CashFlowType.neutral => l10n.flowNeutral,
    };

List<String> cashFlowIcon(CashFlowType type) => switch (type) {
      CashFlowType.income => PixelIcons.flowIncome,
      CashFlowType.liability => PixelIcons.flowLiability,
      CashFlowType.neutral => PixelIcons.flowNeutral,
    };

String usefulnessLabel(AppLocalizations l10n, SpendUsefulness? value) =>
    switch (value) {
      SpendUsefulness.useful => l10n.usefulnessUseful,
      SpendUsefulness.useless => l10n.usefulnessUseless,
      SpendUsefulness.neutral => l10n.usefulnessNeutral,
      // Отдельная подпись, а не «нейтрально»: у человека, который вообще
      // не пользуется оценкой, весь период иначе выглядел бы взвешенным.
      null => l10n.usefulnessNotRated,
    };

String periodLabel(AppLocalizations l10n, SubscriptionPeriod period) =>
    switch (period) {
      SubscriptionPeriod.monthly => l10n.periodMonthly,
      SubscriptionPeriod.yearly => l10n.periodYearly,
      SubscriptionPeriod.custom => l10n.periodCustom,
    };

/// Когда спишут — словами там, где слова понятнее числа.
String chargeLabel(AppLocalizations l10n, SubscriptionEntity sub, DateTime now) {
  final days = sub.daysUntilCharge(now);
  if (days < 0) return l10n.chargeOverdue;
  if (days == 0) return l10n.chargeToday;
  if (days == 1) return l10n.chargeTomorrow;
  return l10n.chargeInDays(days);
}

/// Текст совета.
///
/// Правило знает числа, но не язык: [Advice] приходит из чистой логики,
/// где никакой локализации нет и быть не должно. Подстановка живёт здесь.
String adviceText(AppLocalizations l10n, Advice advice) {
  String pct(double? value) => (value ?? 0).toStringAsFixed(0);

  return switch (advice.kind) {
    AdviceKind.riskOverLimit => l10n.adviceRisk(
        advice.label ?? '',
        pct(advice.percent),
        pct(advice.limit),
      ),
    AdviceKind.uselessSpendingUp => l10n.adviceUseless(pct(advice.percent)),
    AdviceKind.subscriptionsUp => l10n.adviceSubscriptions(pct(advice.percent)),
    AdviceKind.savingsBelowOwnAverage => l10n.adviceSavings(
        pct(advice.percent),
        pct(advice.limit),
      ),
  };
}
