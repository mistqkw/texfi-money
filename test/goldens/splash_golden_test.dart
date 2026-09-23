@Tags(['golden'])
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:texfi_money/presentation/shared/launch_splash.dart';

/// Кадры заставки. Единственный способ увидеть анимацию на этой машине:
/// Android SDK локально нет, десктопной цели у проекта тоже.
///
/// Повод для проверки конкретный: прошлая версия сборки везла три
/// настоящих дефекта — ячейки гасли не до конца и складывались в тёмный
/// квадрат за знаком, последние не успевали догореть и висели огрызками
/// на финальном кадре, а сама волна проскакивала быстрее, чем её можно
/// было прочитать. Ни один из них не виден в коде.
Future<void> _loadFont(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final path in paths) {
    loader.addFont(File(path).readAsBytes().then((b) => ByteData.view(b.buffer)));
  }
  await loader.load();
}

void main() {
  setUpAll(() async {
    await _loadFont('PressStart2P', ['assets/fonts/PressStart2P-Regular.ttf']);
    await _loadFont('Inter', ['assets/fonts/Inter-Regular.ttf']);
  });

  testWidgets('кадры сборки знака', (tester) async {
    tester.view.physicalSize = const Size(1080, 1200);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(home: LaunchSplash(onFinished: () {})),
    );

    // Шаг 130мс при длительности 1300мс — десять кадров на всю заставку.
    for (var frame = 1; frame <= 10; frame++) {
      await tester.pump(const Duration(milliseconds: 120));
      await expectLater(
        find.byType(LaunchSplash),
        matchesGoldenFile('splash/frame_$frame.png'),
      );
    }
  });
}
