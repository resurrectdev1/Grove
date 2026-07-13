import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:grove/l10n/app_localizations.dart';
import 'package:grove/models/grove_models.dart';
import 'package:grove/painters/fractal_tree_painter.dart';
import 'package:grove/providers/grove_model.dart';
import 'package:grove/providers/grove_settings.dart';
import 'package:grove/services/grove_biometrics.dart';
import 'package:grove/theme/grove_theme.dart';
import 'package:grove/widgets/add_habit_sheet.dart';
import 'package:grove/widgets/habit_card.dart';
import 'package:grove/widgets/onboarding_sheet.dart';

class GroveHomeScreen extends StatefulWidget {
  const GroveHomeScreen({super.key});
  @override
  State<GroveHomeScreen> createState() => _GroveHomeScreenState();
}

class _GroveHomeScreenState extends State<GroveHomeScreen> {
  final _scrollCtrl = FixedExtentScrollController();
  late PageController _carouselCtrl;
  int _selectedIdx = 0;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _carouselCtrl = PageController(viewportFraction: 0.82);
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _appVersion = info.version);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = context.read<GroveSettings>();
      if (!settings.onboardingDone) {
        _showOnboarding();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _carouselCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habits = context.watch<GroveModel>().habits;
    final settings = context.watch<GroveSettings>();
    final theme = settings.theme;
    final l10n = AppLocalizations.of(context);

    if (habits.isNotEmpty && _selectedIdx >= habits.length) {
      _selectedIdx = habits.length - 1;
    }

    return Scaffold(
      backgroundColor: theme.bg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: Icon(
              Icons.info_outline_rounded,
              color: theme.textSecondary,
              size: 20,
            ),
            onPressed: () => _showAboutSheet(context),
          ),
        ),
        title: Text(
          l10n.appTagline,
          style: TextStyle(
            color: theme.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            letterSpacing: 8,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: theme.textSecondary,
                size: 20,
              ),
              onPressed: () => _showSettingsHub(context),
            ),
          ),
        ],
      ),
      body: habits.isEmpty
          ? _emptyState(theme, l10n)
          : _buildLayoutEngine(habits, settings.layoutMode, theme),
      floatingActionButton: _fab(context, theme, l10n),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showOnboarding() {
    final settingsProvider = context.read<GroveSettings>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => const OnboardingSheet(),
    ).then((_) {
      settingsProvider.completeOnboarding();
    });
  }

  void _showAboutSheet(BuildContext ctx) {
    final theme = ctx.read<GroveSettings>().theme;
    final bottomPad = MediaQuery.of(ctx).padding.bottom;
    final l10n = AppLocalizations.of(ctx);

    showModalBottomSheet(
      context: ctx,
      backgroundColor: theme.surfaceHigh,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPad),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.textMuted.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/app_icon_info.png',
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grove',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: theme.textPrimary,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      l10n.versionLabel(
                        _appVersion.isEmpty ? '...' : _appVersion,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.groveDescription,
              style: TextStyle(
                fontSize: 13,
                color: theme.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.links,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: theme.textMuted,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            _AboutLinkTile(
              icon: Icons.code_rounded,
              iconColor: theme.textPrimary,
              label: l10n.github,
              sublabel: l10n.githubSubtitle,
              url: 'https://github.com/resurrectdev1/Grove',
              theme: theme,
            ),
            const SizedBox(height: 10),
            _AboutLinkTile(
              icon: Icons.coffee_rounded,
              iconColor: const Color(0xFFFFDD57),
              label: l10n.buyMeCoffee,
              sublabel: l10n.buyMeCoffeeSubtitle,
              url: 'https://buymeacoffee.com/resurrect',
              theme: theme,
            ),
            const SizedBox(height: 10),
            _AboutLinkTile(
              icon: Icons.favorite_rounded,
              iconColor: const Color(0xFFEF5350),
              label: l10n.needHelp,
              sublabel: l10n.needHelpSubtitle,
              url: 'https://findahelpline.com',
              theme: theme,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.madeWith,
              style: TextStyle(fontSize: 10, color: theme.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayoutEngine(
    List<HabitTree> habits,
    LayoutMode mode,
    GroveTheme theme,
  ) {
    switch (mode) {
      case LayoutMode.verticalWheel:
        return _buildVerticalWheel(habits, theme);
      case LayoutMode.horizontalCarousel:
        return _buildHorizontalCarousel(habits, theme);
      case LayoutMode.compactGrid:
        return _buildCompactGrid(habits, theme);
      case LayoutMode.compactList:
        return _buildCompactList(habits, theme);
    }
  }

  Widget _buildVerticalWheel(List<HabitTree> habits, GroveTheme theme) => Stack(
    children: [
      ListWheelScrollView.useDelegate(
        controller: _scrollCtrl,
        itemExtent: 390,
        diameterRatio: 2.4,
        perspective: 0.0025,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (i) {
          setState(() => _selectedIdx = i);
          HapticFeedback.selectionClick();
        },
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: habits.length,
          builder: (ctx, i) => HabitCard(
            habit: habits[i],
            isSelected: i == _selectedIdx,
            layoutMode: LayoutMode.verticalWheel,
          ),
        ),
      ),
      _fade(theme, top: true),
      _fade(theme, top: false),
    ],
  );

  Widget _buildHorizontalCarousel(List<HabitTree> habits, GroveTheme theme) =>
      PageView.builder(
        controller: _carouselCtrl,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (i) {
          setState(() => _selectedIdx = i);
          HapticFeedback.selectionClick();
        },
        itemCount: habits.length,
        itemBuilder: (ctx, i) => AnimatedBuilder(
          animation: _carouselCtrl,
          builder: (ctx, child) {
            double value = 1.0;
            if (_carouselCtrl.position.haveDimensions) {
              value = _carouselCtrl.page! - i;
              value = (1 - (value.abs() * 0.15)).clamp(0.0, 1.0);
            }
            return Center(
              child: SizedBox(
                height: Curves.easeOut.transform(value) * 440,
                child: child,
              ),
            );
          },
          child: HabitCard(
            habit: habits[i],
            isSelected: i == _selectedIdx,
            layoutMode: LayoutMode.horizontalCarousel,
          ),
        ),
      );

  Widget _buildCompactGrid(List<HabitTree> habits, GroveTheme theme) =>
      SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 16, bottom: 120),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: habits.length,
            itemBuilder: (ctx, i) => HabitCard(
              habit: habits[i],
              isSelected: true,
              layoutMode: LayoutMode.compactGrid,
            ),
          ),
        ),
      );

  Widget _buildCompactList(List<HabitTree> habits, GroveTheme theme) =>
      SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 16, bottom: 120),
            itemCount: habits.length,
            itemBuilder: (ctx, i) => HabitCard(
              habit: habits[i],
              isSelected: true,
              layoutMode: LayoutMode.compactList,
            ),
          ),
        ),
      );

  void _showReorderSheet(BuildContext ctx) {
    final model = ctx.read<GroveModel>();
    final settings = ctx.read<GroveSettings>();
    final theme = settings.theme;
    final bottomPad = MediaQuery.of(ctx).padding.bottom;
    final l10n = AppLocalizations.of(ctx);

    showModalBottomSheet(
      context: ctx,
      backgroundColor: theme.surfaceHigh,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (_, setSheet) {
          final habits = model.habits.toList();
          return SizedBox(
            height: MediaQuery.of(sheetCtx).size.height * 0.75,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Column(
                    children: [
                      Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.textMuted.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            l10n.reorderGrove,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: theme.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            l10n.holdDragToReorder,
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.textMuted,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Expanded(
                  child: ReorderableListView.builder(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 24 + bottomPad),
                    itemCount: habits.length,
                    onReorder: (oldIndex, newIndex) {
                      if (newIndex > oldIndex) newIndex--;
                      model.reorderHabits(oldIndex, newIndex);
                      HapticFeedback.selectionClick();
                      setSheet(() {});
                    },
                    itemBuilder: (_, i) {
                      final h = habits[i];
                      return Container(
                        key: ValueKey(h.id),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: theme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: h.color.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: h.color,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: h.color.withValues(alpha: 0.5),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                h.name,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: theme.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              l10n.dayCount(h.daysElapsed),
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.drag_handle_rounded,
                              color: theme.textMuted,
                              size: 22,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSettingsHub(BuildContext ctx) {
    final model = ctx.read<GroveModel>();
    final settings = ctx.read<GroveSettings>();
    final bottomPad = MediaQuery.of(ctx).padding.bottom;

    showModalBottomSheet(
      context: ctx,
      backgroundColor: settings.theme.surfaceHigh,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetCtx) => Consumer<GroveSettings>(
        builder: (_, settings, _) {
          final l10n = AppLocalizations.of(sheetCtx);
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: settings.theme.textMuted.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.settingsHub,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: settings.theme.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  l10n.layoutArchitecture,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: settings.theme.textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _LayoutButton(
                      label: l10n.layoutWheel,
                      icon: Icons.view_day,
                      isSelected:
                          settings.layoutMode == LayoutMode.verticalWheel,
                      theme: settings.theme,
                      onTap: () {
                        settings.setLayoutMode(LayoutMode.verticalWheel);
                        HapticFeedback.selectionClick();
                        Navigator.pop(sheetCtx);
                      },
                    ),
                    const SizedBox(width: 8),
                    _LayoutButton(
                      label: l10n.layoutCarousel,
                      icon: Icons.view_carousel,
                      isSelected:
                          settings.layoutMode == LayoutMode.horizontalCarousel,
                      theme: settings.theme,
                      onTap: () {
                        settings.setLayoutMode(LayoutMode.horizontalCarousel);
                        HapticFeedback.selectionClick();
                        Navigator.pop(sheetCtx);
                      },
                    ),
                    const SizedBox(width: 8),
                    _LayoutButton(
                      label: l10n.layoutGrid,
                      icon: Icons.grid_view,
                      isSelected: settings.layoutMode == LayoutMode.compactGrid,
                      theme: settings.theme,
                      onTap: () {
                        settings.setLayoutMode(LayoutMode.compactGrid);
                        HapticFeedback.selectionClick();
                        Navigator.pop(sheetCtx);
                      },
                    ),
                    const SizedBox(width: 8),
                    _LayoutButton(
                      label: l10n.layoutList,
                      icon: Icons.list,
                      isSelected: settings.layoutMode == LayoutMode.compactList,
                      theme: settings.theme,
                      onTap: () {
                        settings.setLayoutMode(LayoutMode.compactList);
                        HapticFeedback.selectionClick();
                        Navigator.pop(sheetCtx);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetCtx);
                    _showReorderSheet(ctx);
                  },
                  icon: Icon(
                    Icons.swap_vert_rounded,
                    size: 16,
                    color: settings.theme.textSecondary,
                  ),
                  label: Text(
                    l10n.reorderGrove,
                    style: TextStyle(color: settings.theme.textPrimary),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                      color: settings.theme.textMuted.withValues(alpha: 0.4),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                Text(
                  l10n.renderThemes,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: settings.theme.textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                RadioGroup<GroveThemeMode>(
                  groupValue: settings.themeMode,
                  onChanged: (val) {
                    if (val != null) settings.setThemeMode(val);
                    HapticFeedback.selectionClick();
                    Navigator.pop(sheetCtx);
                  },
                  child: Column(
                    children: GroveThemeMode.values.map((mode) {
                      final labels = {
                        GroveThemeMode.forestDark: l10n.themeForestDark,
                        GroveThemeMode.amoledBlack: l10n.themeAmoledBlack,
                        GroveThemeMode.materialYou: l10n.themeMaterialYou,
                        GroveThemeMode.whiteMinimal: l10n.themeWhiteMinimal,
                      };
                      return RadioListTile<GroveThemeMode>(
                        value: mode,
                        activeColor: settings.theme.primary,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          labels[mode]!,
                          style: TextStyle(color: settings.theme.textPrimary),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _showAccentPicker(sheetCtx, settings),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: settings.theme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: settings.theme.textMuted.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: settings.theme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: settings.theme.textMuted.withValues(
                                alpha: 0.3,
                              ),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: settings.theme.primary.withValues(
                                  alpha: 0.45,
                                ),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.customAccentColor,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: settings.theme.textPrimary,
                                ),
                              ),
                              Text(
                                settings.customAccent != null
                                    ? '#${settings.customAccent!.toARGB32().toRadixString(16).substring(2).toUpperCase()}'
                                    : l10n.customAccentDefault,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: settings.theme.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: settings.theme.textMuted,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 32),

                Text(
                  l10n.privacyNotifications,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: settings.theme.textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.milestoneNotifications,
                    style: TextStyle(
                      color: settings.theme.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    l10n.milestoneNotificationsSubtitle,
                    style: TextStyle(
                      color: settings.theme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  activeThumbColor: settings.theme.primary,
                  value: settings.milestoneNotifications,
                  onChanged: (val) async {
                    HapticFeedback.selectionClick();
                    await settings.setMilestoneNotifications(val);
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.dailyReminderSetting,
                    style: TextStyle(
                      color: settings.theme.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    l10n.dailyReminderSettingSubtitle,
                    style: TextStyle(
                      color: settings.theme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  activeThumbColor: settings.theme.primary,
                  value: settings.dailyReminder,
                  onChanged: (val) async {
                    HapticFeedback.selectionClick();
                    if (val) {
                      final picked = await showTimePicker(
                        context: sheetCtx,
                        initialTime:
                            settings.dailyReminderTime ??
                            const TimeOfDay(hour: 9, minute: 0),
                      );
                      if (picked != null) {
                        await settings.setDailyReminder(true, picked);
                      }
                    } else {
                      await settings.setDailyReminder(false, null);
                    }
                  },
                ),
                if (settings.dailyReminder &&
                    settings.dailyReminderTime != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 4),
                    child: GestureDetector(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: sheetCtx,
                          initialTime: settings.dailyReminderTime!,
                        );
                        if (picked != null) {
                          HapticFeedback.selectionClick();
                          await settings.setDailyReminder(true, picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 11,
                        ),
                        decoration: BoxDecoration(
                          color: settings.theme.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: settings.theme.primary.withValues(
                              alpha: 0.25,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 15,
                              color: settings.theme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              settings.dailyReminderTime!.format(sheetCtx),
                              style: TextStyle(
                                fontSize: 13,
                                color: settings.theme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              l10n.tapToChange,
                              style: TextStyle(
                                fontSize: 11,
                                color: settings.theme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                FutureBuilder<bool>(
                  future: GroveBiometrics.instance.isAvailable,
                  builder: (_, snap) {
                    final available = snap.data ?? false;
                    if (!available) return const SizedBox.shrink();
                    return SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        l10n.biometricUnlock,
                        style: TextStyle(
                          color: settings.theme.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        l10n.biometricUnlockSubtitle,
                        style: TextStyle(
                          color: settings.theme.textMuted,
                          fontSize: 11,
                        ),
                      ),
                      activeThumbColor: settings.theme.primary,
                      value: settings.biometricUnlock,
                      onChanged: (val) async {
                        HapticFeedback.selectionClick();
                        await settings.setBiometricUnlock(val);
                      },
                    );
                  },
                ),

                const Divider(height: 32),

                Text(
                  l10n.languageSection,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: settings.theme.textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 4),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: settings.theme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.language_rounded,
                      color: settings.theme.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    l10n.languageLabel,
                    style: TextStyle(
                      color: settings.theme.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    _localeName(settings.locale),
                    style: TextStyle(
                      color: settings.theme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: settings.theme.textMuted,
                  ),
                  onTap: () => _showLanguagePicker(sheetCtx, settings, l10n),
                ),

                const Divider(height: 32),

                Text(
                  l10n.dataManagement,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: settings.theme.textSecondary,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _showExportSheet(ctx, model, settings),
                  icon: const Icon(Icons.upload_outlined, size: 16),
                  label: Text(l10n.exportGroveBackup),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: settings.theme.textPrimary,
                    side: BorderSide(
                      color: settings.theme.textMuted.withValues(alpha: 0.4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => _showImportSheet(ctx, model, settings),
                  icon: const Icon(Icons.download_outlined, size: 16),
                  label: Text(l10n.restoreGroveBackup),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: settings.theme.textPrimary,
                    side: BorderSide(
                      color: settings.theme.textMuted.withValues(alpha: 0.4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.exportImportNote,
                  style: TextStyle(
                    fontSize: 10,
                    color: settings.theme.textMuted,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static const _languageOptions = <String, Locale?>{
    '🌐  System Default': null,
    '🇬🇧  English': Locale('en'),
    '🇸🇦  العربية': Locale('ar'),
    '🇩🇪  Deutsch': Locale('de'),
    '🇪🇸  Español': Locale('es'),
    '🇫🇷  Français': Locale('fr'),
    '🇮🇳  हिंदी': Locale('hi'),
    '🇮🇹  italiano': Locale('it'),
    '🇯🇵  日本語': Locale('ja'),
    '🇰🇷  한국인': Locale('ko'),
    '🇵🇹  português': Locale('pt'),
    '🇵🇰  اردو': Locale('ur'),
    '🇻🇳  tiếng Việt': Locale('vi'),
    '🇨🇳  简体中文': Locale('zh'),
    '🇹🇼  繁體中文': Locale('zh', 'TW'),
  };

  String _localeName(Locale? locale) {
    if (locale == null) return 'System Default';
    for (final entry in _languageOptions.entries) {
      if (entry.value == locale)
        return entry.key.replaceAll(RegExp(r'^.{2,3}\s+'), '');
    }
    return locale.toLanguageTag();
  }

  void _showAccentPicker(BuildContext ctx, GroveSettings settings) {
    final theme = settings.theme;
    final l10n = AppLocalizations.of(ctx);
    final bottomPad = MediaQuery.of(ctx).padding.bottom;

    Color pickedColor = settings.customAccent ?? GroveTheme.mossGreen;
    bool validHex = true;
    final hexCtrl = TextEditingController(
      text: pickedColor.toARGB32().toRadixString(16).substring(2).toUpperCase(),
    );

    showModalBottomSheet(
      context: ctx,
      backgroundColor: theme.surfaceHigh,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (_, setSheet) {
          void updateFromHex(String value) {
            try {
              final hex = value.replaceFirst('#', '');
              if (hex.length != 6) {
                setSheet(() => validHex = false);
                return;
              }
              final color = Color(int.parse('FF$hex', radix: 16));
              setSheet(() {
                validHex = true;
                pickedColor = color;
              });
            } catch (_) {
              setSheet(() => validHex = false);
            }
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + bottomPad),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.textMuted.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.customAccentColor,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.customAccentSubtitle,
                    style: TextStyle(fontSize: 13, color: theme.textSecondary),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    l10n.presetColors,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.textSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: GroveTheme.treePalette.map((c) {
                      final sel = c == pickedColor;
                      return GestureDetector(
                        onTap: () => setSheet(() {
                          pickedColor = c;
                          hexCtrl.text = c
                              .toARGB32()
                              .toRadixString(16)
                              .substring(2)
                              .toUpperCase();
                          validHex = true;
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: sel
                                  ? GroveTheme.dewWhite
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                            boxShadow: sel
                                ? [
                                    BoxShadow(
                                      color: c.withValues(alpha: 0.6),
                                      blurRadius: 10,
                                    ),
                                  ]
                                : [],
                          ),
                          child: sel
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    l10n.customHexCode,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.textSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: hexCtrl,
                          textCapitalization: TextCapitalization.characters,
                          style: TextStyle(color: theme.textPrimary),
                          onChanged: updateFromHex,
                          maxLength: 6,
                          decoration: InputDecoration(
                            labelText: l10n.hexCode,
                            prefixText: '#',
                            prefixStyle: TextStyle(color: theme.textSecondary),
                            hintText: '4E8B5F',
                            prefixIcon: Icon(
                              Icons.palette_outlined,
                              size: 18,
                              color: theme.textMuted,
                            ),
                            errorText: validHex ? null : l10n.invalidHex,
                            counterText: '',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: pickedColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.textMuted.withValues(alpha: 0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: pickedColor.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  FilledButton(
                    onPressed: validHex
                        ? () async {
                            HapticFeedback.lightImpact();
                            Navigator.pop(sheetCtx);
                            await Future.delayed(
                              const Duration(milliseconds: 300),
                            );
                            settings.setCustomAccent(pickedColor);
                            if (ctx.mounted) Navigator.pop(ctx);
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: pickedColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      l10n.applyAccent,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (settings.customAccent != null)
                    TextButton(
                      onPressed: () async {
                        HapticFeedback.lightImpact();
                        Navigator.pop(sheetCtx);
                        await Future.delayed(const Duration(milliseconds: 300));
                        settings.setCustomAccent(null);
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                      child: Text(
                        l10n.resetAccentDefault,
                        style: TextStyle(color: theme.textMuted, fontSize: 13),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    ).whenComplete(() => hexCtrl.dispose());
  }

  void _showLanguagePicker(
    BuildContext ctx,
    GroveSettings settings,
    AppLocalizations l10n,
  ) {
    final theme = settings.theme;
    showDialog(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        scrollable: true,
        backgroundColor: theme.surfaceHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          l10n.languageLabel,
          style: TextStyle(
            color: theme.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languageOptions.entries.map((entry) {
            final isSelected = settings.locale == entry.value;
            return ListTile(
              title: Text(
                entry.key,
                style: TextStyle(
                  color: isSelected ? theme.primary : theme.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check_rounded, color: theme.primary, size: 18)
                  : null,
              onTap: () async {
                HapticFeedback.selectionClick();
                await settings.setLocale(entry.value);
                if (dialogCtx.mounted) Navigator.pop(dialogCtx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _showExportSheet(
    BuildContext ctx,
    GroveModel model,
    GroveSettings settings,
  ) async {
    final json = model.exportJson();
    final theme = settings.theme;
    final l10n = AppLocalizations.of(ctx);
    final fileName =
        'Grove_backup_${DateFormat("yyyy-MM-dd_HH-mm-ss").format(DateTime.now())}.json';
    final bytes = Uint8List.fromList(json.codeUnits);
    final messenger = ScaffoldMessenger.of(ctx);

    final String? outputPath = await FilePicker.saveFile(
      dialogTitle: l10n.saveGroveBackupDialog,
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['json'],
      bytes: bytes,
    );

    if (outputPath != null) {
      if (!Platform.isAndroid && !Platform.isIOS) {
        try {
          await File(outputPath).writeAsString(json);
        } catch (e) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(l10n.saveFailed(e.toString())),
              backgroundColor: GroveTheme.clayRed,
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
      }
      HapticFeedback.lightImpact();
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.backupSaved),
          backgroundColor: theme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _showImportSheet(
    BuildContext ctx,
    GroveModel model,
    GroveSettings settings,
  ) async {
    final theme = settings.theme;
    final l10n = AppLocalizations.of(ctx);
    final messenger = ScaffoldMessenger.of(ctx);

    final result = await FilePicker.pickFiles(
      dialogTitle: l10n.selectGroveBackupDialog,
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final fileBytes = result.files.first.bytes;
    final filePath = result.files.first.path;

    String? raw;
    if (fileBytes != null) {
      raw = String.fromCharCodes(fileBytes);
    } else if (filePath != null) {
      raw = await File(filePath).readAsString();
    }

    if (raw == null || raw.trim().isEmpty) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.couldNotReadFile),
          backgroundColor: GroveTheme.clayRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final success = await model.importFromJson(raw);

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? l10n.groveRestored(model.habits.length)
              : l10n.invalidBackup,
        ),
        backgroundColor: success ? theme.primary : GroveTheme.clayRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _emptyState(GroveTheme theme, AppLocalizations l10n) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 110,
          height: 110,
          child: CustomPaint(
            painter: FractalTreePainter(
              stage: GrowthStage.sprout,
              baseColor: theme.textMuted,
              progress: 0.6,
              windPhase: 0,
              geneticSeed: 0,
              daysElapsed: 4,
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          l10n.groveIsBare,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: theme.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.plantFirstTree,
          style: TextStyle(fontSize: 13, color: theme.textMuted),
        ),
        const SizedBox(height: 120),
      ],
    ),
  );

  Widget _fade(GroveTheme theme, {required bool top}) => Positioned(
    top: top ? 0 : null,
    bottom: top ? null : 0,
    left: 0,
    right: 0,
    height: 130,
    child: IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: top ? Alignment.topCenter : Alignment.bottomCenter,
            end: top ? Alignment.bottomCenter : Alignment.topCenter,
            colors: [theme.bg, theme.bg.withValues(alpha: 0)],
          ),
        ),
      ),
    ),
  );

  Widget _fab(BuildContext context, GroveTheme theme, AppLocalizations l10n) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton.extended(
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: theme.surfaceHigh,
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            builder: (_) => const AddHabitSheet(),
          ),
          backgroundColor: theme.primary,
          foregroundColor: theme.brightness == Brightness.light
              ? Colors.white
              : GroveTheme.dewWhite,
          icon: const Icon(Icons.forest_rounded),
          label: Text(
            l10n.plantATree,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
}

class _AboutLinkTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String sublabel;
  final String url;
  final GroveTheme theme;

  const _AboutLinkTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.sublabel,
    required this.url,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri))
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.textMuted.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.textPrimary,
                    ),
                  ),
                  Text(
                    sublabel,
                    style: TextStyle(fontSize: 11, color: theme.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.open_in_new_rounded, size: 16, color: theme.textMuted),
          ],
        ),
      ),
    ),
  );
}

class _LayoutButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final GroveTheme theme;

  const _LayoutButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? theme.primary : theme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? theme.primary
                  : theme.textMuted.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : theme.textSecondary,
              ),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : theme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
