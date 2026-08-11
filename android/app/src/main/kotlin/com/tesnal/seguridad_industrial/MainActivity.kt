package com.tesnal.seguridad_industrial

import android.os.SystemClock
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.tesnal.seguridad_industrial/security_signals",
        ).setMethodCallHandler { call, result ->
            if (call.method != "obtener") {
                result.notImplemented()
                return@setMethodCallHandler
            }

            val resolver = applicationContext.contentResolver
            result.success(
                mapOf(
                    "elapsed_realtime_ms" to SystemClock.elapsedRealtime(),
                    "boot_count" to Settings.Global.getInt(
                        resolver,
                        Settings.Global.BOOT_COUNT,
                        -1,
                    ),
                    "hora_automatica" to (Settings.Global.getInt(
                        resolver,
                        Settings.Global.AUTO_TIME,
                        0,
                    ) == 1),
                    "opciones_desarrollador" to (Settings.Global.getInt(
                        resolver,
                        Settings.Global.DEVELOPMENT_SETTINGS_ENABLED,
                        1,
                    ) == 1),
                    "adb_activo" to (Settings.Global.getInt(
                        resolver,
                        Settings.Global.ADB_ENABLED,
                        1,
                    ) == 1),
                ),
            )
        }
    }
}
