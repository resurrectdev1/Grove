package com.resurrect.grove

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.widget.RemoteViews
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.*

class CalendarWidgetProvider : AppWidgetProvider() {

    companion object {
        const val ACTION_PREV_MONTH = "com.resurrect.grove.ACTION_CAL_PREV"
        const val ACTION_NEXT_MONTH = "com.resurrect.grove.ACTION_CAL_NEXT"
        const val ACTION_PICK_HABIT = "com.resurrect.grove.ACTION_CAL_PICK_HABIT"
        const val FLUTTER_PREFS     = "FlutterSharedPreferences"
        const val NAV_PREFS         = "grove_cal_nav"
        const val KEY_HABITS        = "flutter.grove_v2_ids"
        // Per-widget habit key: "cal_habit_id_$widgetId"  (written by HabitPickerActivity too)
        const val KEY_CAL_YEAR      = "cal_year"
        const val KEY_CAL_MONTH     = "cal_month"
    }

    override fun onUpdate(ctx: Context, mgr: AppWidgetManager, ids: IntArray) {
        ids.forEach { updateWidget(ctx, mgr, it) }
    }

    override fun onReceive(ctx: Context, intent: Intent) {
        super.onReceive(ctx, intent)

        val widgetId     = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID,
                                              AppWidgetManager.INVALID_APPWIDGET_ID)
        val flutterPrefs = ctx.getSharedPreferences(FLUTTER_PREFS, Context.MODE_PRIVATE)
        val navPrefs     = ctx.getSharedPreferences(NAV_PREFS, Context.MODE_PRIVATE)

        when (intent.action) {
            ACTION_PREV_MONTH -> shiftMonth(navPrefs, widgetId, -1)
            ACTION_NEXT_MONTH -> shiftMonth(navPrefs, widgetId, +1)
            ACTION_PICK_HABIT -> cycleHabit(flutterPrefs, navPrefs, widgetId)
        }

