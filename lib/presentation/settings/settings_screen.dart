import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/app_font.dart';
import '../../core/constants/app_theme_variant.dart';
import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_page_transitions.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/haptics.dart';
import '../../data/local/backup_service.dart';
import '../../data/providers/data_providers.dart';
import '../../l10n/app_localizations.dart';
import '../accounts/accounts_screen.dart';
import '../profiles/debt_profiles_screen.dart';
import '../shared/l10n_helpers.dart';
import '../shared/pixel_card.dart';
import '../shared/pixel_icon.dart';
import '../shared/pixel_switch.dart';
import '../shared/restart_widget.dart';
import 'about_screen.dart';
import 'analysis_range_provider.dart';
import 'currency_picker_screen.dart';
import 'currency_provider.dart';
import 'font_provider.dart';
import 'haptics_provider.dart';
import 'language_picker_screen.dart';
import 'locale_provider.dart';
import 'risk_settings_screen.dart';
import 'security_provider.dart';
import 'theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  String _themeLabel(BuildContext context, AppThemeVariant variant) {
    final l10n = context.l10n;
    return switch (variant) {
      AppThemeVariant.dark => l10n.themeDark,
      AppThemeVariant.light => l10n.themeLight,
      AppThemeVariant.oled => l10n.themeOled,
    };
  }

  List<String> _themeIcon(AppThemeVariant variant) => switch (variant) {
        AppThemeVariant.dark => PixelIcons.themeDark,
        AppThemeVariant.light => PixelIcons.themeLight,
        AppThemeVariant.oled => PixelIcons.themeContrast,
      };

  String _fontLabel(AppFont font, AppLocalizations l10n) => switch (font) {
        AppFont.inter => 'Inter',
        AppFont.system => l10n.fontSystem,
      };

  Future<void> _exportBackup(BuildContext context, WidgetRef ref) async {
    final json = await ref.read(backupServiceProvider).exportToJson();
    final dir = await getTemporaryDirectory();
    final stamp = DateTime.now().toIso8601String().replaceAll(RegExp(r'[:.]'), '-');
    final file = File('${dir.path}/texfi-money-backup-$stamp.json');
    await file.writeAsString(json);

    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  Future<void> _showResultDialog(BuildContext context, {required String title}) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.commonOk),
          ),
        ],
      ),
    );
  }

  Future<void> _importBackup(BuildContext context, WidgetRef ref) async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();

    if (!context.mounted) return;
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.backupImportConfirmTitle),
        content: Text(l10n.backupImportConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.backupImportConfirmAction),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(backupServiceProvider).restoreFromJson(utf8.decode(bytes));
      Haptics.success();
      if (!context.mounted) return;
      await _showResultDialog(context, title: l10n.backupImportSuccess);
    } on BackupFormatException {
      Haptics.error();
      if (!context.mounted) return;
      await _showResultDialog(context, title: l10n.backupImportError);
    }
  }

  Future<void> _resetApp(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetAppConfirmTitle),
        content: Text(l10n.resetAppConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.resetAppConfirmAction,
              style: TextStyle(color: context.colors.expense),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    Haptics.warning();

    await ref.read(backupServiceProvider).resetAllData();
    await ref.read(sharedPreferencesProvider).clear();

    if (!context.mounted) return;
    RestartWidget.restartApp(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeVariant = ref.watch(themeVariantProvider);
    final font = ref.watch(fontProvider);
    final currency = ref.watch(currencyProvider);
    final locale = ref.watch(localeProvider);
    final hapticsEnabled = ref.watch(hapticsEnabledProvider);
    final l10n = context.l10n;

    final languageLabel = locale == null
        ? l10n.languageSystem
        : (nativeLanguageNames[locale.languageCode] ?? locale.languageCode);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: AppSpacing.screen,
        children: [
          PixelSectionHeader(title: l10n.settingsLanguageSection, index: 1),
          AppSpacing.gapSm,
          _OptionTile(
            icon: PixelIcons.language,
            label: languageLabel,
            selected: false,
            showCheckmark: false,
            onTap: () => Navigator.of(context).push(
              pixelDissolveRoute(const LanguagePickerScreen()),
            ),
          ),
          AppSpacing.gapXl,
          PixelSectionHeader(title: l10n.settingsThemeSection, index: 2),
          AppSpacing.gapSm,
          ...AppThemeVariant.values.map((variant) => _OptionTile(
                icon: _themeIcon(variant),
                label: _themeLabel(context, variant),
                selected: variant == themeVariant,
                onTap: () => ref.read(themeVariantProvider.notifier).setVariant(variant),
              )),
          AppSpacing.gapXl,
          PixelSectionHeader(title: l10n.settingsFontSection, index: 3),
          AppSpacing.gapSm,
          // Название каждой гарнитуры набрано ею же: выбор шрифта — это
          // единственная настройка, результат которой можно показать прямо
          // в строке выбора. Раньше рядом с четырьмя вариантами стояли
          // четыре одинаковые буквы «A» — значок, который ничего не
          // различает, хуже отсутствия значка.
          ...AppFont.values.map((f) => _FontTile(
                font: f,
                label: _fontLabel(f, l10n),
                selected: f == font,
                onTap: () => ref.read(fontProvider.notifier).setFont(f),
              )),
          AppSpacing.gapXl,
          PixelSectionHeader(title: l10n.settingsHapticsSection, index: 4),
          AppSpacing.gapSm,
          _SwitchTile(
            label: l10n.hapticsEnabled,
            value: hapticsEnabled,
            onChanged: (value) {
              ref.read(hapticsEnabledProvider.notifier).setEnabled(value);
              if (value) Haptics.select();
            },
          ),
          AppSpacing.gapXl,
          PixelSectionHeader(title: l10n.settingsCurrencySection, index: 5),
          AppSpacing.gapSm,
          _OptionTile(
            icon: PixelIcons.money,
            label: '${currencyDisplayName(context, currency)} (${currency.symbol})',
            selected: false,
            showCheckmark: false,
            onTap: () => Navigator.of(context).push(
              pixelDissolveRoute(const CurrencyPickerScreen()),
            ),
          ),
          AppSpacing.gapXl,
          PixelSectionHeader(title: l10n.settingsManageSection, index: 6),
          AppSpacing.gapSm,
          _OptionTile(
            icon: PixelIcons.wallet,
            label: l10n.accountsTitle,
            selected: false,
            showCheckmark: false,
            onTap: () => Navigator.of(context).push(
              pixelDissolveRoute(const AccountsScreen()),
            ),
          ),
          _OptionTile(
            icon: PixelIcons.profiles,
            label: l10n.profilesTitle,
            selected: false,
            showCheckmark: false,
            onTap: () => Navigator.of(context).push(
              pixelDissolveRoute(const DebtProfilesScreen()),
            ),
          ),
          AppSpacing.gapXl,
          PixelSectionHeader(title: l10n.riskSection, index: 7),
          AppSpacing.gapSm,
          _OptionTile(
            icon: PixelIcons.risk,
            label: l10n.riskSection,
            selected: false,
            showCheckmark: false,
            onTap: () => Navigator.of(context).push(
              pixelDissolveRoute(const RiskSettingsScreen()),
            ),
          ),
          const _AnalysisRangeTile(),
          AppSpacing.gapXl,
          PixelSectionHeader(title: l10n.settingsSecuritySection, index: 8),
          AppSpacing.gapSm,
          const _SecuritySection(),
          AppSpacing.gapXl,
          PixelSectionHeader(title: l10n.settingsBackupSection, index: 9),
          AppSpacing.gapSm,
          _OptionTile(
            icon: PixelIcons.backupUp,
            label: l10n.backupExport,
            selected: false,
            showCheckmark: false,
            onTap: () => _exportBackup(context, ref),
          ),
          _OptionTile(
            icon: PixelIcons.backupDown,
            label: l10n.backupImport,
            selected: false,
            showCheckmark: false,
            onTap: () => _importBackup(context, ref),
          ),
          AppSpacing.gapXl,
          // «О приложении» стоит перед опасной зоной, а не после: сброс
          // данных должен оставаться последним пунктом экрана, к которому
          // не промахиваются по дороге к чему-то безобидному.
          PixelSectionHeader(title: l10n.aboutTitle, index: 10),
          AppSpacing.gapSm,
          _OptionTile(
            icon: PixelIcons.info,
            label: l10n.aboutTitle,
            selected: false,
            showCheckmark: false,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const AboutScreen()),
            ),
          ),
          AppSpacing.gapXl,
          PixelSectionHeader(title: l10n.settingsDangerSection, index: 11),
          AppSpacing.gapSm,
          _OptionTile(
            icon: PixelIcons.danger,
            label: l10n.resetApp,
            selected: false,
            showCheckmark: false,
            color: context.colors.expense,
            onTap: () => _resetApp(context, ref),
          ),
        ],
      ),
    );
  }
}

