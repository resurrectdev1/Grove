import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
  @override State<GroveHomeScreen> createState() => _GroveHomeScreenState();
}

class _GroveHomeScreenState extends State<GroveHomeScreen> {
  final _scrollCtrl = FixedExtentScrollController();
  late PageController _carouselCtrl;
  int _selectedIdx = 0;

  @override
  void initState() {
    super.initState();
    _carouselCtrl = PageController(viewportFraction: 0.82);
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
    final habits   = context.watch<GroveModel>().habits;
    final settings = context.watch<GroveSettings>();
    final theme    = settings.theme;

    if (habits.isNotEmpty && _selectedIdx >= habits.length) {
      _selectedIdx = habits.length - 1;
    }

    return Scaffold(
      backgroundColor:        theme.bg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:       0,
        centerTitle:     true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon:      Icon(Icons.info_outline_rounded, color: theme.textSecondary, size: 20),
            onPressed: () => _showAboutSheet(context),
          ),
        ),
        title: Text(
          'G R O V E',
          style: TextStyle(
            color: theme.textSecondary, fontSize: 13,
            fontWeight: FontWeight.w400, letterSpacing: 8,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon:      Icon(Icons.settings_outlined, color: theme.textSecondary, size: 20),
              onPressed: () => _showSettingsHub(context),
            ),
          ),
        ],
      ),
      body: habits.isEmpty
      ? _emptyState(theme)
      : _buildLayoutEngine(habits, settings.layoutMode, theme),
      floatingActionButton:         _fab(context, theme),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _showOnboarding() {
    final settingsProvider = context.read<GroveSettings>();
    showModalBottomSheet(
      context:            context,
      backgroundColor:    Colors.transparent,
      isScrollControlled: true,
      useSafeArea:        true,
      isDismissible:      false,
      enableDrag:         false,
      builder: (_) => const OnboardingSheet(),
    ).then((_) {
      settingsProvider.completeOnboarding();
    });
  }

  void _showAboutSheet(BuildContext ctx) {
    final theme     = ctx.read<GroveSettings>().theme;
    final bottomPad = MediaQuery.of(ctx).padding.bottom;

    showModalBottomSheet(
      context:            ctx,
      backgroundColor:    theme.surfaceHigh,
      isScrollControlled: true,
      useSafeArea:        true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPad),
        child: Column(
          mainAxisSize:       MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color:        theme.textMuted.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                SizedBox(
                  width: 52, height: 52,
                  child: CustomPaint(
                    painter: FractalTreePainter(
                      stage:       GrowthStage.youngTree,
                      baseColor:   theme.primary,
                      progress:    0.9,
                      windPhase:   0,
                      geneticSeed: 42,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Grove', style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800,
                      color: theme.textPrimary, letterSpacing: 1,
                    )),
                    Text('v0.5.9 • Open Source',
                         style: TextStyle(fontSize: 12, color: theme.textSecondary)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Grove is a minimalistic habit tracker that visualises your growth through trees. '
            'Every day you stay clean, your tree grows. '
            'Built with love as a free, open-source tool.',
            style: TextStyle(fontSize: 13, color: theme.textSecondary, height: 1.6),
            ),
            const SizedBox(height: 24),
            Text('LINKS', style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700,
              color: theme.textMuted, letterSpacing: 1.0,
            )),
            const SizedBox(height: 12),
            _AboutLinkTile(
              icon:      Icons.code_rounded,
              iconColor: theme.textPrimary,
              label:     'GitHub',
              sublabel:  'Source code & contributions',
              url:       'https://github.com/resurrectdev1/Grove',
              theme:     theme,
            ),
            const SizedBox(height: 10),
            _AboutLinkTile(
              icon:      Icons.coffee_rounded,
              iconColor: const Color(0xFFFFDD57),
              label:     'Buy Me a Coffee',
              sublabel:  'Support development',
              url:       'https://buymeacoffee.com/resurrect',
              theme:     theme,
            ),
            const SizedBox(height: 24),
            Text(
              'Made with 🌿 • all data stays on your device.',
              style:     TextStyle(fontSize: 10, color: theme.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayoutEngine(List<HabitTree> habits, LayoutMode mode, GroveTheme theme) {
    switch (mode) {
      case LayoutMode.verticalWheel:      return _buildVerticalWheel(habits, theme);
      case LayoutMode.horizontalCarousel: return _buildHorizontalCarousel(habits, theme);
      case LayoutMode.compactGrid:        return _buildCompactGrid(habits, theme);
      case LayoutMode.compactList:        return _buildCompactList(habits, theme);
    }
  }

  Widget _buildVerticalWheel(List<HabitTree> habits, GroveTheme theme) => Stack(
    children: [
      ListWheelScrollView.useDelegate(
        controller:    _scrollCtrl,
        itemExtent:    390,
        diameterRatio: 2.4,
        perspective:   0.0025,
        physics:       const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (i) {
          setState(() => _selectedIdx = i);
          HapticFeedback.selectionClick();
        },
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: habits.length,
          builder:    (ctx, i) => HabitCard(
            habit:      habits[i],
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
    controller:    _carouselCtrl,
    physics:       const BouncingScrollPhysics(),
    onPageChanged: (i) {
      setState(() => _selectedIdx = i);
      HapticFeedback.selectionClick();
    },
    itemCount:   habits.length,
    itemBuilder: (ctx, i) => AnimatedBuilder(
      animation: _carouselCtrl,
      builder:   (ctx, child) {
        double value = 1.0;
        if (_carouselCtrl.position.haveDimensions) {
          value = _carouselCtrl.page! - i;
          value = (1 - (value.abs() * 0.15)).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(height: Curves.easeOut.transform(value) * 440, child: child),
        );
      },
      child: HabitCard(
        habit:      habits[i],
        isSelected: i == _selectedIdx,
        layoutMode: LayoutMode.horizontalCarousel,
      ),
    ),
  );

  Widget _buildCompactGrid(List<HabitTree> habits, GroveTheme theme) => SafeArea(
    bottom: false,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        physics:  const BouncingScrollPhysics(),
        padding:  const EdgeInsets.only(top: 16, bottom: 120),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.72,
          crossAxisSpacing: 12, mainAxisSpacing: 12,
        ),
        itemCount:   habits.length,
        itemBuilder: (ctx, i) => HabitCard(
          habit:      habits[i],
          isSelected: true,
          layoutMode: LayoutMode.compactGrid,
        ),
      ),
    ),
  );

  Widget _buildCompactList(List<HabitTree> habits, GroveTheme theme) => SafeArea(
    bottom: false,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        physics:     const BouncingScrollPhysics(),
        padding:     const EdgeInsets.only(top: 16, bottom: 120),
        itemCount:   habits.length,
        itemBuilder: (ctx, i) => HabitCard(
          habit:      habits[i],
          isSelected: true,
          layoutMode: LayoutMode.compactList,
        ),
      ),
    ),
  );

  void _showSettingsHub(BuildContext ctx) {
    final settings  = ctx.read<GroveSettings>();
    final model     = ctx.read<GroveModel>();
    final bottomPad = MediaQuery.of(ctx).padding.bottom;

    showModalBottomSheet(
      context:            ctx,
      backgroundColor:    settings.theme.surfaceHigh,
      isScrollControlled: true,
      useSafeArea:        true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPad),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize:       MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36, height: 4,
                  decoration: BoxDecoration(
                    color:        settings.theme.textMuted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Settings Hub', style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700,
                color: settings.theme.textPrimary,
              )),
              const SizedBox(height: 24),
              Text('LAYOUT ARCHITECTURE', style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700,
                color: settings.theme.textSecondary, letterSpacing: 1.0,
              )),
              const SizedBox(height: 12),
              Row(
                children: [
                  _LayoutButton(
                    label: 'Wheel', icon: Icons.view_day,
                    isSelected: settings.layoutMode == LayoutMode.verticalWheel,
                    theme: settings.theme,
                    onTap: () { settings.setLayoutMode(LayoutMode.verticalWheel); HapticFeedback.selectionClick(); Navigator.pop(ctx); },
                  ),
                  const SizedBox(width: 8),
                  _LayoutButton(
                    label: 'Carousel', icon: Icons.view_carousel,
                    isSelected: settings.layoutMode == LayoutMode.horizontalCarousel,
                    theme: settings.theme,
                    onTap: () { settings.setLayoutMode(LayoutMode.horizontalCarousel); HapticFeedback.selectionClick(); Navigator.pop(ctx); },
                  ),
                  const SizedBox(width: 8),
                  _LayoutButton(
                    label: 'Grid', icon: Icons.grid_view,
                    isSelected: settings.layoutMode == LayoutMode.compactGrid,
                    theme: settings.theme,
                    onTap: () { settings.setLayoutMode(LayoutMode.compactGrid); HapticFeedback.selectionClick(); Navigator.pop(ctx); },
                  ),
                  const SizedBox(width: 8),
                  _LayoutButton(
                    label: 'List', icon: Icons.list,
                    isSelected: settings.layoutMode == LayoutMode.compactList,
                    theme: settings.theme,
                    onTap: () { settings.setLayoutMode(LayoutMode.compactList); HapticFeedback.selectionClick(); Navigator.pop(ctx); },
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text('RENDER THEMES', style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700,
                color: settings.theme.textSecondary, letterSpacing: 1.0,
              )),
              const SizedBox(height: 8),
              RadioGroup<GroveThemeMode>(
                groupValue: settings.themeMode,
                onChanged: (val) {
                  if (val != null) settings.setThemeMode(val);
                  HapticFeedback.selectionClick();
                  Navigator.pop(ctx);
                },
                child: Column(
                  children: GroveThemeMode.values.map((mode) {
                    const labels = {
                      GroveThemeMode.forestDark:   'Forest Dark',
                      GroveThemeMode.amoledBlack:  'AMOLED Black',
                      GroveThemeMode.materialYou:  'Material You',
                      GroveThemeMode.whiteMinimal: 'White Minimal',
                    };
                    return RadioListTile<GroveThemeMode>(
                      value:          mode,
                      activeColor:    settings.theme.primary,
                      contentPadding: EdgeInsets.zero,
                      title: Text(labels[mode]!, style: TextStyle(color: settings.theme.textPrimary)),
                    );
                  }).toList(),
                ),
              ),
              const Divider(height: 32),
              Text('PRIVACY & NOTIFICATIONS', style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700,
                color: settings.theme.textSecondary, letterSpacing: 1.0,
              )),
              const SizedBox(height: 4),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Daily Reminder',
                            style: TextStyle(color: settings.theme.textPrimary, fontSize: 14)),
                            subtitle: Text('Reminder each day to keep your motivation',
                                           style: TextStyle(color: settings.theme.textMuted, fontSize: 11)),
                                           activeThumbColor: settings.theme.primary,
                             value:    settings.dailyNotification,
                             onChanged: (val) async {
                               HapticFeedback.selectionClick();
                               await settings.setDailyNotification(val);
                             },
              ),
              if (settings.dailyNotification)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(children: [
                    Icon(Icons.access_time_rounded, size: 16, color: settings.theme.textMuted),
                    const SizedBox(width: 8),
                    Text('Reminder time',
                         style: TextStyle(fontSize: 13, color: settings.theme.textSecondary)),
                         const Spacer(),
                         GestureDetector(
                           onTap: () async {
                             final picked = await showTimePicker(
                               context: sheetCtx,
                               initialTime: settings.notifTime,
                             );
                             if (picked != null) {
                               HapticFeedback.selectionClick();
                               await settings.setNotifTime(picked);
                             }
                           },
                           child: Container(
                             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                             decoration: BoxDecoration(
                               color:        settings.theme.primary.withValues(alpha: 0.12),
                               borderRadius: BorderRadius.circular(10),
                               border:       Border.all(color: settings.theme.primary.withValues(alpha: 0.3)),
                             ),
                             child: Text(
                               settings.notifTime.format(sheetCtx),
                               style: TextStyle(
                                 fontSize: 14, fontWeight: FontWeight.w600,
                                 color: settings.theme.primary,
                               ),
                             ),
                           ),
                         ),
                  ]),
                ),
                FutureBuilder<bool>(
                  future: GroveBiometrics.instance.isAvailable,
                  builder: (_, snap) {
                    final available = snap.data ?? false;
                    if (!available) return const SizedBox.shrink();
                    return SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Biometric Unlock',
                                  style: TextStyle(color: settings.theme.textPrimary, fontSize: 14)),
                                  subtitle: Text('Require fingerprint / Pin to open Grove',
                                                 style: TextStyle(color: settings.theme.textMuted, fontSize: 11)),
                                                 activeThumbColor: settings.theme.primary,
                                          value:    settings.biometricUnlock,
                                          onChanged: (val) async {
                                            HapticFeedback.selectionClick();
                                            if (val) {
                                              final ok = await GroveBiometrics.instance.authenticate();
                                              if (!ok) return;
                                            }
                                            await settings.setBiometricUnlock(val);
                                          },
                    );
                  },
                ),
                const Divider(height: 32),
                Text('DATA MANAGEMENT', style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700,
                  color: settings.theme.textSecondary, letterSpacing: 1.0,
                )),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _showExportSheet(ctx, model, settings),
                  icon:  const Icon(Icons.upload_outlined, size: 16),
                  label: const Text('Export Grove Backup'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: settings.theme.textPrimary,
                      side:    BorderSide(color: settings.theme.textMuted.withValues(alpha: 0.4)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape:   RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => _showImportSheet(ctx, model, settings),
                  icon:  const Icon(Icons.download_outlined, size: 16),
                  label: const Text('Restore Grove from Backup'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: settings.theme.textPrimary,
                      side:    BorderSide(color: settings.theme.textMuted.withValues(alpha: 0.4)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape:   RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Exports all trees, relapse history, and streak records.\nImporting will replace your current grove — back up is recommend.',
                  style:     TextStyle(fontSize: 10, color: settings.theme.textMuted, height: 1.5),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExportSheet(BuildContext ctx, GroveModel model, GroveSettings settings) {
    final json   = model.exportJson();
    final theme  = settings.theme;
    final copied = ValueNotifier<bool>(false);

    showModalBottomSheet(
      context: ctx, backgroundColor: theme.surfaceHigh,
      isScrollControlled: true, useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(sheetCtx).padding.bottom),
        child: Column(
          mainAxisSize:       MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color:        theme.textMuted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            )),
            const SizedBox(height: 20),
            Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color:        theme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.upload_outlined, color: theme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Grove Backup', style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700, color: theme.textPrimary)),
                  Text(
                    '${model.habits.length} tree${model.habits.length != 1 ? 's' : ''} · ${DateFormat('MMM d, yyyy').format(DateTime.now())}',
                    style: TextStyle(fontSize: 12, color: theme.textSecondary),
                  ),
              ])),
            ]),
            const SizedBox(height: 20),
            Container(
              height: 140, padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:        theme.surface,
                borderRadius: BorderRadius.circular(14),
                border:       Border.all(color: theme.textMuted.withValues(alpha: 0.2)),
              ),
              child: SingleChildScrollView(
                child: SelectableText(json,
                                      style: TextStyle(fontFamily: 'monospace', fontSize: 11,
                                                       color: theme.textSecondary, height: 1.5)),
              ),
            ),
            const SizedBox(height: 8),
            Text('${json.length} characters · Select all to copy manually',
                 style: TextStyle(fontSize: 10, color: theme.textMuted),
                 textAlign: TextAlign.center),
                 const SizedBox(height: 20),
                 ValueListenableBuilder<bool>(
                   valueListenable: copied,
                   builder: (_, isCopied, _) => FilledButton.icon(
                     onPressed: () async {
                       await Clipboard.setData(ClipboardData(text: json));
                       copied.value = true;
                       HapticFeedback.lightImpact();
                       Future.delayed(const Duration(seconds: 3), () => copied.value = false);
                     },
                     icon:  Icon(isCopied ? Icons.check_rounded : Icons.copy_rounded, size: 18),
                     label: Text(isCopied ? 'Copied to Clipboard!' : 'Copy to Clipboard',
                                 style: const TextStyle(fontWeight: FontWeight.w600)),
                                 style: FilledButton.styleFrom(
                                   backgroundColor: isCopied ? GroveTheme.mossGreen : theme.primary,
                                   minimumSize: const Size.fromHeight(52),
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                 ),
                   ),
                 ),
          ],
        ),
      ),
    );
  }

  void _showImportSheet(BuildContext ctx, GroveModel model, GroveSettings settings) {
    final theme      = settings.theme;
    final controller = TextEditingController();
    final isPasting  = ValueNotifier<bool>(false);

    showModalBottomSheet(
      context: ctx, backgroundColor: theme.surfaceHigh,
      isScrollControlled: true, useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24,
                                     24 + math.max(MediaQuery.of(sheetCtx).viewInsets.bottom,
                                     MediaQuery.of(sheetCtx).padding.bottom)),
                                     child: Column(
                                       mainAxisSize:       MainAxisSize.min,
                                       crossAxisAlignment: CrossAxisAlignment.stretch,
                                       children: [
                                         Center(child: Container(
                                           width: 36, height: 4,
                                           decoration: BoxDecoration(
                                             color:        theme.textMuted.withValues(alpha: 0.4),
                                             borderRadius: BorderRadius.circular(2),
                                           ),
                                         )),
                                         const SizedBox(height: 20),
                                         Row(children: [
                                           Container(
                                             width: 40, height: 40,
                                             decoration: BoxDecoration(
                                               color:        GroveTheme.barkBrown.withValues(alpha: 0.15),
                                               borderRadius: BorderRadius.circular(12),
                                             ),
                                             child: const Icon(Icons.download_outlined, color: GroveTheme.barkBrown, size: 20),
                                           ),
                                           const SizedBox(width: 12),
                                           Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                             Text('Restore Grove', style: TextStyle(
                                               fontSize: 17, fontWeight: FontWeight.w700, color: theme.textPrimary)),
                                               Text('Paste your JSON backup below',
                                                    style: TextStyle(fontSize: 12, color: theme.textSecondary)),
                                           ])),
                                         ]),
                                         const SizedBox(height: 16),
                                         Container(
                                           padding: const EdgeInsets.all(12),
                                           decoration: BoxDecoration(
                                             color:        GroveTheme.clayRed.withValues(alpha: 0.08),
                                             borderRadius: BorderRadius.circular(12),
                                             border:       Border.all(color: GroveTheme.clayRed.withValues(alpha: 0.25)),
                                           ),
                                           child: Row(children: [
                                             const Icon(Icons.warning_amber_rounded, size: 16, color: GroveTheme.clayRed),
                                             const SizedBox(width: 8),
                                             Expanded(child: Text(
                                               'This will replace your current grove. Export a backup first if needed.',
                                               style: TextStyle(fontSize: 11, color: theme.textSecondary, height: 1.4),
                                             )),
                                           ]),
                                         ),
                                         const SizedBox(height: 16),
                                         OutlinedButton.icon(
                                           onPressed: () async {
                                             final data = await Clipboard.getData('text/plain');
                                             if (data?.text != null) {
                                               controller.text = data!.text!;
                                               isPasting.value = true;
                                               HapticFeedback.selectionClick();
                                             }
                                           },
                                           icon:  const Icon(Icons.content_paste_rounded, size: 16),
                                           label: const Text('Paste from Clipboard'),
                                           style: OutlinedButton.styleFrom(
                                             foregroundColor: theme.primary,
                                               side:    BorderSide(color: theme.primary.withValues(alpha: 0.5)),
                                               padding: const EdgeInsets.symmetric(vertical: 12),
                                               shape:   RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                           ),
                                         ),
                                         const SizedBox(height: 12),
                                         ValueListenableBuilder<bool>(
                                           valueListenable: isPasting,
                                           builder: (_, hasPasted, _) => TextField(
                                             controller: controller,
                                             minLines:   hasPasted ? 4 : 2,
                                             maxLines:   hasPasted ? 6 : 4,
                                             style:      TextStyle(color: theme.textPrimary, fontSize: 12, fontFamily: 'monospace'),
                                             onChanged:  (_) { if (!isPasting.value) isPasting.value = controller.text.isNotEmpty; },
                                             decoration: InputDecoration(
                                               hintText:  'Or type / paste your Grove JSON backup here…',
                                               hintStyle: TextStyle(color: theme.textMuted, fontSize: 12),
                                               contentPadding: const EdgeInsets.all(12),
                                             ),
                                           ),
                                         ),
                                         const SizedBox(height: 20),
                                         FilledButton.icon(
                                           onPressed: () async {
                                             if (controller.text.trim().isEmpty) {
                                               ScaffoldMessenger.of(sheetCtx).showSnackBar(const SnackBar(
                                                 content:         Text('Nothing to import — paste your JSON first'),
                                                 backgroundColor: GroveTheme.clayRed,
                                                 behavior:        SnackBarBehavior.floating,
                                               ));
                                               return;
                                             }
                                             final success = await model.importFromJson(controller.text);
                                             controller.dispose();
                                             if (!sheetCtx.mounted) return;
                                             Navigator.pop(sheetCtx);
                                             Navigator.pop(sheetCtx);
                                             if (ctx.mounted) {
                                               ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                                                 content: Text(success
                                                 ? '✓ Grove restored — ${model.habits.length} trees loaded'
                                                 : '✗ Invalid backup — check the JSON and try again'),
                                                 backgroundColor: success ? theme.primary : GroveTheme.clayRed,
                                                 behavior:        SnackBarBehavior.floating,
                                               ));
                                             }
                                           },
                                           icon:  const Icon(Icons.restore_rounded, size: 18),
                                           label: const Text('Restore Grove', style: TextStyle(fontWeight: FontWeight.w600)),
                                           style: FilledButton.styleFrom(
                                             backgroundColor: GroveTheme.barkBrown,
                                             minimumSize:     const Size.fromHeight(52),
                                             shape:           RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                           ),
                                         ),
                                       ],
                                     ),
      ),
    );
  }

  Widget _emptyState(GroveTheme theme) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 110, height: 110,
          child: CustomPaint(
            painter: FractalTreePainter(
              stage:       GrowthStage.sprout,
              baseColor:   theme.textMuted,
              progress:    0.6,
              windPhase:   0,
              geneticSeed: 0,
              daysElapsed: 4,
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text('Your grove is bare.',
             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300,
                              color: theme.textMuted, letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  Text('Plant your first tree to begin.',
                       style: TextStyle(fontSize: 13, color: theme.textMuted)),
                       const SizedBox(height: 120),
      ],
    ),
  );

  Widget _fade(GroveTheme theme, {required bool top}) => Positioned(
    top: top ? 0 : null, bottom: top ? null : 0, left: 0, right: 0, height: 130,
    child: IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin:  top ? Alignment.topCenter    : Alignment.bottomCenter,
            end:    top ? Alignment.bottomCenter : Alignment.topCenter,
            colors: [theme.bg, theme.bg.withValues(alpha: 0)],
          ),
        ),
      ),
    ),
  );

  Widget _fab(BuildContext context, GroveTheme theme) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: FloatingActionButton.extended(
      onPressed: () => showModalBottomSheet(
        context:         context,
        isScrollControlled: true,
        backgroundColor: theme.surfaceHigh,
        useSafeArea:     true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        builder: (_) => const AddHabitSheet(),
      ),
      backgroundColor: theme.primary,
      foregroundColor: theme.brightness == Brightness.light ? Colors.white : GroveTheme.dewWhite,
        icon:  const Icon(Icons.forest_rounded),
        label: const Text('Plant a Tree',
                          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
    ),
  );
}

class _AboutLinkTile extends StatelessWidget {
  final IconData   icon;
  final Color      iconColor;
  final String     label;
  final String     sublabel;
  final String     url;
  final GroveTheme theme;

  const _AboutLinkTile({
    required this.icon, required this.iconColor,
    required this.label, required this.sublabel,
    required this.url, required this.theme,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color:        theme.surface,
          borderRadius: BorderRadius.circular(14),
          border:       Border.all(color: theme.textMuted.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color:        iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: theme.textPrimary)),
                    Text(sublabel, style: TextStyle(fontSize: 11, color: theme.textSecondary)),
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
  final String     label;
  final IconData   icon;
  final bool       isSelected;
  final VoidCallback onTap;
  final GroveTheme theme;

  const _LayoutButton({
    required this.label, required this.icon, required this.isSelected,
    required this.onTap, required this.theme,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:  const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:        isSelected ? theme.primary : theme.surface,
            borderRadius: BorderRadius.circular(12),
            border:       Border.all(
              color: isSelected ? theme.primary : theme.textMuted.withValues(alpha: 0.3),
            ),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : theme.textSecondary),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : theme.textPrimary,
            )),
          ]),
        ),
      ),
    ),
  );
}
