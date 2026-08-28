import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
import 'package:texfi_money/presentation/home/home_screen.dart';
import 'package:texfi_money/presentation/settings/currency_provider.dart';
import 'package:texfi_money/presentation/shared/transaction_tile.dart';

/// pumpAndSettle() зависает на несколько минут, пока показан SnackBar
/// (у него собственный таймер на несколько секунд) — шагаем вручную
/// ограниченным числом кадров вместо ожидания полного затихания.
Future<void> _pumpSteps(WidgetTester tester, {int steps = 10, int stepMs = 100}) async {
  for (var i = 0; i < steps; i++) {
    await tester.pump(Duration(milliseconds: stepMs));
  }
}

void main() {
  testWidgets('свайп влево на последней транзакции удаляет её и предлагает отменить', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final txRepo = TransactionRepositoryImpl(db, CategoryRepositoryImpl(db));

    await txRepo.add(
      amount: 350,
      type: TransactionType.expense,
      categoryId: 'cat_groceries',
      date: DateTime.now(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: MaterialApp(
          theme: AppTheme.build(variant: AppThemeVariant.dark, font: AppFont.system),
          locale: const Locale('ru'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const HomeScreen(),
        ),
      ),
    );
    await _pumpSteps(tester);

    // До показа SnackBar в дереве ровно один Dismissible — это наша
    // транзакция (сам SnackBar тоже оборачивается в Dismissible для
    // свайпа-закрытия, поэтому после его появления find.byType(Dismissible)
    // больше не уникален — ниже используем find.byType(TransactionTile)).
    expect(find.byType(Dismissible), findsOneWidget);
    expect(find.byType(TransactionTile), findsOneWidget);

    await tester.fling(find.byType(Dismissible), const Offset(-500, 0), 1000);
    await _pumpSteps(tester);

    // Транзакция исчезла из списка, показан тост с отменой.
    // Проверяем только UI: прямой await стрима drift внутри FakeAsync-зоны
    // testWidgets зависает (доставка обновлений стрима зависит от таймера,
    // который не тикает без tester.pump()), поэтому состояние БД здесь не
    // опрашивается напрямую — реактивность провайдера уже доказана тем,
    // что список в UI обновился.
    expect(find.byType(TransactionTile), findsNothing);
    expect(find.text('Удалено'), findsOneWidget);
    expect(find.text('Отменить'), findsOneWidget);

    await tester.tap(find.text('Отменить'));
    await _pumpSteps(tester);

    expect(find.byType(TransactionTile), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await _pumpSteps(tester, steps: 3);
  });
}
