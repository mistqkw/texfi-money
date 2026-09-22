import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../shared/section_header.dart';
import '../shared/terminal_box.dart';

/// Экран «О приложении»: версия, исходники, лицензия и донат.
///
/// До релиза этого экрана не было вовсе — приложение не сообщало о себе
/// ничего: ни какая это версия, ни где лежит код, ни под какой лицензией.
/// Для проекта, который построен на «проверяется по исходникам», это была
/// самая заметная дыра: обещание есть, а дойти до кода неоткуда.
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  static const String repoUrl = 'https://github.com/mistqkw/texfi-money';
  static const String hubUrl = 'https://texfi-hub.vercel.app';
  static const String donateUrl = 'https://github.com/sponsors/mistqkw';
  static const String licenseUrl =
      'https://github.com/mistqkw/texfi-money/blob/main/LICENSE';

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo? _info;

  @override
  void initState() {
    super.initState();
    // Номер версии читается из самой сборки. Константа в коде рано или
    // поздно разъезжается с pubspec — и заметно это становится ровно в тот
    // релиз, где пользователь приходит сверить версию с багрепортом.
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _info = info);
    });
  }

  Future<void> _open(String url) async {
    final ok = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    // Честно сказать, что открыть нечем, лучше, чем молча ничего не сделать:
    // нажатие без последствий читается как сломанное приложение.
    if (!ok && mounted) {
      final l10n = context.l10n;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.aboutLinkFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final info = _info;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: ListView(
        padding: AppSpacing.screen,
        children: [
          SectionHeader(l10n.aboutSectionApp, index: 1),
          TerminalBox(
            label: 'texfi m0ney',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info == null ? '—' : 'v${info.version}',
                  style: context.text.balance.copyWith(fontSize: 22),
                ),
                AppSpacing.gapXs,
                Text(
                  info == null
                      ? ''
                      : '${l10n.aboutBuildLabel} ${info.buildNumber}',
                  style: context.text.mono,
                ),
                AppSpacing.gapMd,
                Text(l10n.aboutTagline, style: context.text.title),
                AppSpacing.gapSm,
                Text(l10n.aboutBlurb, style: context.text.body),
                AppSpacing.gapLg,
                _FactRow(
                  facts: [
                    (value: '100%', label: l10n.aboutFactOffline),
                    (value: '0', label: l10n.aboutFactTelemetry),
                    (value: 'AGPL-3.0', label: l10n.aboutFactLicense),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.gapXl,

          SectionHeader(l10n.aboutSectionOpen, index: 2),
          _LinkTile(
            icon: Icons.code,
            title: l10n.aboutSourceTitle,
            subtitle: 'github.com/mistqkw/texfi-money',
            onTap: () => _open(AboutScreen.repoUrl),
          ),
          AppSpacing.gapMd,
          _LinkTile(
            icon: Icons.balance,
            title: l10n.aboutLicenseTitle,
            subtitle: l10n.aboutLicenseText,
            onTap: () => _open(AboutScreen.licenseUrl),
          ),
          AppSpacing.gapMd,
          _LinkTile(
            icon: Icons.public,
            title: l10n.aboutEcosystemTitle,
            subtitle: 'texfi-hub.vercel.app',
            onTap: () => _open(AboutScreen.hubUrl),
          ),
          AppSpacing.gapXl,

          SectionHeader(l10n.aboutSectionSupport, index: 3),
          TerminalBox(
            label: l10n.aboutSectionSupport,
            borderColor: colors.accent,
            labelColor: colors.accent,
            onTap: () => _open(AboutScreen.donateUrl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, size: 18, color: colors.expense),
                    AppSpacing.gapHSm,
                    Text(l10n.aboutDonateTitle, style: context.text.title),
                  ],
                ),
                AppSpacing.gapSm,
                Text(l10n.aboutDonateText, style: context.text.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Строка фактов: число крупно, подпись пиксельным шрифтом рядом.
/// Тот же приём, что на первом экране сайта, — то, что иначе приходится
/// вылавливать из абзаца, читается за секунду.
class _FactRow extends StatelessWidget {
  const _FactRow({required this.facts});

  final List<({String value, String label})> facts;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      children: [
        for (final fact in facts)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 6, height: 6, color: colors.accent),
              AppSpacing.gapHSm,
              Text(
                fact.value,
                style: context.text.mono.copyWith(color: colors.textPrimary),
              ),
              AppSpacing.gapHSm,
              Text(fact.label, style: context.text.mono),
            ],
          ),
      ],
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TerminalBox(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.accent),
          AppSpacing.gapHMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.text.title),
                AppSpacing.gapXs,
                Text(subtitle, style: context.text.caption),
              ],
            ),
          ),
          Icon(Icons.north_east, size: 16, color: colors.textTertiary),
        ],
      ),
    );
  }
}
