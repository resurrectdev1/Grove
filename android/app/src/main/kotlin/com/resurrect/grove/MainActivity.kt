package com.resurrect.grove

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private val CHANNEL = "com.grove.app/widgets"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        .setMethodCallHandler { call, result ->
            if (call.method == "updateWidgets") {
                refreshAllWidgets()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun refreshAllWidgets() {
        val mgr = AppWidgetManager.getInstance(this)
        listOf(
            CalendarWidgetProvider::class.java,
            TreeWidgetProvider::class.java
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
