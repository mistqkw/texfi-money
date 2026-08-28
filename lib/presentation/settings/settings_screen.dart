import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_font.dart';
import '../../core/constants/app_theme_variant.dart';
import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_text_styles_ext.dart';
import 'currency_picker_screen.dart';
import 'currency_provider.dart';
import 'font_provider.dart';
import 'theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  String _themeLabel(AppThemeVariant variant) => switch (variant) {
        AppThemeVariant.dark => 'Тёмная',
        AppThemeVariant.light => 'Светлая',
        AppThemeVariant.oled => 'Чёрная (OLED)',
      };

  IconData _themeIcon(AppThemeVariant variant) => switch (variant) {
        AppThemeVariant.dark => Icons.dark_mode_outlined,
        AppThemeVariant.light => Icons.light_mode_outlined,
        AppThemeVariant.oled => Icons.contrast,
      };

  String _fontLabel(AppFont font) => switch (font) {
        AppFont.inter => 'Inter',
        AppFont.roboto => 'Roboto',
        AppFont.manrope => 'Manrope',
        AppFont.system => 'Системный',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeVariant = ref.watch(themeVariantProvider);
    final font = ref.watch(fontProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _SectionLabel('Тема'),
          const SizedBox(height: 8),
          ...AppThemeVariant.values.map((variant) => _OptionTile(
                icon: _themeIcon(variant),
                label: _themeLabel(variant),
                selected: variant == themeVariant,
                onTap: () => ref.read(themeVariantProvider.notifier).setVariant(variant),
              )),
          const SizedBox(height: 24),
          _SectionLabel('Шрифт'),
          const SizedBox(height: 8),
          ...AppFont.values.map((f) => _OptionTile(
                icon: Icons.text_fields,
                label: _fontLabel(f),
                selected: f == font,
                onTap: () => ref.read(fontProvider.notifier).setFont(f),
              )),
          const SizedBox(height: 24),
          _SectionLabel('Валюта'),
          const SizedBox(height: 8),
          _OptionTile(
            icon: Icons.payments_outlined,
            label: '${currency.displayName} (${currency.symbol})',
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
