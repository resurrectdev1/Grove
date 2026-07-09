package com.resurrect.grove

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

class TreeWidgetProvider : AppWidgetProvider() {

    companion object {
        const val ACTION_PICK_HABIT = "com.resurrect.grove.ACTION_TREE_PICK_HABIT"
        const val PREFS_NAME        = "FlutterSharedPreferences"
        const val NAV_PREFS         = "grove_widget_nav"
        const val KEY_HABITS        = "flutter.grove_v2_ids"
        private const val LIST_PREFIX = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu"
    }

    override fun onUpdate(ctx: Context, mgr: AppWidgetManager, ids: IntArray) {
        ids.forEach { updateWidget(ctx, mgr, it) }
    }

    override fun onReceive(ctx: Context, intent: Intent) {
        super.onReceive(ctx, intent)
        if (intent.action != ACTION_PICK_HABIT) return

            val widgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID,
                                              AppWidgetManager.INVALID_APPWIDGET_ID)
            val prefs    = ctx.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val navPrefs = ctx.getSharedPreferences(NAV_PREFS, Context.MODE_PRIVATE)
            val habits   = loadHabitIds(prefs)
            val key      = "tree_habit_id_$widgetId"
            val curId    = navPrefs.getString(key, null)
            val idx      = habits.indexOf(curId)
            val nextId   = if (habits.isEmpty()) null else habits[(idx + 1) % habits.size]
            navPrefs.edit().putString(key, nextId).apply()

            val mgr    = AppWidgetManager.getInstance(ctx)
            val allIds = mgr.getAppWidgetIds(ComponentName(ctx, TreeWidgetProvider::class.java))
            allIds.forEach { updateWidget(ctx, mgr, it) }
    }

    private fun updateWidget(ctx: Context, mgr: AppWidgetManager, widgetId: Int) {
        val flutterPrefs = ctx.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val navPrefs     = ctx.getSharedPreferences(NAV_PREFS, Context.MODE_PRIVATE)

        val habitIds = loadHabitIds(flutterPrefs)
        val selId    = navPrefs.getString("tree_habit_id_$widgetId", habitIds.firstOrNull())
        val habit    = selId?.let { loadHabit(flutterPrefs, it) }

        val views = RemoteViews(ctx.packageName, R.layout.widget_tree)

        val habitName    = habit?.optString("name", "No habit") ?: "Tap to pick habit"
        val daysElapsed  = habit?.let { computeDays(it) } ?: 0
        val stage        = stageFromDays(daysElapsed)
        val isCheckIn    = (habit?.optInt("mode", 0) ?: 0) == 1

        views.setTextViewText(R.id.tree_habit_name,  habitName)
        views.setTextViewText(R.id.tree_days_count,  "$daysElapsed")
        views.setTextViewText(R.id.tree_days_label,
                              if (isCheckIn) (if (daysElapsed == 1) "day streak" else "day streak")
                                  else           (if (daysElapsed == 1) "day" else "days"))
        views.setTextViewText(R.id.tree_stage_label, stageName(stage))
        views.setTextViewText(R.id.tree_tagline,     stageTagline(stage))

        val progress = (stageProgress(daysElapsed) * 100).toInt()
        views.setProgressBar(R.id.tree_progress, 100, progress, false)

        if (selId != null) {
            val imgFile = File(ctx.filesDir, "grove_trees/${selId}.png")
            if (imgFile.exists()) {
                val bmp = BitmapFactory.decodeFile(imgFile.absolutePath)
                if (bmp != null) {
                    views.setImageViewBitmap(R.id.tree_image, bmp)
                } else {
                    views.setImageViewResource(R.id.tree_image, android.R.color.transparent)
                }
            } else {
            }
        }

        views.setOnClickPendingIntent(R.id.tree_habit_name,
                                      actionIntent(ctx, widgetId, ACTION_PICK_HABIT))

        val openApp = PendingIntent.getActivity(
            ctx, widgetId + 5000,
            ctx.packageManager.getLaunchIntentForPackage(ctx.packageName),
                                                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        views.setOnClickPendingIntent(R.id.tree_root, openApp)

        mgr.updateAppWidget(widgetId, views)
    }


    private fun computeDays(habit: JSONObject): Int {
        val mode = habit.optInt("mode", 0)
        return if (mode == 1) computeCheckInStreak(habit) else computeAbstainDays(habit)
    }

    private fun computeAbstainDays(habit: JSONObject): Int {
        val resetStr = habit.optString("lastReset", "").ifEmpty { habit.optString("startDate", "") }
        return try {
            val sdf  = java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", java.util.Locale.US)
            val date = sdf.parse(resetStr.take(19)) ?: return 0
            ((System.currentTimeMillis() - date.time) / 86_400_000L).toInt()
        } catch (_: Exception) { 0 }
    }


    private fun computeCheckInStreak(habit: JSONObject): Int {
        val checkInArr = habit.optJSONArray("checkInDays")
        val nullArr    = habit.optJSONArray("nullDays")

        val days = mutableSetOf<String>()
        checkInArr?.let {
            for (i in 0 until it.length()) {
                val iso = it.optString(i, "")
                if (iso.length >= 10) days.add(iso.substring(0, 10))
            }
        }
        nullArr?.let {
            for (i in 0 until it.length()) {
                val iso = it.optString(i, "")
                if (iso.length >= 10) days.add(iso.substring(0, 10))
            }
        }
        if (days.isEmpty()) return 0

            val sdf = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.US)
            val cal = java.util.Calendar.getInstance()

            if (!days.contains(sdf.format(cal.time))) {
                cal.add(java.util.Calendar.DAY_OF_YEAR, -1)
                if (!days.contains(sdf.format(cal.time))) return 0
            }

            var streak = 0
            while (true) {
                val key = sdf.format(cal.time)
                if (days.contains(key)) {
                    streak++
                    cal.add(java.util.Calendar.DAY_OF_YEAR, -1)
                } else {
                    break
                }
            }
            return streak
    }

    private fun stageFromDays(d: Int) = when {
        d <= 1  -> 0; d <= 7  -> 1; d <= 30 -> 2; d <= 90 -> 3; else -> 4 }

        private fun stageName(s: Int) =
            arrayOf("Seed", "Sprout", "Sapling", "Young Tree", "Grove Tree")[s]

            private fun stageTagline(s: Int) = arrayOf(
                "Every great forest starts here.",
                "Roots are forming beneath the surface.",
                "Growing stronger with every sunrise.",
                "Your canopy is taking shape.",
                "You have become the forest."
            )[s]

            private fun stageProgress(d: Int) = when {
                d <= 1  -> d / 1.0f
                d <= 7  -> (d - 2) / 5.0f
                d <= 30 -> (d - 8) / 22.0f
                d <= 90 -> (d - 31) / 59.0f
                else    -> 1f
            }.coerceIn(0f, 1f)


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

            private fun actionIntent(ctx: Context, widgetId: Int, action: String): PendingIntent {
                val intent = Intent(ctx, TreeWidgetProvider::class.java).apply {
                    this.action = action
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
                }
                return PendingIntent.getBroadcast(
                    ctx, widgetId * 100 + action.hashCode(), intent,
                                                  PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            }
}
