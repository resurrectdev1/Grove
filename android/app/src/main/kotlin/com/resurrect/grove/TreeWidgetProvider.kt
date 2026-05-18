package com.resurrect.grove

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.RectF
import android.widget.RemoteViews
import org.json.JSONArray
import org.json.JSONObject
import kotlin.math.*

class TreeWidgetProvider : AppWidgetProvider() {

    companion object {
        const val ACTION_PICK_HABIT = "com.resurrect.grove.ACTION_TREE_PICK_HABIT"
        const val PREFS_NAME        = "FlutterSharedPreferences"
        const val KEY_HABITS        = "flutter.grove_v2_ids"
        const val KEY_TREE_HABIT    = "grove_widget_tree_habit_id"
    }

    override fun onUpdate(ctx: Context, mgr: AppWidgetManager, ids: IntArray) {
        ids.forEach { updateWidget(ctx, mgr, it) }
    }

    override fun onReceive(ctx: Context, intent: Intent) {
        super.onReceive(ctx, intent)
        if (intent.action != ACTION_PICK_HABIT) return

            val prefs    = ctx.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val navPrefs = ctx.getSharedPreferences("grove_widget_nav", Context.MODE_PRIVATE)
            val habits   = loadHabitIds(prefs)
            val curId    = navPrefs.getString(KEY_TREE_HABIT, null)
            val idx      = habits.indexOf(curId)
            val nextId   = if (habits.isEmpty()) null else habits[(idx + 1) % habits.size]
            navPrefs.edit().putString(KEY_TREE_HABIT, nextId).apply()

            val mgr    = AppWidgetManager.getInstance(ctx)
            val allIds = mgr.getAppWidgetIds(
                android.content.ComponentName(ctx, TreeWidgetProvider::class.java))
            allIds.forEach { updateWidget(ctx, mgr, it) }
    }

