import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/core/theme/app_motion.dart';
import 'package:texfi_money/presentation/shared/staggered_entrance.dart';

/// Ступенчатое появление списка.
///
/// Главное здесь — потолок задержки, и проверяется прежде всего он: без
/// потолка сотый элемент истории ждал бы четыре секунды, список выглядел
/// бы не оживлённым, а сломанным, и заметить это можно было бы только на
/// данных, которых в разработке обычно нет.
void main() {
  group('задержка', () {
    test('первый элемент не ждёт вовсе', () {
      expect(StaggeredEntrance.delayFor(0), Duration.zero);
    });

    test('соседи расходятся ровно на шаг', () {
      expect(StaggeredEntrance.delayFor(1), AppMotion.stagger);
      expect(StaggeredEntrance.delayFor(3), AppMotion.stagger * 3);
    });

    test('перестаёт расти на потолке', () {
      final ceiling = AppMotion.stagger * StaggeredEntrance.maxSteps;
      expect(StaggeredEntrance.delayFor(StaggeredEntrance.maxSteps), ceiling);
      expect(StaggeredEntrance.delayFor(100), ceiling);
      expect(StaggeredEntrance.delayFor(10000), ceiling);
    });

    test('весь список успевает появиться меньше чем за полсекунды', () {
      // Не эстетика, а граница: дольше — и появление списка превращается
      // в ожидание списка.
      final worst =
          StaggeredEntrance.delayFor(10000) + AppMotion.fast;
      expect(worst, lessThan(const Duration(milliseconds: 500)));
    });
  });

  testWidgets('элемент доезжает до полной видимости', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StaggeredEntrance(
          index: 100,
          child: const SizedBox(width: 10, height: 10, key: Key('item')),
        ),
      ),
    );

    // Ребёнок на месте с первого кадра — анимируется только его вид.
    expect(find.byKey(const Key('item')), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byKey(const Key('item')), findsOneWidget);
  });
}
