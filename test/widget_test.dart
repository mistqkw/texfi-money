import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:texfi_money/data/local/database.dart';
import 'package:texfi_money/data/providers/data_providers.dart';
import 'package:texfi_money/main.dart';

void main() {
  testWidgets('App launches and shows title', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(
            AppDatabase.forTesting(NativeDatabase.memory()),
          ),
        ],
        child: const TexFiMoneyApp(),
      ),
    );

    expect(find.text('TexFi m0ney'), findsOneWidget);

    // Даём drift-стримам время закрыться до финальной проверки таймеров.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  });
}
