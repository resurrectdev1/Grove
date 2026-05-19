package com.resurrect.grove

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.Typeface
import android.os.Bundle
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import io.flutter.embedding.android.FlutterFragmentActivity
import org.json.JSONArray
import org.json.JSONObject

class HabitPickerActivity : FlutterFragmentActivity() {

    companion object {
        private const val FLUTTER_PREFS = "FlutterSharedPreferences"
        private const val KEY_HABITS    = "flutter.grove_v2_ids"
    }

    private var widgetId   = AppWidgetManager.INVALID_APPWIDGET_ID
    private var isCalendar = true

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        widgetId = intent?.extras?.getInt(
            AppWidgetManager.EXTRA_APPWIDGET_ID,
            AppWidgetManager.INVALID_APPWIDGET_ID
        ) ?: AppWidgetManager.INVALID_APPWIDGET_ID

        setResult(RESULT_CANCELED,
            Intent().putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId))

        if (widgetId == AppWidgetManager.INVALID_APPWIDGET_ID) { finish(); return }

        val mgr          = AppWidgetManager.getInstance(this)
        val providerName = mgr.getAppWidgetInfo(widgetId)?.provider?.className ?: ""
        isCalendar       = providerName.contains("Calendar", ignoreCase = true)

        val prefs    = getSharedPreferences(FLUTTER_PREFS, Context.MODE_PRIVATE)
        val habitIds = loadHabitIds(prefs)
        val habits   = habitIds.mapNotNull { id ->
            val obj = loadHabit(prefs, id) ?: return@mapNotNull null
            Pair(id, obj.optString("name", id))
        }

        setContentView(buildUI(habits))
    }

    // ── Build UI programmatically (so dat no layout XML needed) ──────────────────

    private fun buildUI(habits: List<Pair<String, String>>): View {
        val dp = { n: Int -> TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP, n.toFloat(), resources.displayMetrics).toInt() }

        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setBackgroundColor(Color.parseColor("#1A1A2E"))
            setPadding(dp(16), dp(24), dp(16), dp(16))
        }

        // Title
        val widgetTypeLabel = if (isCalendar) "Calendar Widget" else "Tree Widget"
        root.addView(TextView(this).apply {
            text = "Select a habit for your $widgetTypeLabel"
            setTextColor(Color.WHITE)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 18f)
            setTypeface(null, Typeface.BOLD)
            setPadding(0, 0, 0, dp(16))
        })

        if (habits.isEmpty()) {
            root.addView(TextView(this).apply {
                text = "No habits found.\nCreate a habit in Grove first."
                setTextColor(Color.parseColor("#AAAAAA"))
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 15f)
                gravity = Gravity.CENTER
                setPadding(dp(8), dp(32), dp(8), dp(32))
            })
            return root
        }

        val scroll = ScrollView(this)
        val list   = LinearLayout(this).apply { orientation = LinearLayout.VERTICAL }

        habits.forEach { (id, name) ->
            val row = TextView(this).apply {
                text      = "🌿  $name"
                tag       = id
                setTextColor(Color.WHITE)
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
                setPadding(dp(16), dp(14), dp(16), dp(14))
                setBackgroundColor(Color.parseColor("#2A2A3E"))
                val lp = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT)
                lp.setMargins(0, 0, 0, dp(8))
                layoutParams = lp
                isClickable  = true
                isFocusable  = true
                setOnClickListener { onHabitSelected(id) }
            }
            list.addView(row)
        }

        scroll.addView(list)
        root.addView(scroll)
        return root
    }

    // ── Selection ─────────────────────────────────────────────────────────

    private fun onHabitSelected(habitId: String) {
        saveSelection(habitId)
        triggerWidgetUpdate()
        setResult(RESULT_OK,
            Intent().putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId))
        finish()
    }

    private fun saveSelection(habitId: String) {
        if (isCalendar) {
            getSharedPreferences(CalendarWidgetProvider.NAV_PREFS, Context.MODE_PRIVATE)
                .edit()
                .putString("cal_habit_id_$widgetId", habitId)
                .apply()
        } else {
            getSharedPreferences("grove_widget_nav", Context.MODE_PRIVATE)
                .edit()
                .putString("tree_habit_id_$widgetId", habitId)
                .apply()
        }
    }

    private fun triggerWidgetUpdate() {
        val mgr = AppWidgetManager.getInstance(this)
        val cls = if (isCalendar) CalendarWidgetProvider::class.java
                  else            TreeWidgetProvider::class.java
        val ids = mgr.getAppWidgetIds(ComponentName(this, cls))
        if (ids.isNotEmpty()) {
            sendBroadcast(Intent(AppWidgetManager.ACTION_APPWIDGET_UPDATE).apply {
                component = ComponentName(this@HabitPickerActivity, cls)
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
            })
        }
    }

    // ── Data helpers ──────────────────────────────────────────────────────

    private fun loadHabitIds(prefs: android.content.SharedPreferences): List<String> {
        val raw = prefs.getString(KEY_HABITS, null) ?: return emptyList()
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
