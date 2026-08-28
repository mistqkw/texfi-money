import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'currency_provider.dart';

const _prefsKey = 'has_seen_onboarding';

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier(this._prefs) : super(_prefs.getBool(_prefsKey) ?? false);

  final SharedPreferences _prefs;

  Future<void> markSeen() async {
    state = true;
    await _prefs.setBool(_prefsKey, true);
  }
}

final hasSeenOnboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier(ref.watch(sharedPreferencesProvider));
});
