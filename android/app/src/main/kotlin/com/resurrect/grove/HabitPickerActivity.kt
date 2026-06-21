package com.resurrect.grove

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.Typeface
import android.os.Bundle
import android.util.Log
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import org.json.JSONArray
import org.json.JSONObject

class HabitPickerActivity : Activity() {

    companion object {
        private const val TAG           = "GroveHabitPicker"
        private const val FLUTTER_PREFS = "FlutterSharedPreferences"
        private const val KEY_HABITS    = "flutter.grove_v2_ids"
        private const val LIST_PREFIX   = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu"

        private const val TYPE_CALENDAR = "calendar"
        private const val TYPE_CHECKIN  = "checkin"
        private const val TYPE_TREE     = "tree"
    }

    private var widgetId   = AppWidgetManager.INVALID_APPWIDGET_ID
    private var widgetType = TYPE_TREE

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
        widgetType = when {
            providerName.contains("Calendar", ignoreCase = true) -> TYPE_CALENDAR
            providerName.contains("CheckIn",  ignoreCase = true) -> TYPE_CHECKIN
            else                                                  -> TYPE_TREE
        }

        val prefs = getSharedPreferences(FLUTTER_PREFS, Context.MODE_PRIVATE)

        Log.d(TAG, "=== FlutterSharedPreferences dump ===")
        val allKeys = prefs.all
        Log.d(TAG, "Total keys: ${allKeys.size}")
        allKeys.forEach { (k, v) ->
            val preview = when (v) {
                is String -> if (v.length > 120) v.take(120) + "..." else v
                is Set<*> -> "StringSet(${v.size}): ${v.take(3)}..."
                else      -> v.toString()
            }
            Log.d(TAG, "  KEY='$k'  TYPE=${v?.javaClass?.simpleName}  VAL=$preview")
        }
        Log.d(TAG, "=== end dump ===")

        val habitIds = loadHabitIds(prefs)
        Log.d(TAG, "Loaded ${habitIds.size} habit IDs: $habitIds")

        val allHabits = habitIds.mapNotNull { id ->
            val obj = loadHabit(prefs, id)
            Log.d(TAG, "  habit '$id' -> ${if (obj != null) obj.optString("name", "?") else "NOT FOUND"}")
            if (obj == null) return@mapNotNull null
                Triple(id, obj.optString("name", id), obj.optInt("mode", 0))
        }

        val habits: List<Pair<String, String>> = if (widgetType == TYPE_CHECKIN) {
            allHabits
            .filter { (_, _, mode) -> mode == 1 }
            .map    { (id, name, _) -> Pair(id, name) }
        } else {
            allHabits.map { (id, name, _) -> Pair(id, name) }
        }