/// Строка выбора гарнитуры: название набрано самой гарнитурой.
class _FontTile extends ConsumerWidget {
  const _FontTile({
    required this.font,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final AppFont font;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final preview = buildAppTextTheme(font: font, colors: colors).titleMedium!;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: preview),
      trailing: selected
          ? PixelIcon(PixelIcons.check, color: colors.accent)
          : null,
      onTap: onTap,
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.showCheckmark = true,
    this.color,
  });

  final List<String> icon;
  final String label;
  final bool selected;
  final bool showCheckmark;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: PixelIcon(icon, color: color ?? context.colors.textSecondary),
      title: Text(label, style: context.text.title.copyWith(color: color)),
      trailing: showCheckmark
          ? (selected ? PixelIcon(PixelIcons.check, color: context.colors.accent) : null)
          : PixelIcon(PixelIcons.chevronRight, color: context.colors.textTertiary, size: 14),
      onTap: onTap,
    );
  }
}

/// Настройки безопасности.
///
/// Отдельным виджетом из-за доступности замка: есть ли на устройстве чем
/// подтвердить личность, приложение узнаёт у системы, ответ приходит
/// асинхронно и может измениться, пока экран открыт — замок заводят и
/// снимают в системных настройках. Предлагать включить блокировку там, где
/// её нечем подтвердить, значило бы обещать защиту, которой не будет.
/// Диапазон, на котором строятся все исторические графики.
///
/// Настройка общая, а не своя у каждого экрана: динамика капитала за пять
/// лет рядом с движением денег за год — это два графика, которые нельзя
/// сопоставить, хотя стоят они рядом и выглядят одинаково.
class _AnalysisRangeTile extends ConsumerWidget {
  const _AnalysisRangeTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final range = ref.watch(analysisRangeProvider);

