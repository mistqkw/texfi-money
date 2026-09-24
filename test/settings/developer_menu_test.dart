import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:texfi_money/core/constants/app_font.dart';
import 'package:texfi_money/core/constants/app_theme_variant.dart';
import 'package:texfi_money/core/theme/app_style_ext.dart';
import 'package:texfi_money/core/theme/app_theme.dart';
import 'package:texfi_money/core/theme/app_typography.dart';
import 'package:texfi_money/l10n/app_localizations.dart';
import 'package:texfi_money/presentation/settings/about_screen.dart';
import 'package:texfi_money/presentation/settings/currency_provider.dart';
import 'package:texfi_money/presentation/settings/developer_provider.dart';
import 'package:texfi_money/presentation/settings/developer_screen.dart';

/// Приложение с темой, которая, как в main.dart, следит за бета-стилем.
class _App extends ConsumerWidget {
  const _App({required this.home});

  final Widget home;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: AppTheme.build(
        variant: AppThemeVariant.dark,
        font: AppFont.system,
        beta: ref.watch(betaStyleProvider),
      ),
      locale: const Locale('ru'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: home,
    );
  }
}

Future<SharedPreferences> _pump(
  WidgetTester tester,
  Widget home, {
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  final instance = await SharedPreferences.getInstance();
  tester.view.physicalSize = const Size(1080, 2280);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(instance)],
      child: _App(home: home),
    ),
  );
  await tester.pumpAndSettle();
  return instance;
}

void main() {
  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/package_info'),
      (call) async => <String, dynamic>{
        'appName': 'TexFi m0ney',
        'packageName': 'com.texfi.money',
        'version': '1.1.1',
        'buildNumber': '16',
      },
    );
  });

  testWidgets('пять нажатий на версию открывают меню разработчика',
      (tester) async {
    final prefs = await _pump(tester, const AboutScreen());
    final version = find.text('v1.1.1');
    expect(version, findsOneWidget);

    for (var i = 0; i < 4; i++) {
      await tester.tap(version);
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.byType(DeveloperScreen), findsNothing);
    expect(prefs.getBool('dev_menu_unlocked'), isNot(true));

    await tester.tap(version);
    await tester.pumpAndSettle();

    expect(find.byType(DeveloperScreen), findsOneWidget);
    expect(prefs.getBool('dev_menu_unlocked'), isTrue);
  });

  testWidgets('медленные нажатия серию не набирают', (tester) async {
    await _pump(tester, const AboutScreen());
    final version = find.text('v1.1.1');
    for (var i = 0; i < 5; i++) {
      await tester.tap(version);
      await tester.pump(const Duration(seconds: 2));
    }
    await tester.pumpAndSettle();
    expect(find.byType(DeveloperScreen), findsNothing);
  });

  testWidgets('открытое меню видно пунктом в «О приложении»', (tester) async {
    await _pump(
      tester,
      const AboutScreen(),
      prefs: {'dev_menu_unlocked': true},
    );
    final tile = find.text('Меню разработчика');
    await tester.scrollUntilVisible(tile, 300);
    expect(tile, findsOneWidget);
  });

  testWidgets('бета-стиль включается после подтверждения и анимации',
      (tester) async {
    final prefs = await _pump(tester, const DeveloperScreen());

    final tile = find.text('Бета-стиль');
    await tester.scrollUntilVisible(tile, 300);
    await tester.pumpAndSettle();
    await tester.tap(tile);
    await tester.pumpAndSettle();

    expect(find.text('Включить бета-стиль?'), findsOneWidget);
    await tester.tap(find.text('Включить'));
    // Середина анимации: занавес уже закрыл экран, тема сменилась.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    expect(prefs.getBool('dev_beta_style'), isTrue);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    final context = tester.element(find.byType(DeveloperScreen));
    expect(context.style.beta, isTrue);
    expect(
      Theme.of(context).textTheme.headlineMedium!.fontFamily,
      kSerifFamily,
    );
  });

  testWidgets('отмена в диалоге стиль не трогает', (tester) async {
    final prefs = await _pump(tester, const DeveloperScreen());
    final tile = find.text('Бета-стиль');
    await tester.scrollUntilVisible(tile, 300);
    await tester.pumpAndSettle();
    await tester.tap(tile);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    expect(prefs.getBool('dev_beta_style'), isNot(true));
  });

  testWidgets('меню собирается в бета-стиле без переполнений', (tester) async {
    await _pump(
      tester,
      const DeveloperScreen(),
      prefs: {'dev_beta_style': true, 'dev_menu_unlocked': true},
    );
    expect(tester.takeException(), isNull);
  });

  test('бета-тема: антиква в заголовках, своя палитра и геометрия', () {
    final theme = AppTheme.build(
      variant: AppThemeVariant.light,
      font: AppFont.inter,
      beta: true,
    );
    expect(theme.textTheme.displayLarge!.fontFamily, kSerifFamily);
    expect(theme.textTheme.displayLarge!.fontWeight, FontWeight.w600);
    expect(theme.extension<AppStyleExt>()!.beta, isTrue);
    // Бета перекрывает выбранную тему: даже поверх тёмной она — бумага.
    expect(theme.brightness, Brightness.light);
    final overDark = AppTheme.build(
      variant: AppThemeVariant.dark,
      font: AppFont.inter,
      beta: true,
    );
    expect(overDark.brightness, Brightness.light);

    final pixel = AppTheme.build(variant: AppThemeVariant.dark, font: AppFont.inter);
    expect(pixel.textTheme.displayLarge!.fontFamily, kPixelFamily);
    expect(pixel.extension<AppStyleExt>()!.beta, isFalse);
  });
}
