package com.resurrect.grove

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterFragmentActivity() {

    private val CHANNEL = "com.grove.app/widgets"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        .setMethodCallHandler { call, result ->
            when (call.method) {

                "getFilesDir" -> {
                    result.success(filesDir.absolutePath)
                }

                "saveTreeImage" -> {
                    try {
                        val habitId = call.argument<String>("habitId")
                        ?: return@setMethodCallHandler result.error(
                            "MISSING_ARG", "habitId is required", null)
                        val bytes = call.argument<ByteArray>("bytes")
                        ?: return@setMethodCallHandler result.error(
                            "MISSING_ARG", "bytes is required", null)

                        val dir = File(filesDir, "grove_trees")
                        if (!dir.exists()) dir.mkdirs()

                            val file = File(dir, "$habitId.png")
                            FileOutputStream(file).use { it.write(bytes) }

                            result.success(null)
                    } catch (e: Exception) {
                        result.error("SAVE_FAILED", e.message, null)
                    }
                }

                "updateWidgets" -> {
                    refreshAllWidgets()
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun refreshAllWidgets() {
        val mgr = AppWidgetManager.getInstance(this)
        listOf(
            CalendarWidgetProvider::class.java,
            TreeWidgetProvider::class.java,
            CheckInWidgetProvider::class.java
        ).forEach { cls ->
            val ids = mgr.getAppWidgetIds(ComponentName(this, cls))
            if (ids.isNotEmpty()) {
                sendBroadcast(Intent(AppWidgetManager.ACTION_APPWIDGET_UPDATE).apply {
                    component = ComponentName(this@MainActivity, cls)
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                })
            }
        }
    }
}
