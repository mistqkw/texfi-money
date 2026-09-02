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
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/haptics.dart';
import '../../data/local/backup_service.dart';
import '../../data/providers/data_providers.dart';
import '../../l10n/app_localizations.dart';
import '../accounts/accounts_screen.dart';
import '../profiles/debt_profiles_screen.dart';
import '../shared/l10n_helpers.dart';
import '../shared/pixel_icon.dart';
import '../shared/pixel_switch.dart';
import '../shared/restart_widget.dart';
import 'currency_picker_screen.dart';
import 'currency_provider.dart';
import 'font_provider.dart';
import 'haptics_provider.dart';
import 'language_picker_screen.dart';
import 'locale_provider.dart';
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
        AppFont.roboto => 'Roboto',
        AppFont.manrope => 'Manrope',
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
          _SectionLabel(l10n.settingsLanguageSection),
          AppSpacing.gapSm,
          _OptionTile(
            icon: PixelIcons.language,
            label: languageLabel,
            selected: false,
            showCheckmark: false,
            onTap: () => Navigator.of(context).push(
              fadeSlideRoute(const LanguagePickerScreen()),
            ),
          ),
          AppSpacing.gapXl,
          _SectionLabel(l10n.settingsThemeSection),
          AppSpacing.gapSm,
          ...AppThemeVariant.values.map((variant) => _OptionTile(
                icon: _themeIcon(variant),
                label: _themeLabel(context, variant),
                selected: variant == themeVariant,
                onTap: () => ref.read(themeVariantProvider.notifier).setVariant(variant),
              )),
          AppSpacing.gapXl,
          _SectionLabel(l10n.settingsFontSection),
          AppSpacing.gapSm,
          ...AppFont.values.map((f) => _OptionTile(
                icon: PixelIcons.font,
                label: _fontLabel(f, l10n),
                selected: f == font,
                onTap: () => ref.read(fontProvider.notifier).setFont(f),
              )),
          AppSpacing.gapXl,
          _SectionLabel(l10n.settingsHapticsSection),
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
          _SectionLabel(l10n.settingsCurrencySection),
          AppSpacing.gapSm,
          _OptionTile(
            icon: PixelIcons.money,
            label: '${currencyDisplayName(context, currency)} (${currency.symbol})',
            selected: false,
            showCheckmark: false,
            onTap: () => Navigator.of(context).push(
              fadeSlideRoute(const CurrencyPickerScreen()),
            ),
          ),
          AppSpacing.gapXl,
          _SectionLabel(l10n.settingsManageSection),
          AppSpacing.gapSm,
          _OptionTile(
            icon: PixelIcons.wallet,
            label: l10n.accountsTitle,
            selected: false,
            showCheckmark: false,
            onTap: () => Navigator.of(context).push(
              fadeSlideRoute(const AccountsScreen()),
            ),
          ),
          _OptionTile(
            icon: PixelIcons.profiles,
            label: l10n.profilesTitle,
            selected: false,
            showCheckmark: false,
            onTap: () => Navigator.of(context).push(
              fadeSlideRoute(const DebtProfilesScreen()),
            ),
          ),
          AppSpacing.gapXl,
          _SectionLabel(l10n.settingsBackupSection),
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
          _SectionLabel(l10n.settingsDangerSection),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: context.text.headline);
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

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(child: Text(label, style: context.text.title)),
            PixelSwitch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
