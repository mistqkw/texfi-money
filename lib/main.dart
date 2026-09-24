import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_motion.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/page_sheet.dart';
import 'l10n/app_localizations.dart';
import 'presentation/settings/currency_provider.dart';
import 'presentation/settings/developer_provider.dart';
import 'presentation/settings/font_provider.dart';
import 'presentation/settings/haptics_provider.dart';
import 'presentation/settings/locale_provider.dart';
import 'presentation/settings/theme_provider.dart';
import 'presentation/shared/app_entry.dart';
import 'presentation/shared/dev_overlays.dart';
import 'presentation/shared/restart_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    RestartWidget(
      child: ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const TexFiMoneyApp(),
      ),
    ),
  );
}

class TexFiMoneyApp extends ConsumerWidget {
  const TexFiMoneyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final variant = ref.watch(themeVariantProvider);
    final font = ref.watch(fontProvider);
    final locale = ref.watch(localeProvider);
    // Синхронизирует Haptics.enabled с настройкой при самом первом кадре —
    // не только когда пользователь открывает Settings.
    ref.watch(hapticsEnabledProvider);
    // То же для замедления анимаций из меню разработчика.
    ref.watch(animationSpeedProvider);
    // Фактура листа — выключатель из меню разработчика.
    PageSheet.texture = ref.watch(backgroundNoiseProvider);
    final devBanner = ref.watch(devBannerProvider);
    final textScale = ref.watch(textScaleOverrideProvider);
    final grid = ref.watch(layoutGridProvider);
    final touches = ref.watch(touchIndicatorsProvider);

    return MaterialApp(
      title: 'TexFi m0ney',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(variant: variant, font: font),
      themeAnimationDuration: AppMotion.normal,
      showPerformanceOverlay: ref.watch(perfOverlayProvider),
      checkerboardRasterCacheImages: ref.watch(rasterCheckerboardProvider),
      checkerboardOffscreenLayers: ref.watch(layerCheckerboardProvider),
      showSemanticsDebugger: ref.watch(semanticsDebuggerProvider),
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      // Крап поверх заливки — один слой под всем приложением, как в f0kus
      // и как `PixelNoise` на сайте. Убирает ощущение пустой плоской
      // заливки, не мешая читать: точки в 2 логических пикселя с альфой
      // около 5% глаз считывает как фактуру, а не как шум под текстом.
      //
      // Поверх — отладочные слои из меню разработчика: масштаб текста,
      // сетка, кружки под пальцем, лента в углу.
      builder: (context, child) {
        var content = child ?? const SizedBox.shrink();
        if (textScale > 0) {
          content = MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(textScale),
            ),
            child: content,
          );
        }
        Widget body = PageSheet(child: content);
        if (grid) body = LayoutGridOverlay(child: body);
        if (touches) body = TouchIndicatorOverlay(child: body);
        if (!devBanner) return body;
        return Banner(
          message: 'DEV',
          location: BannerLocation.topEnd,
          child: body,
        );
      },
      home: const AppEntry(),
    );
  }
}
