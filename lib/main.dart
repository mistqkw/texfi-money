import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_motion.dart';
import 'core/theme/app_theme.dart';
import 'presentation/settings/currency_provider.dart';
import 'presentation/settings/font_provider.dart';
import 'presentation/settings/theme_provider.dart';
import 'presentation/shared/root_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU');
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const TexFiMoneyApp(),
    ),
  );
}

class TexFiMoneyApp extends ConsumerWidget {
  const TexFiMoneyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variant = ref.watch(themeVariantProvider);
    final font = ref.watch(fontProvider);

    return MaterialApp(
      title: 'TexFi m0ney',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(variant: variant, font: font),
      themeAnimationDuration: AppMotion.normal,
      home: const RootShell(),
    );
  }
}