        setContentView(buildUI(habits))
    }

    private fun buildUI(habits: List<Pair<String, String>>): View {
        val dp = { n: Int ->
            TypedValue.applyDimension(
                TypedValue.COMPLEX_UNIT_DIP, n.toFloat(), resources.displayMetrics
            ).toInt()
        }

        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setBackgroundColor(Color.parseColor("#1A1A2E"))
            setPadding(dp(16), dp(24), dp(16), dp(16))
        }

        val widgetTypeLabel = when (widgetType) {
            TYPE_CALENDAR -> "Calendar Widget"
            TYPE_CHECKIN  -> "Check-In Widget"
            else          -> "Tree Widget"
        }
        root.addView(TextView(this).apply {
            text = "Select a habit for your $widgetTypeLabel"
            setTextColor(Color.WHITE)
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 18f)
            setTypeface(null, Typeface.BOLD)
            setPadding(0, 0, 0, dp(16))
        })

        if (habits.isEmpty()) {
            val emptyMsg: String = if (widgetType == TYPE_CHECKIN) {
                "No check-in habits found.\nOpen Grove and create a habit with Check-In mode first."
            } else {
                "No habits found.\nCreate a habit in Grove first."
            }

            root.addView(TextView(this).apply {
                text = emptyMsg
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
            list.addView(TextView(this).apply {
                text = "  $name"
                setTextColor(Color.WHITE)
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
                setPadding(dp(16), dp(14), dp(16), dp(14))
                setBackgroundColor(Color.parseColor("#2A2A3E"))
                layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                ).also { it.setMargins(0, 0, 0, dp(8)) }
                isClickable = true
                isFocusable = true
                setOnClickListener { onHabitSelected(id) }
            })
        }

        scroll.addView(list)
        root.addView(scroll)
        return root
    }

    private fun onHabitSelected(habitId: String) {
        saveSelection(habitId)
        triggerWidgetUpdate()
        setResult(RESULT_OK,
                  Intent().putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId))
        finish()
    }

    private fun saveSelection(habitId: String) {
        when (widgetType) {
            TYPE_CALENDAR -> {
                getSharedPreferences(CalendarWidgetProvider.NAV_PREFS, Context.MODE_PRIVATE)
                .edit().putString("cal_habit_id_$widgetId", habitId).apply()
            }
            TYPE_CHECKIN -> {
                getSharedPreferences(CheckInWidgetProvider.NAV_PREFS, Context.MODE_PRIVATE)
                .edit().putString("checkin_habit_id_$widgetId", habitId).apply()
            }
            else -> {
                getSharedPreferences("grove_widget_nav", Context.MODE_PRIVATE)
                .edit().putString("tree_habit_id_$widgetId", habitId).apply()
            }
        }
    }

    private fun triggerWidgetUpdate() {
        val mgr = AppWidgetManager.getInstance(this)
        val cls = when (widgetType) {
            TYPE_CALENDAR -> CalendarWidgetProvider::class.java
            TYPE_CHECKIN  -> CheckInWidgetProvider::class.java
            else          -> TreeWidgetProvider::class.java
        }
        val ids = mgr.getAppWidgetIds(ComponentName(this, cls))
        if (ids.isNotEmpty()) {
            sendBroadcast(Intent(AppWidgetManager.ACTION_APPWIDGET_UPDATE).apply {
                component = ComponentName(this@HabitPickerActivity, cls)
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
            })
        }
    }

    private fun loadHabitIds(prefs: android.content.SharedPreferences): List<String> {
        try {
            val set = prefs.getStringSet(KEY_HABITS, null)
            if (!set.isNullOrEmpty()) {
                Log.d(TAG, "loadHabitIds: found StringSet with ${set.size} items")
                return set.toList()
            }
        } catch (e: ClassCastException) {
            Log.d(TAG, "loadHabitIds: not a StringSet, trying String")
        }

        val raw = prefs.getString(KEY_HABITS, null)
        if (raw == null) {
            Log.d(TAG, "loadHabitIds: key not found")
            return emptyList()
        }
        Log.d(TAG, "loadHabitIds: raw value (first 200): ${raw.take(200)}")

        if (raw.startsWith(LIST_PREFIX)) {
            val bang = raw.indexOf('!')
            if (bang >= 0) {
                val jsonPart = raw.substring(bang + 1)
                return try {
                    val arr = JSONArray(jsonPart)
                    (0 until arr.length()).map { arr.getString(it) }
                } catch (_: Exception) { emptyList() }
            }
        }

        return try {
            val arr   = JSONArray(raw)
            val items = (0 until arr.length()).map { arr.getString(it) }
            Log.d(TAG, "loadHabitIds: decoded JSON array: $items")
            items
        } catch (e: Exception) {
            Log.e(TAG, "loadHabitIds: all formats failed. raw=$raw", e)
            emptyList()
        }
    }

    private fun loadHabit(prefs: android.content.SharedPreferences, id: String): JSONObject? {
        val json = prefs.getString("flutter.$id", null) ?: return null
        return try { JSONObject(json) } catch (_: Exception) { null }
    }
}