    return _OptionTile(
      icon: PixelIcons.cashFlow,
      label: l10n.analysisRangeTitle,
      selected: false,
      showCheckmark: false,
      onTap: () => _pick(context, ref, range),
    );
  }

  Future<void> _pick(
    BuildContext context,
    WidgetRef ref,
    AnalysisRange current,
  ) async {
    final l10n = context.l10n;
    final choice = await showModalBottomSheet<Object>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: AppSpacing.screen,
              child: Text(
                l10n.analysisRangeHint,
                style: context.text.caption
                    .copyWith(color: context.colors.textTertiary),
              ),
            ),
            for (final years in const [1, 2, 3, 5, 10])
              ListTile(
                title: Text(l10n.analysisRangeYears(years)),
                trailing: current.years == years
                    ? PixelIcon(
                        PixelIcons.check,
                        size: 16,
                        color: context.colors.accent,
                      )
                    : null,
                onTap: () => Navigator.of(context).pop(years),
              ),
            ListTile(
              title: Text(l10n.analysisRangeCustom),
              trailing: current.isExplicit
                  ? PixelIcon(
                      PixelIcons.check,
                      size: 16,
                      color: context.colors.accent,
                    )
                  : null,
              onTap: () => Navigator.of(context).pop('custom'),
            ),
          ],
        ),
      ),
    );

    if (!context.mounted || choice == null) return;

    if (choice is int) {
      await ref.read(analysisRangeProvider.notifier).setYears(choice);
      return;
    }

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    await ref
        .read(analysisRangeProvider.notifier)
        .setExplicit(from: picked.start, to: picked.end);
  }
}

class _SecuritySection extends ConsumerWidget {
  const _SecuritySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final lock = ref.watch(appLockProvider);
    final hideInSwitcher = ref.watch(hideInSwitcherProvider);
    final privacy = ref.watch(screenPrivacyProvider);
    // Пока ответ не пришёл, считаем замок доступным: мигать предупреждением
    // на каждом заходе в настройки незачем.
    final canLock = ref.watch(appLockAvailableProvider).value ?? true;

    return Column(
      children: [
        if (lock.isSupported)
          _SwitchTile(
            label: l10n.securityAppLock,
            subtitle: canLock
                ? l10n.securityAppLockDesc
                : l10n.securityAppLockUnavailable,
            value: ref.watch(appLockEnabledProvider),
            enabled: canLock,
            onChanged: (value) async {
              // Включение подтверждается замком сразу. Иначе настройку мог
              // бы включить тот, у кого телефон в руках, — и запереть
              // владельца снаружи собственных данных.
              if (value &&
                  !await lock.authenticate(
                    reason: l10n.securityUnlockReason,
                  )) {
                return;
              }
              await ref.read(appLockEnabledProvider.notifier).set(value);
              ref.invalidate(appLockAvailableProvider);
            },
          ),
        if (privacy.isSupported)
          _SwitchTile(
            label: l10n.securityHideInSwitcher,
            subtitle: l10n.securityHideInSwitcherDesc,
            value: hideInSwitcher,
            onChanged: (value) =>
                ref.read(hideInSwitcherProvider.notifier).set(value),
          ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.enabled = true,
  });

  final String label;

  /// Пояснение под названием. Нужно там, где из одного названия не понять,
  /// что настройка делает и чем за неё платят.
  final String? subtitle;

  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: enabled ? () => onChanged(!value) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.text.title.copyWith(
                      color: enabled ? colors.textPrimary : colors.textTertiary,
                    ),
                  ),
                  if (subtitle case final subtitle?) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: context.text.caption.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            PixelSwitch(
              value: value,
              onChanged: enabled ? onChanged : (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
