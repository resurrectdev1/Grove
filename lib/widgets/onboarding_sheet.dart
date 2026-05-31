import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:grove/providers/grove_settings.dart';
import 'package:grove/theme/grove_theme.dart';
import 'package:grove/widgets/animated_tree_widget.dart';
import 'package:grove/models/grove_models.dart';

class OnboardingSheet extends StatefulWidget {
  const OnboardingSheet({super.key});
  @override State<OnboardingSheet> createState() => _OnboardingSheetState();
}

class _OnboardingSheetState extends State<OnboardingSheet> {
  int _page = 0;

  static const _steps = [
    _OnboardingStep(
      icon:      Icons.waving_hand_rounded,
      title:     'Welcome to Grove 🌿',
      body:      'A private sobriety and habit tracker where trees represent your growth, '
    'the longer you stay clean, the more vibrant and lush your trees become.',
    treeStage: GrowthStage.seed,
    treeColor: GroveTheme.mossGreen,
    ),
    _OnboardingStep(
      icon:      Icons.forest_rounded,
      title:     'Plant a Tree',
      body:      'Tap "Plant a Tree" to create a habit. Give it a name, pick a colour, '
    'and Grove generates a unique tree just for it. Each one grows differently.',
    treeStage: GrowthStage.sprout,
    treeColor: GroveTheme.mossGreen,
    ),
    _OnboardingStep(
      icon:      Icons.show_chart_rounded,
      title:     'Watch It Grow',
      body:      'Every day clean helps your tree mature through five growth stages. '
    'from a tiny seed all the way to a full grove tree with swaying branches and leaves.',
    treeStage: GrowthStage.sapling,
    treeColor: GroveTheme.mossGreen,
    ),
    _OnboardingStep(
      icon:      Icons.refresh_rounded,
      title:     'Log a Relapse',
      body:      'If you slip up, record it honestly. Grove tracks your longest streaks and history, '
    'so your progress is never erased.',
    treeStage: GrowthStage.youngTree,
    treeColor: GroveTheme.clayRed,
    ),
    _OnboardingStep(
      icon:      Icons.calendar_month_outlined,
      title:     'Your History',
      body:      'Open any tree to explore calendars, milestones, streak history, relapse notes, '
    'and insights into your long-term consistency.',
    treeStage: GrowthStage.groveTree,
    treeColor: GroveTheme.mossGreen,
    ),
    _OnboardingStep(
      icon:      Icons.lock_outline_rounded,
      title:     'Fully Private',
      body:      'Everything stays on your device. Nothing is ever sent anywhere. '
    'Back up or move your grove anytime via Export / Import in Settings. '
    'Now go grow something worth keeping. 🌱',
    treeStage: GrowthStage.groveTree,
    treeColor: GroveTheme.mossGreen,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme     = context.watch<GroveSettings>().theme;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final step      = _steps[_page];
    final isLast    = _page == _steps.length - 1;

    return Container(
      decoration: BoxDecoration(
        color:        theme.surfaceHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(28, 28, 28, 28 + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36, height: 4,
            decoration: BoxDecoration(
              color:        theme.textMuted.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 28),
          if (_page != 0) ...[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
              child: SizedBox(
                key: ValueKey(_page),
                width: 120, height: 120,
                child: AnimatedTreeWidget(
                  habit: HabitTree(
                    id:          'onboarding_preview_$_page',
                    name:        'preview',
                    color:       step.treeColor,
                    startDate:   DateTime.now().subtract(Duration(days: _treeDaysForStage(step.treeStage))),
                    lastReset:   DateTime.now().subtract(Duration(days: _treeDaysForStage(step.treeStage))),
                    geneticSeed: _page == 4 ? 2 * 137 : _page == 5 ? 4 * 137 : _page * 137,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ] else
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              step.title,
              key:       ValueKey('title_$_page'),
              style:     TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: theme.textPrimary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              step.body,
              key:       ValueKey('body_$_page'),
              style:     TextStyle(fontSize: 14, color: theme.textSecondary, height: 1.65),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_steps.length, (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin:   const EdgeInsets.symmetric(horizontal: 3),
              width:    i == _page ? 18 : 6, height: 6,
              decoration: BoxDecoration(
                color:        i == _page ? theme.primary : theme.textMuted.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(3),
              ),
            )),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              if (_page > 0) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _page--),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.textSecondary,
                        side:            BorderSide(color: theme.textMuted.withValues(alpha: 0.4)),
                        minimumSize:     const Size.fromHeight(50),
                        shape:           RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                flex: _page > 0 ? 2 : 1,
                child: FilledButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    if (isLast) {
                      Navigator.pop(context);
                    } else {
                      setState(() => _page++);
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: isLast ? GroveTheme.mossGreen : theme.primary,
                    minimumSize:     const Size.fromHeight(50),
                    shape:           RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    isLast ? 'Start Growing 🌱' : 'Next',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _treeDaysForStage(GrowthStage s) {
    switch (s) {
      case GrowthStage.seed:      return 0;
      case GrowthStage.sprout:    return 4;
      case GrowthStage.sapling:   return 15;
      case GrowthStage.youngTree: return 60;
      case GrowthStage.groveTree: return 120;
    }
  }
}

class _OnboardingStep {
  final IconData    icon;
  final String      title;
  final String      body;
  final GrowthStage treeStage;
  final Color       treeColor;
  const _OnboardingStep({
    required this.icon, required this.title, required this.body,
    required this.treeStage, required this.treeColor,
  });
}
