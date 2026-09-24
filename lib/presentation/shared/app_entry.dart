import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../onboarding/onboarding_screen.dart';
import '../settings/developer_provider.dart';
import '../settings/onboarding_provider.dart';
import 'launch_splash.dart';
import 'lock_gate.dart';
import 'root_shell.dart';

/// Сплэш на каждом запуске → онбординг один раз при первом запуске → главный экран.
class AppEntry extends ConsumerStatefulWidget {
  const AppEntry({super.key});

  @override
  ConsumerState<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends ConsumerState<AppEntry> {
  // Заставку можно пропустить из меню разработчика: при сотом
  // перезапуске подряд полторы секунды анимации — уже не стиль, а помеха.
  late bool _splashDone = ref.read(skipSplashProvider);

  @override
  Widget build(BuildContext context) {
    if (!_splashDone) {
      return LaunchSplash(onFinished: () => setState(() => _splashDone = true));
    }

    final hasSeenOnboarding = ref.watch(hasSeenOnboardingProvider);
    if (!hasSeenOnboarding) return const OnboardingScreen();
    // Замок ставится после онбординга и до содержимого: закрывать им пустое
    // приложение, в котором ещё нет ни одной траты, незачем, а включить его
    // предлагается уже изнутри настроек.
    return const LockGate(child: RootShell());
  }
}
