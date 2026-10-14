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
import '../shared/hair_card.dart';
import '../shared/hair_icon.dart';
import '../shared/hair_list.dart';
import '../shared/staggered_entrance.dart';
import '../shared/hair_switch.dart';
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

  IconData _themeIcon(AppThemeVariant variant) => switch (variant) {
    AppThemeVariant.dark => HairIcons.themeDark,
    AppThemeVariant.light => HairIcons.themeLight,
    AppThemeVariant.oled => HairIcons.themeContrast,
  };

  String _fontLabel(AppFont font, AppLocalizations l10n) => switch (font) {
    AppFont.inter => 'Inter',
    AppFont.system => l10n.fontSystem,
  };

  Future<void> _exportBackup(BuildContext context, WidgetRef ref) async {
    final json = await ref.read(backupServiceProvider).exportToJson();
    final dir = await getTemporaryDirectory();
    final stamp = DateTime.now().toIso8601String().replaceAll(
      RegExp(r'[:.]'),
      '-',
    );
    final file = File('${dir.path}/texfi-money-backup-$stamp.json');
    await file.writeAsString(json);

    await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
  }

  Future<void> _showResultDialog(
    BuildContext context, {
    required String title,
  }) {
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

    Widget section(String title, Widget body) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HairSectionHeader(title: title),
        body,
      ],
    );

    final sections = <Widget>[
      section(
        l10n.settingsLanguageSection,
        HairGroup(
          children: [
            _OptionTile(
              icon: HairIcons.language,
              label: languageLabel,
              showCheckmark: false,
              onTap: () => Navigator.of(
                context,
              ).push(hairRoute(const LanguagePickerScreen())),
            ),
          ],
        ),
      ),
      section(
        l10n.settingsThemeSection,
        HairGroup(
          children: [
            for (final variant in AppThemeVariant.values)
              _OptionTile(
                icon: _themeIcon(variant),
                label: _themeLabel(context, variant),
                selected: variant == themeVariant,
                onTap: () =>
                    ref.read(themeVariantProvider.notifier).setVariant(variant),
              ),
          ],
        ),
      ),
      section(
        l10n.settingsFontSection,
        // Название каждой гарнитуры набрано ею же.
        HairGroup(
          children: [
            for (final f in AppFont.values)
              _FontTile(
                font: f,
                label: _fontLabel(f, l10n),
                selected: f == font,
                onTap: () => ref.read(fontProvider.notifier).setFont(f),
              ),
          ],
        ),
      ),
      section(
        l10n.settingsHapticsSection,
        HairGroup(
          children: [
            _SwitchTile(
              label: l10n.hapticsEnabled,
              value: hapticsEnabled,
              onChanged: (value) {
                ref.read(hapticsEnabledProvider.notifier).setEnabled(value);
                if (value) Haptics.select();
              },
            ),
          ],
        ),
      ),
      section(
        l10n.settingsCurrencySection,
        HairGroup(
          children: [
            _OptionTile(
              icon: HairIcons.money,
              label:
                  '${currencyDisplayName(context, currency)} (${currency.symbol})',
              showCheckmark: false,
              onTap: () => Navigator.of(
                context,
              ).push(hairRoute(const CurrencyPickerScreen())),
            ),
          ],
        ),
      ),
      section(
        l10n.settingsManageSection,
        HairGroup(
          children: [
            _OptionTile(
              icon: HairIcons.wallet,
              label: l10n.accountsTitle,
              showCheckmark: false,
              onTap: () =>
                  Navigator.of(context).push(hairRoute(const AccountsScreen())),
            ),
            _OptionTile(
              icon: HairIcons.profiles,
              label: l10n.profilesTitle,
              showCheckmark: false,
              onTap: () => Navigator.of(
                context,
              ).push(hairRoute(const DebtProfilesScreen())),
            ),
          ],
        ),
      ),
      section(
        l10n.riskSection,
        HairGroup(
          children: [
            _OptionTile(
              icon: HairIcons.risk,
              label: l10n.riskSection,
              showCheckmark: false,
              onTap: () => Navigator.of(
                context,
              ).push(hairRoute(const RiskSettingsScreen())),
            ),
            const _AnalysisRangeTile(),
          ],
        ),
      ),
      section(l10n.settingsSecuritySection, const _SecuritySection()),
      section(
        l10n.settingsBackupSection,
        HairGroup(
          children: [
            _OptionTile(
              icon: HairIcons.backupUp,
              label: l10n.backupExport,
              showCheckmark: false,
              onTap: () => _exportBackup(context, ref),
            ),
            _OptionTile(
              icon: HairIcons.backupDown,
              label: l10n.backupImport,
              showCheckmark: false,
              onTap: () => _importBackup(context, ref),
            ),
          ],
        ),
      ),
      // «О приложении» стоит перед опасной зоной: сброс данных остаётся
      // последним пунктом экрана.
      section(
        l10n.aboutTitle,
        HairGroup(
          children: [
            _OptionTile(
              icon: HairIcons.info,
              label: l10n.aboutTitle,
              showCheckmark: false,
              onTap: () =>
                  Navigator.of(context).push(hairRoute(const AboutScreen())),
            ),
          ],
        ),
      ),
      section(
        l10n.settingsDangerSection,
        HairGroup(
          children: [
            _OptionTile(
              icon: HairIcons.danger,
              label: l10n.resetApp,
              showCheckmark: false,
              color: context.colors.expense,
              onTap: () => _resetApp(context, ref),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: AppSpacing.screen,
        children: [
          for (var i = 0; i < sections.length; i++) ...[
            StaggeredEntrance(index: i, child: sections[i]),
            AppSpacing.gapXl,
          ],
        ],
      ),
    );
  }
}

/// Строка выбора гарнитуры: название набрано самой гарнитурой.
class _FontTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final preview = buildAppTextTheme(
      font: font,
      colors: context.colors,
    ).titleMedium!;
    return HairRow(
      label: label,
      labelStyle: preview,
      selected: selected,
      onTap: onTap,
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.showCheckmark = true,
    this.color,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool showCheckmark;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return HairRow(
      icon: icon,
      label: label,
      color: color,
      selected: showCheckmark && selected,
      chevron: !showCheckmark,
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
      icon: HairIcons.cashFlow,
      label: l10n.analysisRangeTitle,
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
                style: context.text.caption.copyWith(
                  color: context.colors.textTertiary,
                ),
              ),
            ),
            for (final years in const [1, 2, 3, 5, 10])
              ListTile(
                title: Text(l10n.analysisRangeYears(years)),
                trailing: current.years == years
                    ? HairIcon(
                        HairIcons.check,
                        size: 16,
                        color: context.colors.accent,
                      )
                    : null,
                onTap: () => Navigator.of(context).pop(years),
              ),
            ListTile(
              title: Text(l10n.analysisRangeCustom),
              trailing: current.isExplicit
                  ? HairIcon(
                      HairIcons.check,
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

    return HairGroup(
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
                  !await lock.authenticate(reason: l10n.securityUnlockReason)) {
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

  /// Пояснение под названием: нужно там, где из одного названия не понять,
  /// что настройка делает и чем за неё платят.
  final String? subtitle;

  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return HairRow(
      label: label,
      subtitle: subtitle,
      enabled: enabled,
      onTap: () => onChanged(!value),
      trailing: HairSwitch(
        value: value,
        onChanged: enabled ? onChanged : (_) {},
      ),
    );
  }
}
