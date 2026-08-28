import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../onboarding/onboarding_screen.dart';
import '../settings/onboarding_provider.dart';
import 'launch_splash.dart';
import 'root_shell.dart';

/// Сплэш на каждом запуске → онбординг один раз при первом запуске → главный экран.
class AppEntry extends ConsumerStatefulWidget {
  const AppEntry({super.key});

  @override
  ConsumerState<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends ConsumerState<AppEntry> {
  bool _splashDone = false;

  @override
  Widget build(BuildContext context) {
    if (!_splashDone) {
      return LaunchSplash(onFinished: () => setState(() => _splashDone = true));
    }

    final hasSeenOnboarding = ref.watch(hasSeenOnboardingProvider);
    return hasSeenOnboarding ? const RootShell() : const OnboardingScreen();
  }
}
