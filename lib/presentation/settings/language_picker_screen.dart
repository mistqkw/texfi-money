import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/haptics.dart';
import 'locale_provider.dart';

class LanguagePickerScreen extends ConsumerWidget {
  const LanguagePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.languagePickerTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ListTile(
            title: Text(l10n.languageSystem, style: context.text.title),
            trailing: current == null ? Icon(Icons.check, color: context.colors.accent) : null,
            onTap: () {
              Haptics.select();
              ref.read(localeProvider.notifier).setLocale(null);
            },
          ),
          const Divider(height: 1),
          for (final locale in supportedLocales)
            ListTile(
              title: Text(nativeLanguageNames[locale.languageCode] ?? locale.languageCode, style: context.text.title),
              trailing: current == locale ? Icon(Icons.check, color: context.colors.accent) : null,
              onTap: () {
                Haptics.select();
                ref.read(localeProvider.notifier).setLocale(locale);
              },
            ),
        ],
      ),
    );
  }
}
