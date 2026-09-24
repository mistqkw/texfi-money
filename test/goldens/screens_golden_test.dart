@Tags(['golden'])
library;

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:texfi_money/core/constants/app_font.dart';
import 'package:texfi_money/core/constants/app_theme_variant.dart';
import 'package:texfi_money/core/theme/app_theme.dart';
import 'package:texfi_money/data/local/database.dart';
import 'package:texfi_money/data/providers/data_providers.dart';
import 'package:texfi_money/data/repositories/budget_repository_impl.dart';
import 'package:texfi_money/data/repositories/category_repository_impl.dart';
import 'package:texfi_money/data/repositories/savings_goal_repository_impl.dart';
import 'package:texfi_money/data/repositories/transaction_repository_impl.dart';
import 'package:texfi_money/domain/entities/transaction_type.dart';
import 'package:texfi_money/l10n/app_localizations.dart';
import 'package:texfi_money/presentation/accounts/accounts_screen.dart';
import 'package:texfi_money/presentation/add_transaction/add_transaction_screen.dart';
import 'package:texfi_money/presentation/categories/categories_screen.dart';
import 'package:texfi_money/presentation/goals/goals_screen.dart';
import 'package:texfi_money/presentation/history/history_screen.dart';
import 'package:texfi_money/presentation/home/home_screen.dart';
import 'package:texfi_money/presentation/onboarding/onboarding_screen.dart';
import 'package:texfi_money/presentation/settings/about_screen.dart';
import 'package:texfi_money/presentation/settings/currency_provider.dart';
import 'package:texfi_money/presentation/settings/developer_screen.dart';
import 'package:texfi_money/presentation/settings/settings_screen.dart';
import 'package:texfi_money/presentation/shared/beta_glyph.dart';
import 'package:texfi_money/presentation/shared/grouped_tab.dart';
import 'package:texfi_money/presentation/shared/root_shell.dart';
import 'package:texfi_money/presentation/wealth/cash_flow_screen.dart';
import 'package:texfi_money/presentation/wealth/reports_screen.dart';
import 'package:texfi_money/presentation/wealth/subscriptions_screen.dart';
import 'package:texfi_money/presentation/wealth/wealth_screen.dart';

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

  final budgets = BudgetRepositoryImpl(db, CategoryRepositoryImpl(db));
  await budgets.setLimit(categoryId: 'cat_groceries', monthlyLimit: 8000);
  await budgets.setLimit(categoryId: 'cat_cafe', monthlyLimit: 3000);
  await budgets.setLimit(categoryId: 'cat_transport', monthlyLimit: 2000);

  final goals = SavingsGoalRepositoryImpl(db);
  final goalId = await goals.create(
    title: 'Новый ноутбук',
    targetAmount: 120000,
    color: const Color(0xFF4A7DFB),
    deadline: DateTime(now.year, now.month + 4),
  );
  await goals.addContribution(id: goalId, amount: 43500);

  return db;
}

Future<void> _shoot(WidgetTester tester, String name, Widget screen, {AppThemeVariant variant = AppThemeVariant.dark, bool beta = false}) async {
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
        theme: AppTheme.build(variant: variant, font: AppFont.inter, beta: beta),
        // В бета-стиле экраны прозрачные, фон лежит под навигатором —
        // как в main.dart.
        builder: beta ? (context, child) => BetaBackground(child: child!) : null,
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
    // Экран «О приложении» спрашивает версию у платформы — в тестовой
    // среде плагина нет, и без заглушки снимок падает на MissingPlugin.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/package_info'),
      (call) async => <String, dynamic>{
        'appName': 'TexFi m0ney',
        'packageName': 'com.texfi.money',
        'version': '1.1.0',
        'buildNumber': '15',
      },
    );
    await _loadFont('PressStart2P', ['assets/fonts/PressStart2P-Regular.ttf']);
    await _loadFont('Inter', [
      'assets/fonts/Inter-Regular.ttf',
      'assets/fonts/Inter-Medium.ttf',
      'assets/fonts/Inter-SemiBold.ttf',
    ]);
    await _loadFont('SourceSerif4', [
      'assets/fonts/SourceSerif4-Regular.ttf',
      'assets/fonts/SourceSerif4-Semibold.ttf',
    ]);
  });
  testWidgets('home', (t) => _shoot(t, 'home', const HomeScreen()));
  testWidgets('home_light', (t) => _shoot(t, 'home_light', const HomeScreen(), variant: AppThemeVariant.light));
  testWidgets('history', (t) => _shoot(t, 'history', const HistoryScreen()));
  testWidgets('plan', (t) => _shoot(t, 'plan', const PlanTab()));
  testWidgets('summary', (t) => _shoot(t, 'summary', const SummaryTab()));
  testWidgets('settings', (t) => _shoot(t, 'settings', const SettingsScreen()));
  testWidgets('shell', (t) => _shoot(t, 'shell', const RootShell()));
  testWidgets('add_tx', (t) => _shoot(t, 'add_tx', const AddTransactionScreen()));
  testWidgets('onboarding', (t) => _shoot(t, 'onboarding', const OnboardingScreen()));
  testWidgets('about', (t) => _shoot(t, 'about', const AboutScreen()));
  testWidgets('wealth', (t) => _shoot(t, 'wealth', const WealthScreen()));
  testWidgets('goals', (t) => _shoot(t, 'goals', const GoalsScreen()));
  testWidgets('accounts', (t) => _shoot(t, 'accounts', const AccountsScreen()));
  testWidgets('categories', (t) => _shoot(t, 'categories', const CategoriesScreen()));
  testWidgets('cash_flow', (t) => _shoot(t, 'cash_flow', const CashFlowScreen()));
  testWidgets('reports', (t) => _shoot(t, 'reports', const ReportsScreen()));
  testWidgets('subscriptions', (t) => _shoot(t, 'subscriptions', const SubscriptionsScreen()));
  testWidgets('developer', (t) => _shoot(t, 'developer', const DeveloperScreen()));
  // Бета-стиль из меню разработчика.
  testWidgets('shell_beta', (t) => _shoot(t, 'shell_beta', const RootShell(), beta: true));
  testWidgets('history_beta', (t) => _shoot(t, 'history_beta', const HistoryScreen(), beta: true));
  testWidgets('settings_beta', (t) => _shoot(t, 'settings_beta', const SettingsScreen(), beta: true));
  testWidgets('shell_beta_light', (t) => _shoot(t, 'shell_beta_light', const RootShell(), beta: true, variant: AppThemeVariant.light));
  testWidgets('summary_beta_light', (t) => _shoot(t, 'summary_beta_light', const SummaryTab(), beta: true, variant: AppThemeVariant.light));
  testWidgets('plan_beta', (t) => _shoot(t, 'plan_beta', const PlanTab(), beta: true));
  testWidgets('summary_beta', (t) => _shoot(t, 'summary_beta', const SummaryTab(), beta: true));
  testWidgets('wealth_beta', (t) => _shoot(t, 'wealth_beta', const WealthScreen(), beta: true));
  testWidgets('cash_flow_beta', (t) => _shoot(t, 'cash_flow_beta', const CashFlowScreen(), beta: true));
  testWidgets('add_tx_beta', (t) => _shoot(t, 'add_tx_beta', const AddTransactionScreen(), beta: true));
  testWidgets('developer_beta', (t) => _shoot(t, 'developer_beta', const DeveloperScreen(), beta: true));
}
