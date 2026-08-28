import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:texfi_money/main.dart';

void main() {
  testWidgets('App launches and shows title', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: TexFiMoneyApp()));

    expect(find.text('TexFi m0ney'), findsOneWidget);
  });
}
