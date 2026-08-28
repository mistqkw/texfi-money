import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:texfi_money/data/local/database.dart';
import 'package:texfi_money/data/providers/data_providers.dart';
import 'package:texfi_money/main.dart';
import 'package:texfi_money/presentation/settings/currency_provider.dart';

Future<void> _pumpPastSplash(WidgetTester tester) async {
  // Не pumpAndSettle: курсор сплэша мигает бесконечно и завис бы.
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

void main() {
  testWidgets('первый запуск (без флага) показывает онбординг, а не сразу главный экран', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(AppDatabase.forTesting(NativeDatabase.memory())),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const TexFiMoneyApp(),
      ),
    );

    await _pumpPastSplash(tester);

    expect(find.text('TexFi m0ney'), findsNothing);
    expect(find.byType(PageView), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  });

  testWidgets('пройденный онбординг ведёт сразу на главный экран', (tester) async {
    SharedPreferences.setMockInitialValues({'has_seen_onboarding': true});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(AppDatabase.forTesting(NativeDatabase.memory())),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const TexFiMoneyApp(),
      ),
    );

    await _pumpPastSplash(tester);

    expect(find.text('TexFi m0ney'), findsOneWidget);
    expect(find.byType(PageView), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  });
}
