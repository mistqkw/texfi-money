@Tags(['golden'])
library;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:texfi_money/core/constants/app_font.dart';
import 'package:texfi_money/core/constants/app_theme_variant.dart';
import 'package:texfi_money/core/theme/app_theme.dart';
import 'package:texfi_money/data/local/database.dart';
import 'package:texfi_money/data/providers/data_providers.dart';
import 'package:texfi_money/data/repositories/category_repository_impl.dart';
import 'package:texfi_money/data/repositories/transaction_repository_impl.dart';
import 'package:texfi_money/domain/entities/transaction_type.dart';
import 'package:texfi_money/l10n/app_localizations.dart';
import 'package:texfi_money/presentation/history/history_screen.dart';
import 'package:texfi_money/presentation/home/home_screen.dart';
import 'package:texfi_money/presentation/settings/currency_provider.dart';
import 'package:texfi_money/presentation/settings/settings_screen.dart';
import 'package:texfi_money/presentation/shared/grouped_tab.dart';
import 'package:texfi_money/presentation/shared/root_shell.dart';

Future<void> _pumpSteps(WidgetTester tester, {int steps = 12, int stepMs = 120}) async {
  for (var i = 0; i < steps; i++) {
    await tester.pump(Duration(milliseconds: stepMs));
  }
}

Future<AppDatabase> _seed() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  final repo = TransactionRepositoryImpl(db, CategoryRepositoryImpl(db));
  final now = DateTime.now();
  await repo.add(amount: 42000, type: TransactionType.income, categoryId: 'cat_salary', date: now.subtract(const Duration(days: 2)));
  await repo.add(amount: 1250, type: TransactionType.expense, categoryId: 'cat_groceries', date: now.subtract(const Duration(days: 1)));
  await repo.add(amount: 380, type: TransactionType.expense, categoryId: 'cat_transport', date: now);
  await repo.add(amount: 2600, type: TransactionType.expense, categoryId: 'cat_cafe', date: now);
  return db;
}

Future<void> _shoot(WidgetTester tester, String name, Widget screen, {AppThemeVariant variant = AppThemeVariant.dark}) async {
  SharedPreferences.setMockInitialValues({'has_seen_onboarding': true});
  final prefs = await SharedPreferences.getInstance();
  final db = await _seed();
  tester.view.physicalSize = const Size(1080, 2280);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: MaterialApp(
        theme: AppTheme.build(variant: variant, font: AppFont.inter),
        locale: const Locale('ru'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: screen,
      ),
    ),
  );
  await _pumpSteps(tester);
  await expectLater(find.byType(MaterialApp), matchesGoldenFile('shots/$name.png'));
  await tester.pumpWidget(const SizedBox.shrink());
  await _pumpSteps(tester, steps: 3);
}

/// Тестовое окружение не поднимает шрифты из pubspec — без этого весь текст
/// на снимках был бы тофу-квадратами, и типографику нельзя было бы оценить.
Future<void> _loadFont(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final path in paths) {
    loader.addFont(
      File(path).readAsBytes().then((b) => ByteData.view(b.buffer)),
    );
  }
  await loader.load();
}

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await _loadFont('PressStart2P', ['assets/fonts/PressStart2P-Regular.ttf']);
    await _loadFont('Inter', [
      'assets/fonts/Inter-Regular.ttf',
      'assets/fonts/Inter-Medium.ttf',
      'assets/fonts/Inter-SemiBold.ttf',
    ]);
  });
  testWidgets('home', (t) => _shoot(t, 'home', const HomeScreen()));
  testWidgets('home_light', (t) => _shoot(t, 'home_light', const HomeScreen(), variant: AppThemeVariant.light));
  testWidgets('history', (t) => _shoot(t, 'history', const HistoryScreen()));
  testWidgets('plan', (t) => _shoot(t, 'plan', const PlanTab()));
  testWidgets('summary', (t) => _shoot(t, 'summary', const SummaryTab()));
  testWidgets('settings', (t) => _shoot(t, 'settings', const SettingsScreen()));
  testWidgets('shell', (t) => _shoot(t, 'shell', const RootShell()));
}
