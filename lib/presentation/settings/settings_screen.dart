import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_font.dart';
import '../../core/constants/app_theme_variant.dart';
import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../l10n/app_localizations.dart';
import '../shared/l10n_helpers.dart';
import 'currency_picker_screen.dart';
import 'currency_provider.dart';
import 'font_provider.dart';
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

  IconData _themeIcon(AppThemeVariant variant) => switch (variant) {
        AppThemeVariant.dark => Icons.dark_mode_outlined,
        AppThemeVariant.light => Icons.light_mode_outlined,
        AppThemeVariant.oled => Icons.contrast,
      };

  String _fontLabel(AppFont font, AppLocalizations l10n) => switch (font) {
        AppFont.inter => 'Inter',
        AppFont.roboto => 'Roboto',
        AppFont.manrope => 'Manrope',
        AppFont.system => l10n.fontSystem,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeVariant = ref.watch(themeVariantProvider);
    final font = ref.watch(fontProvider);
    final currency = ref.watch(currencyProvider);
    final locale = ref.watch(localeProvider);
    final l10n = context.l10n;

    final languageLabel = locale == null
        ? l10n.languageSystem
        : (nativeLanguageNames[locale.languageCode] ?? locale.languageCode);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _SectionLabel(l10n.settingsLanguageSection),
          const SizedBox(height: 8),
          _OptionTile(
            icon: Icons.language_outlined,
            label: languageLabel,
            selected: false,
            showCheckmark: false,
            onTap: () => Navigator.of(context).push(
              fadeSlideRoute(const LanguagePickerScreen()),
            ),
          ),
          const SizedBox(height: 24),
          _SectionLabel(l10n.settingsThemeSection),
          const SizedBox(height: 8),
          ...AppThemeVariant.values.map((variant) => _OptionTile(
                icon: _themeIcon(variant),
                label: _themeLabel(context, variant),
                selected: variant == themeVariant,
                onTap: () => ref.read(themeVariantProvider.notifier).setVariant(variant),
              )),
          const SizedBox(height: 24),
          _SectionLabel(l10n.settingsFontSection),
          const SizedBox(height: 8),
          ...AppFont.values.map((f) => _OptionTile(
                icon: Icons.text_fields,
                label: _fontLabel(f, l10n),
                selected: f == font,
                onTap: () => ref.read(fontProvider.notifier).setFont(f),
              )),
          const SizedBox(height: 24),
          _SectionLabel(l10n.settingsCurrencySection),
          const SizedBox(height: 8),
          _OptionTile(
            icon: Icons.payments_outlined,
            label: '${currencyDisplayName(context, currency)} (${currency.symbol})',
            selected: false,
            showCheckmark: false,
            onTap: () => Navigator.of(context).push(
              fadeSlideRoute(const CurrencyPickerScreen()),
            ),
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
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool showCheckmark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: context.colors.textSecondary),
      title: Text(label, style: context.text.title),
      trailing: showCheckmark
          ? (selected ? Icon(Icons.check, color: context.colors.accent) : null)
          : Icon(Icons.chevron_right, color: context.colors.textTertiary),
      onTap: onTap,
    );
  }
}