        val mgr    = AppWidgetManager.getInstance(ctx)
        val allIds = mgr.getAppWidgetIds(ComponentName(ctx, CalendarWidgetProvider::class.java))
        allIds.forEach { updateWidget(ctx, mgr, it) }
    }

    // ── Cycle through habits for a specific widget ────────────────────────
    private fun cycleHabit(flutterPrefs: SharedPreferences,
        navPrefs: SharedPreferences,
        widgetId: Int) {
        val habits    = loadHabitIds(flutterPrefs)
        if (habits.isEmpty()) return
            val key       = "cal_habit_id_$widgetId"
            val currentId = navPrefs.getString(key, null)
            val idx       = habits.indexOf(currentId)   // -1 if not found → next = 0 ✓
            val nextId    = habits[(idx + 1) % habits.size]
            navPrefs.edit().putString(key, nextId).apply()
        }

        private fun updateWidget(ctx: Context, mgr: AppWidgetManager, widgetId: Int) {
            val flutterPrefs = ctx.getSharedPreferences(FLUTTER_PREFS, Context.MODE_PRIVATE)
            val navPrefs     = ctx.getSharedPreferences(NAV_PREFS, Context.MODE_PRIVATE)
            val views        = RemoteViews(ctx.packageName, R.layout.widget_calendar)

            val habitIds = loadHabitIds(flutterPrefs)
            // Per-widget key — written by HabitPickerActivity on first placement / reconfigure
            val selId    = navPrefs.getString("cal_habit_id_$widgetId", habitIds.firstOrNull())
            val habit    = selId?.let { loadHabit(flutterPrefs, it) }

            val now   = Calendar.getInstance()
            // Per-widget month navigation keys
            val year  = navPrefs.getInt("${KEY_CAL_YEAR}_$widgetId",  now.get(Calendar.YEAR))
            val month = navPrefs.getInt("${KEY_CAL_MONTH}_$widgetId", now.get(Calendar.MONTH) + 1)

            val monthName = SimpleDateFormat("MMMM yyyy", Locale.getDefault())
            .format(GregorianCalendar(year, month - 1, 1).time)
            views.setTextViewText(R.id.cal_month_label, monthName)

            val habitName = habit?.optString("name", "—") ?: "Tap to pick habit"
            views.setTextViewText(R.id.cal_habit_name, "🌿 $habitName  ›")

            // Build relapse set for this month
            val relapseDays = mutableSetOf<Int>()
            habit?.optJSONArray("relapses")?.let { arr ->
                for (i in 0 until arr.length()) {
                    val ts = arr.getJSONObject(i).optString("timestamp", "")
                    if (ts.length >= 10) {
                        val y = ts.substring(0, 4).toIntOrNull() ?: continue
                        val m = ts.substring(5, 7).toIntOrNull() ?: continue
                        val d = ts.substring(8, 10).toIntOrNull() ?: continue
                        if (y == year && m == month) relapseDays.add(d)
                    }
                }
            }

            val cal         = GregorianCalendar(year, month - 1, 1)
            val firstDow    = (cal.get(Calendar.DAY_OF_WEEK) - Calendar.SUNDAY + 7) % 7
            val daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH)
            val today       = Calendar.getInstance()
            val todayYear   = today.get(Calendar.YEAR)
            val todayMonth  = today.get(Calendar.MONTH) + 1
            val todayDay    = today.get(Calendar.DAY_OF_MONTH)

            val cellIds = listOf(
                R.id.d00,R.id.d01,R.id.d02,R.id.d03,R.id.d04,R.id.d05,R.id.d06,
                R.id.d10,R.id.d11,R.id.d12,R.id.d13,R.id.d14,R.id.d15,R.id.d16,
                R.id.d20,R.id.d21,R.id.d22,R.id.d23,R.id.d24,R.id.d25,R.id.d26,
                R.id.d30,R.id.d31,R.id.d32,R.id.d33,R.id.d34,R.id.d35,R.id.d36,
                R.id.d40,R.id.d41,R.id.d42,R.id.d43,R.id.d44,R.id.d45,R.id.d46,
                R.id.d50,R.id.d51,R.id.d52,R.id.d53,R.id.d54,R.id.d55,R.id.d56,
            )

            for (cell in 0 until 42) {
                val day = cell - firstDow + 1
                val id  = cellIds[cell]
                if (day < 1 || day > daysInMonth) {
                    views.setTextViewText(id, "")
                    views.setInt(id, "setBackgroundResource", R.drawable.cal_cell_empty)
                } else {
                    views.setTextViewText(id, "$day")
                    val isToday   = year == todayYear && month == todayMonth && day == todayDay
                    val isRelapse = relapseDays.contains(day)
                    val isFuture  = year > todayYear ||
                    (year == todayYear && month > todayMonth) ||
                    (year == todayYear && month == todayMonth && day > todayDay)
                    val bgRes = when {
                        isRelapse -> R.drawable.cal_cell_relapse
                        isToday   -> R.drawable.cal_cell_today
                        isFuture  -> R.drawable.cal_cell_future
                        else      -> R.drawable.cal_cell_clean
                    }
                    views.setInt(id, "setBackgroundResource", bgRes)
                }
            }

            views.setOnClickPendingIntent(R.id.cal_btn_prev,
                                          makeBroadcast(ctx, ACTION_PREV_MONTH, widgetId, widgetId * 10 + 1))
            views.setOnClickPendingIntent(R.id.cal_btn_next,
                                          makeBroadcast(ctx, ACTION_NEXT_MONTH, widgetId, widgetId * 10 + 2))
            views.setOnClickPendingIntent(R.id.cal_habit_name,
                                          makeBroadcast(ctx, ACTION_PICK_HABIT, widgetId, widgetId * 10 + 3))

            val openApp = PendingIntent.getActivity(
                ctx, widgetId * 10 + 4,
                ctx.packageManager.getLaunchIntentForPackage(ctx.packageName),
                                                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.cal_root, openApp)

            mgr.updateAppWidget(widgetId, views)
        }

        /**
         * Broadcasts carry the widgetId so onReceive can apply changes to the
         * correct per-widget prefs key.
         */
        private fun makeBroadcast(ctx: Context, action: String,
            widgetId: Int, requestCode: Int): PendingIntent {
                val intent = Intent(action).apply {
                    component = ComponentName(ctx, CalendarWidgetProvider::class.java)
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
                }
                return PendingIntent.getBroadcast(
                    ctx, requestCode, intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            }

            private fun shiftMonth(prefs: SharedPreferences, widgetId: Int, delta: Int) {
                val now   = Calendar.getInstance()
                val yearKey  = "${KEY_CAL_YEAR}_$widgetId"
                val monthKey = "${KEY_CAL_MONTH}_$widgetId"
                var year  = prefs.getInt(yearKey,  now.get(Calendar.YEAR))
                var month = prefs.getInt(monthKey, now.get(Calendar.MONTH) + 1)
                month += delta
                if (month < 1)  { month = 12; year-- }
                if (month > 12) { month = 1;  year++ }
                prefs.edit().putInt(yearKey, year).putInt(monthKey, month).apply()
            }

            private fun loadHabitIds(prefs: SharedPreferences): List<String> {
                val raw = prefs.getString(KEY_HABITS, null) ?: return emptyList()
                return try {
                    val arr = JSONArray(raw)
                    (0 until arr.length()).map { arr.getString(it) }
                } catch (_: Exception) { emptyList() }
            }

            private fun loadHabit(prefs: SharedPreferences, id: String): JSONObject? {
                val json = prefs.getString("flutter.$id", null) ?: return null
                return try { JSONObject(json) } catch (_: Exception) { null }
            }
}
