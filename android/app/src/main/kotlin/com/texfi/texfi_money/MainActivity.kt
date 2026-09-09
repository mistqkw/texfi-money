package com.texfi.texfi_money

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

/**
 * FlutterFragmentActivity, а не FlutterActivity: биометрический запрос
 * поднимается через BiometricPrompt, а тот живёт во фрагменте. На обычной
 * FlutterActivity диалог просто не появляется, и блокировка выглядит как
 * молча не сработавшая.
 */
class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        ScreenPrivacyChannel.register(flutterEngine.dartExecutor.binaryMessenger, this)
    }
}
