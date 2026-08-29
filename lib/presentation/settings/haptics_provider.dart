import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/utils/haptics.dart';
import 'currency_provider.dart';

const _prefsKey = 'haptics_enabled';

class HapticsEnabledNotifier extends StateNotifier<bool> {
  HapticsEnabledNotifier(this._prefs) : super(_prefs.getBool(_prefsKey) ?? true) {
    Haptics.enabled = state;
  }

  final SharedPreferences _prefs;

  Future<void> setEnabled(bool value) async {
    state = value;
    Haptics.enabled = value;
    await _prefs.setBool(_prefsKey, value);
  }
}

final hapticsEnabledProvider = StateNotifierProvider<HapticsEnabledNotifier, bool>((ref) {
  return HapticsEnabledNotifier(ref.watch(sharedPreferencesProvider));
});