    private fun updateWidget(ctx: Context, mgr: AppWidgetManager, widgetId: Int) {
        val flutterPrefs = ctx.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val navPrefs     = ctx.getSharedPreferences("grove_widget_nav", Context.MODE_PRIVATE)

        val habitIds = loadHabitIds(flutterPrefs)
        val selId    = navPrefs.getString(KEY_TREE_HABIT, habitIds.firstOrNull())
        val habit    = selId?.let { loadHabit(flutterPrefs, it) }

        val views = RemoteViews(ctx.packageName, R.layout.widget_tree)

        val habitName   = habit?.optString("name", "No habit") ?: "Tap to pick habit"
        val daysElapsed = habit?.let { computeDays(it) } ?: 0
        val stage       = stageFromDays(daysElapsed)

        views.setTextViewText(R.id.tree_habit_name,  habitName)
        views.setTextViewText(R.id.tree_days_count,  "$daysElapsed")
        views.setTextViewText(R.id.tree_days_label,  if (daysElapsed == 1) "day" else "days")
        views.setTextViewText(R.id.tree_stage_label, stageName(stage))
        views.setTextViewText(R.id.tree_tagline,     stageTagline(stage))

        val progress = (stageProgress(daysElapsed) * 100).toInt()
        views.setProgressBar(R.id.tree_progress, 100, progress, false)

        val habitColor = habit?.let {
            try {
                val raw = it.optInt("color", 0xFF4E8B5F.toInt())
                Color.argb(
                    (raw shr 24) and 0xFF,
                           (raw shr 16) and 0xFF,
                           (raw shr 8)  and 0xFF,
                           raw         and 0xFF)
            } catch (_: Exception) { Color.parseColor("#4E8B5F") }
        } ?: Color.parseColor("#4E8B5F")

        val seed = habit?.optInt("geneticSeed", 42) ?: 42
        val bmp  = drawTree(stage, daysElapsed, habitColor, seed)
        views.setImageViewBitmap(R.id.tree_image, bmp)

        views.setOnClickPendingIntent(R.id.tree_habit_name,
                                      actionIntent(ctx, widgetId, ACTION_PICK_HABIT))

        val openApp = PendingIntent.getActivity(
            ctx, widgetId + 5000,
            ctx.packageManager.getLaunchIntentForPackage(ctx.packageName),
                                                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        views.setOnClickPendingIntent(R.id.tree_root, openApp)

        mgr.updateAppWidget(widgetId, views)
    }

    // ── Tree drawing ──────────────────────────────────────────────────────
    private fun drawTree(stage: Int, days: Int, color: Int, seed: Int): Bitmap {
        val size = 200
        val bmp  = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val c    = Canvas(bmp)
        val rng  = java.util.Random(seed.toLong())

        val trunkPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            this.color = Color.argb(255, 100, 70, 40)
            style = Paint.Style.FILL
        }
        val leafPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            this.color = color
            style = Paint.Style.FILL
        }
        val groundPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
            this.color = Color.argb(60, 78, 139, 95)
            style = Paint.Style.FILL
        }

        val cx   = size / 2f
        val base = size * 0.88f

        c.drawOval(RectF(cx - 40f, base - 6f, cx + 40f, base + 6f), groundPaint)

        when (stage) {
            0    -> drawSeed(c, cx, base, trunkPaint, leafPaint)
            1    -> drawSprout(c, cx, base, trunkPaint, leafPaint)
            2    -> drawSapling(c, cx, base, trunkPaint, leafPaint, rng)
            3    -> drawYoungTree(c, cx, base, trunkPaint, leafPaint, rng)
            else -> drawGroveTree(c, cx, base, trunkPaint, leafPaint, rng)
        }
        return bmp
    }

    private fun drawSeed(c: Canvas, cx: Float, base: Float, trunk: Paint, leaf: Paint) {
        leaf.alpha = 200
        c.drawOval(RectF(cx - 8f, base - 14f, cx + 8f, base), leaf)
        trunk.alpha = 180
        trunk.style = Paint.Style.STROKE
        trunk.strokeWidth = 2f
        c.drawLine(cx, base - 14f, cx, base, trunk)
        trunk.style = Paint.Style.FILL
    }

    private fun drawSprout(c: Canvas, cx: Float, base: Float, trunk: Paint, leaf: Paint) {
        val h = 30f
        c.drawRoundRect(RectF(cx - 3f, base - h, cx + 3f, base), 3f, 3f, trunk)
        leaf.alpha = 220
        c.drawOval(RectF(cx - 14f, base - h - 10f, cx + 14f, base - h + 12f), leaf)
    }

    private fun drawSapling(c: Canvas, cx: Float, base: Float, trunk: Paint, leaf: Paint, rng: java.util.Random) {
        val h = 60f
        c.drawRoundRect(RectF(cx - 5f, base - h, cx + 5f, base), 4f, 4f, trunk)
        drawBranch(c, cx, base - h * 0.5f, -35f, 20f, trunk)
        drawBranch(c, cx, base - h * 0.55f, 35f, 20f, trunk)
        leaf.alpha = 230
        c.drawCircle(cx - 14f, base - h * 0.5f - 12f, 14f, leaf)
        c.drawCircle(cx + 14f, base - h * 0.55f - 12f, 14f, leaf)
        c.drawCircle(cx, base - h - 4f, 18f, leaf)
    }

    private fun drawYoungTree(c: Canvas, cx: Float, base: Float, trunk: Paint, leaf: Paint, rng: java.util.Random) {
        val h = 90f
        c.drawRoundRect(RectF(cx - 7f, base - h, cx + 7f, base), 5f, 5f, trunk)
        for (i in 0..3) {
            val by  = base - h * (0.35f + i * 0.15f)
            val ang = if (i % 2 == 0) -40f else 40f
            drawBranch(c, cx, by, ang, 28f, trunk)
            val lx = cx + (if (ang < 0) -28f else 28f) * 0.7f
            val ly = by - 28f * 0.5f
            c.drawCircle(lx, ly, 16f + rng.nextFloat() * 4, leaf)
        }
        leaf.alpha = 240
        c.drawCircle(cx, base - h - 6f, 22f, leaf)
    }

    private fun drawGroveTree(c: Canvas, cx: Float, base: Float, trunk: Paint, leaf: Paint, rng: java.util.Random) {
        val h = 120f
        c.drawRoundRect(RectF(cx - 9f, base - h, cx + 9f, base), 7f, 7f, trunk)
        val branches = listOf(-45f, 45f, -30f, 30f, -55f, 55f)
        val heights  = listOf(0.3f, 0.32f, 0.5f, 0.52f, 0.65f, 0.67f)
        branches.forEachIndexed { i, ang ->
            val by  = base - h * heights[i]
            val len = 35f + rng.nextFloat() * 10f
            drawBranch(c, cx, by, ang, len, trunk)
            val lx = cx + (if (ang < 0) -len else len) * 0.7f
            val ly = by - len * 0.45f
            leaf.alpha = (200 + rng.nextInt(55))
            c.drawCircle(lx, ly, 18f + rng.nextFloat() * 6f, leaf)
        }
        leaf.alpha = 255
        c.drawCircle(cx, base - h - 10f, 28f, leaf)
        c.drawCircle(cx - 12f, base - h + 5f, 20f, leaf)
        c.drawCircle(cx + 12f, base - h + 5f, 20f, leaf)
    }

    private fun drawBranch(c: Canvas, x: Float, y: Float, angleDeg: Float, length: Float, paint: Paint) {
        val rad = Math.toRadians(angleDeg.toDouble() - 90)
        val ex  = x + (cos(rad) * length).toFloat()
        val ey  = y + (sin(rad) * length).toFloat()
        val old = paint.style
        paint.style = Paint.Style.STROKE
        paint.strokeWidth = 4f
        c.drawLine(x, y, ex, ey, paint)
        paint.style = old
    }

    // ── Stage helpers ─────────────────────────────────────────────────────
    private fun computeDays(habit: JSONObject): Int {
        val resetStr = habit.optString("lastReset", "").ifEmpty { habit.optString("startDate", "") }
        return try {
            val sdf  = java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", java.util.Locale.US)
            val date = sdf.parse(resetStr.take(19)) ?: return 0
            ((System.currentTimeMillis() - date.time) / 86_400_000L).toInt()
        } catch (_: Exception) { 0 }
    }

    private fun stageFromDays(d: Int) = when {
        d <= 1  -> 0
        d <= 7  -> 1
        d <= 30 -> 2
        d <= 90 -> 3
        else    -> 4
    }

    private fun stageName(s: Int) = arrayOf(
        "Seed", "Sprout", "Sapling", "Young Tree", "Grove Tree")[s]

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

        private fun actionIntent(ctx: Context, widgetId: Int, action: String): PendingIntent {
            val intent = Intent(ctx, TreeWidgetProvider::class.java).apply {
                this.action = action
                putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
            }
            return PendingIntent.getBroadcast(
                ctx, widgetId * 100 + action.hashCode(),
                                              intent,
                                              PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        }
}
