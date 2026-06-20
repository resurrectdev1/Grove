package com.resurrect.grove

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.*

class CheckInWidgetProvider : AppWidgetProvider() {

    companion object {
        const val ACTION_TOGGLE_CHECKIN = "com.resurrect.grove.ACTION_CHECKIN_TOGGLE"
        const val PREFS_NAME            = "FlutterSharedPreferences"
        const val NAV_PREFS             = "grove_checkin_nav"
        const val KEY_HABITS            = "flutter.grove_v2_ids"
        private const val LIST_PREFIX = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu"
    }

    override fun onUpdate(ctx: Context, mgr: AppWidgetManager, ids: IntArray) {
        ids.forEach { updateWidget(ctx, mgr, it) }
    }

    override fun onReceive(ctx: Context, intent: Intent) {
        super.onReceive(ctx, intent)

        val mgr = AppWidgetManager.getInstance(ctx)

        when (intent.action) {
            ACTION_TOGGLE_CHECKIN -> {
                val widgetId = intent.getIntExtra(
                    AppWidgetManager.EXTRA_APPWIDGET_ID,
                    AppWidgetManager.INVALID_APPWIDGET_ID
                )
                if (widgetId != AppWidgetManager.INVALID_APPWIDGET_ID) {
                    toggleCheckIn(ctx, widgetId)
                }
            }
        }

        val allIds = mgr.getAppWidgetIds(ComponentName(ctx, CheckInWidgetProvider::class.java))
        allIds.forEach { updateWidget(ctx, mgr, it) }
    }

    private fun toggleCheckIn(ctx: Context, widgetId: Int) {
        val flutterPrefs = ctx.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val navPrefs     = ctx.getSharedPreferences(NAV_PREFS, Context.MODE_PRIVATE)

        val habitIds = loadHabitIds(flutterPrefs)
        if (habitIds.isEmpty()) return

        val selId = navPrefs.getString("checkin_habit_id_$widgetId", habitIds.firstOrNull())
            ?: return

        val habit = loadHabit(flutterPrefs, selId) ?: return

        val mode = habit.optInt("mode", 0)
        if (mode != 1) return

        val todayKey = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())

        val checkInDays = habit.optJSONArray("checkInDays") ?: JSONArray()
        val existing = mutableListOf<String>()
        for (i in 0 until checkInDays.length()) {
            val iso = checkInDays.optString(i, "")
            if (iso.length >= 10) {
                existing.add(iso.substring(0, 10))
            }
        }

        val isCheckedInToday = existing.contains(todayKey)

        val newArray = JSONArray()
        if (isCheckedInToday) {
            for (day in existing) {
                if (day != todayKey) {
                    newArray.put(day)
                }
            }
        } else {
            for (day in existing) {
                newArray.put(day)
            }
            newArray.put(todayKey)
        }

        habit.put("checkInDays", newArray)
        flutterPrefs.edit().putString("flutter.$selId", habit.toString()).apply()
    }

    private fun updateWidget(ctx: Context, mgr: AppWidgetManager, widgetId: Int) {
        val flutterPrefs = ctx.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val navPrefs     = ctx.getSharedPreferences(NAV_PREFS, Context.MODE_PRIVATE)

        val habitIds = loadHabitIds(flutterPrefs)
        val selId    = navPrefs.getString("checkin_habit_id_$widgetId", habitIds.firstOrNull())
        val habit    = selId?.let { loadHabit(flutterPrefs, it) }

        val views = RemoteViews(ctx.packageName, R.layout.widget_checkin)

        val habitName   = habit?.optString("name", "—") ?: "Tap to pick"
        val isCheckIn   = (habit?.optInt("mode", 0) ?: 0) == 1
        val streak      = if (isCheckIn) computeCheckInStreak(habit!!) else 0

        val todayKey    = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())
        val checkInDays = habit?.optJSONArray("checkInDays")
        var checkedToday = false
        if (checkInDays != null && isCheckIn) {
            for (i in 0 until checkInDays.length()) {
                val iso = checkInDays.optString(i, "")
                if (iso.length >= 10 && iso.substring(0, 10) == todayKey) {
                    checkedToday = true
                    break
                }
            }
        }

        views.setTextViewText(R.id.checkin_habit_name, habitName)
        views.setTextViewText(R.id.checkin_streak, "$streak")

        if (isCheckIn) {
            val color = habit?.optInt("color", 0xFF4E8B5F.toInt()) ?: 0xFF4E8B5F.toInt()
            val alpha = if (checkedToday) color or (0xFF shl 24) else (0x44E0EBE0.toInt())

            views.setTextViewText(R.id.checkin_icon, if (checkedToday) "✓" else "○")
            views.setInt(R.id.checkin_icon, "setTextColor", alpha.toInt())
        } else {
            views.setTextViewText(R.id.checkin_icon, "—")
            views.setInt(R.id.checkin_icon, "setTextColor", 0x448AA88C.toInt())
        }

        views.setOnClickPendingIntent(
            R.id.checkin_icon,
            makeBroadcast(ctx, ACTION_TOGGLE_CHECKIN, widgetId, widgetId * 10 + 1)
        )

        val openApp = PendingIntent.getActivity(
            ctx, widgetId * 10 + 2,
            ctx.packageManager.getLaunchIntentForPackage(ctx.packageName),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.checkin_root, openApp)

        mgr.updateAppWidget(widgetId, views)
    }

    private fun computeCheckInStreak(habit: JSONObject): Int {
        val arr = habit.optJSONArray("checkInDays") ?: return 0
        if (arr.length() == 0) return 0

        val days = mutableSetOf<String>()
        for (i in 0 until arr.length()) {
            val iso = arr.optString(i, "")
            if (iso.length >= 10) days.add(iso.substring(0, 10))
        }

        val cal    = Calendar.getInstance()
        var streak = 0
        val sdf    = SimpleDateFormat("yyyy-MM-dd", Locale.US)

        while (true) {
            val key = sdf.format(cal.time)
            if (days.contains(key)) {
                streak++
                cal.add(Calendar.DAY_OF_YEAR, -1)
            } else {
                break
            }
        }
        return streak
    }

    private fun makeBroadcast(ctx: Context, action: String,
                              widgetId: Int, requestCode: Int): PendingIntent {
        val intent = Intent(action).apply {
            component = ComponentName(ctx, CheckInWidgetProvider::class.java)
            putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
        }
        return PendingIntent.getBroadcast(
            ctx, requestCode, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun loadHabitIds(prefs: android.content.SharedPreferences): List<String> {
        try {
            val set = prefs.getStringSet(KEY_HABITS, null)
            if (!set.isNullOrEmpty()) return set.toList()
        } catch (_: ClassCastException) {}

        val raw = prefs.getString(KEY_HABITS, null) ?: return emptyList()

        if (raw.startsWith(LIST_PREFIX)) {
            val bang = raw.indexOf('!')
            if (bang >= 0) {
                return try {
                    val arr = JSONArray(raw.substring(bang + 1))
                    (0 until arr.length()).map { arr.getString(it) }
                } catch (_: Exception) { emptyList() }
            }
        }

        return try {
            val arr = JSONArray(raw)
            (0 until arr.length()).map { arr.getString(it) }
        } catch (_: Exception) { emptyList() }
    }

    private fun loadHabit(prefs: android.content.SharedPreferences, id: String): JSONObject? {
        val json = prefs.getString("flutter.$id", null) ?: return null
        return try { JSONObject(json) } catch (_: Exception) { null }
    }
}
