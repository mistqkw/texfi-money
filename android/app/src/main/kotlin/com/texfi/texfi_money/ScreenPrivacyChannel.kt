package com.texfi.texfi_money

import android.app.Activity
import android.view.WindowManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Скрывает содержимое приложения от системы.
 *
 * `FLAG_SECURE` делает две вещи сразу: снимок для переключателя задач
 * заменяется пустым экраном и запрещаются скриншоты с записью экрана.
 * Для трекера расходов важна первая: список задач Android показывает
 * последний кадр приложения, и баланс со списком трат оказывается виден
 * любому, кто взял телефон со стола, — при том что само приложение
 * заблокировано и открыть его нельзя.
 *
 * Флаг ставится на окно, а окно живёт у Activity, поэтому канал держит
 * именно её, а не applicationContext.
 */
class ScreenPrivacyChannel(private val activity: Activity) :
    MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setSecure" -> {
                val enabled = call.argument<Boolean>("enabled") ?: false
                result.success(setSecure(enabled))
            }
            else -> result.notImplemented()
        }
    }

    private fun setSecure(enabled: Boolean): Boolean = try {
        // Обязательно в главном потоке: обращение к окну из другого
        // приводит к CalledFromWrongThreadException.
        activity.runOnUiThread {
            if (enabled) {
                activity.window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
            } else {
                activity.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
            }
        }
        true
    } catch (error: Exception) {
        false
    }

    companion object {
        private const val CHANNEL = "com.texfi.texfi_money/screen_privacy"

        fun register(messenger: BinaryMessenger, activity: Activity) {
            MethodChannel(messenger, CHANNEL)
                .setMethodCallHandler(ScreenPrivacyChannel(activity))
        }
    }
}
