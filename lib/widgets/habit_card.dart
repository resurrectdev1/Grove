import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:grove/l10n/app_localizations.dart';
import 'package:grove/models/grove_models.dart';
import 'package:grove/providers/grove_model.dart';
import 'package:grove/providers/grove_settings.dart';
import 'package:grove/screens/habit_detail_screen.dart';
import 'package:grove/theme/grove_theme.dart';
import 'package:grove/widgets/animated_tree_widget.dart';
import 'package:grove/widgets/color_picker_sheet.dart';
import 'package:grove/widgets/relapse_dialog.dart';

class HabitCard extends StatefulWidget {
  final HabitTree  habit;
  final bool       isSelected;
  final LayoutMode layoutMode;
  const HabitCard({super.key, required this.habit, required this.isSelected, required this.layoutMode});
  @override State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {

  @override
  Widget build(BuildContext context) {
    final model        = context.read<GroveModel>();
    final settings     = context.watch<GroveSettings>();
    final theme        = settings.theme;
    final l10n         = AppLocalizations.of(context);
    final habit        = widget.habit;
    final days         = habit.daysElapsed;
    final stage        = habit.stage;
    final relapseCount = habit.relapses.length;
    final isCompact    = widget.layoutMode == LayoutMode.compactGrid;
    final isList       = widget.layoutMode == LayoutMode.compactList;
    final isCheckIn    = habit.mode == HabitMode.checkIn;
    final isCheckedIn  = isCheckIn && habit.checkedInToday;

    String stageLabelLocalized(GrowthStage s) => switch (s) {
      GrowthStage.seed      => l10n.stageSeed,
      GrowthStage.sprout    => l10n.stageSprout,
      GrowthStage.sapling   => l10n.stageSapling,
      GrowthStage.youngTree => l10n.stageYoungTree,
      GrowthStage.groveTree => l10n.stageGroveTree,
    };

    String stageTaglineLocalized(GrowthStage s) => switch (s) {
      GrowthStage.seed      => l10n.taglineSeed,
      GrowthStage.sprout    => l10n.taglineSprout,
      GrowthStage.sapling   => l10n.taglineSapling,
      GrowthStage.youngTree => l10n.taglineYoungTree,
      GrowthStage.groveTree => l10n.taglineGroveTree,
    };

    if (isList) {
      return GestureDetector(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.cardBg, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: habit.color.withValues(alpha: 0.3)),
          ),
          child: Row(children: [
            GestureDetector(
              onTap: () => _goDetail(context),
              child: SizedBox(width: 60, height: 60, child: AnimatedTreeWidget(habit: habit)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(habit.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: theme.textPrimary)),
                   const SizedBox(height: 4),
                   Row(children: [
                     Container(
                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                       decoration: BoxDecoration(
                         color: habit.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                         child: Text(stageLabelLocalized(stage),
                         style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: habit.color)),
                     ),
                     const SizedBox(width: 6),
                     Text(l10n.dayCount(days), style: TextStyle(fontSize: 12, color: theme.textSecondary)),
                   ]),
            ])),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => _goDetail(context),
              child: Icon(Icons.calendar_month_outlined, size: 20, color: theme.textSecondary),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => isCheckIn
              ? _handleCheckIn(context, model, habit)
              : _showRelapseDialog(context, model),
              child: Icon(
                isCheckIn
                ? (isCheckedIn ? Icons.check_circle : Icons.check_circle_outline)
                : Icons.refresh_rounded,
                size: 20,
                color: isCheckIn
                ? (isCheckedIn ? habit.color : theme.textMuted)
                : GroveTheme.clayRed,
              ),
            ),
            const SizedBox(width: 6),
            _OptionsMenuButton(
              habit: habit, theme: theme, l10n: l10n,
              onRename: () => _showRenameDialog(context, habit, theme, l10n),
              onChangeColor: () => _showColorPickerSheet(context, habit, theme, l10n),
              onDelete: () => _showDeleteDialog(context, habit, theme, l10n),
              iconSize: 18,
            ),
          ]),
        ),
      );
    }

    return GestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic,
        margin:   isCompact ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
        padding:  EdgeInsets.all(isCompact ? 10 : 0),
        decoration: BoxDecoration(
          color:        theme.cardBg,
          borderRadius: BorderRadius.circular(isCompact ? 22 : 28),
          border: Border.all(
            color: widget.isSelected ? habit.color.withValues(alpha: 0.45) : theme.surfaceHigh,
            width: widget.isSelected ? 1.5 : 1.0,
          ),
          boxShadow: widget.isSelected && !isCompact
          ? [BoxShadow(color: habit.color.withValues(alpha: 0.18), blurRadius: 32, spreadRadius: 2)]
          : [],
        ),
        child: Stack(
          children: [
            Positioned(
              top: isCompact ? 8 : 14,
              right: isCompact ? 8 : 14,
              child: _OptionsMenuButton(
                habit: habit, theme: theme, l10n: l10n,
                onRename: () => _showRenameDialog(context, habit, theme, l10n),
                onChangeColor: () => _showColorPickerSheet(context, habit, theme, l10n),
                onDelete: () => _showDeleteDialog(context, habit, theme, l10n),
                iconSize: isCompact ? 16 : 20,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _goDetail(context),
                  child: Hero(
                    tag: 'tree_${habit.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        width:  isCompact ? 112 : 175,
                        height: isCompact ? 112 : 175,
                        child:  AnimatedTreeWidget(habit: habit),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: isCompact ? 4 : 10),
                Text(habit.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                     style: TextStyle(fontSize: isCompact ? 15 : 22, fontWeight: FontWeight.w700,
                                      color: theme.textPrimary, letterSpacing: 0.3)),
                                      SizedBox(height: isCompact ? 2 : 6),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: isCompact ? 8 : 10, vertical: isCompact ? 1 : 3),
                                            decoration: BoxDecoration(
                                              color: habit.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                                              child: Text(stageLabelLocalized(stage), style: TextStyle(
                                                fontSize: isCompact ? 9 : 11, fontWeight: FontWeight.w600, color: habit.color,
                                                letterSpacing: isCompact ? 0.5 : 0.8)),
                                          ),
                                          SizedBox(width: isCompact ? 6 : 8),
                                          Text(l10n.dayCount(days), style: TextStyle(
                                            fontSize:   isCompact ? 11 : 13,
                                            fontWeight: isCompact ? FontWeight.w600 : FontWeight.normal,
                                            color:      theme.textSecondary)),
                                        ],
                                      ),
                                      if (!isCompact) ...[
                                        const SizedBox(height: 4),
                                        Text(isCheckIn
                                        ? isCheckedIn ? l10n.alreadyCheckedInToday : l10n.tapBelowToCheckIn
                                        : stageTaglineLocalized(stage),
                                        style: TextStyle(fontSize: 11, color: theme.textMuted, fontStyle: FontStyle.italic),
                                        textAlign: TextAlign.center),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            _OutlineAction(icon: Icons.calendar_month_outlined,
                                                           label: isCheckIn
                                                           ? l10n.historyCount(habit.checkInDays.length)
                                                           : (relapseCount > 0 ? l10n.historyCount(relapseCount) : l10n.history),
                                                           color: theme.textSecondary, onTap: () => _goDetail(context)),
                                                           const SizedBox(width: 10),
                                                           if (isCheckIn)
                                                             _OutlineAction(
                                                               icon: isCheckedIn ? Icons.check_circle : Icons.check_circle_outline,
                                                               label: isCheckedIn ? l10n.checkedIn : l10n.checkIn,
                                                               color: isCheckedIn ? habit.color : habit.color,
                                                               onTap: () => _handleCheckIn(context, model, habit),
                                                             )
                                                             else
                                                               _OutlineAction(icon: Icons.refresh_rounded, label: l10n.relapse,
                                                                              color: GroveTheme.clayRed, onTap: () => _showRelapseDialog(context, model)),
                                          ],
                                        ),
                                      ] else ...[
                                        const SizedBox(height: 12),
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                          IconButton(icon: Icon(Icons.calendar_month_outlined, size: 16, color: theme.textSecondary),
                                          onPressed: () => _goDetail(context), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                                          if (isCheckIn)
                                            IconButton(
                                              icon: Icon(
                                                isCheckedIn ? Icons.check_circle : Icons.check_circle_outline,
                                                size: 16,
                                                color: isCheckedIn ? habit.color : theme.textMuted),
                                                onPressed: () => _handleCheckIn(context, model, habit),
                                                padding: EdgeInsets.zero, constraints: const BoxConstraints())
                                            else
                                              IconButton(icon: const Icon(Icons.refresh_rounded, size: 16, color: GroveTheme.clayRed),
                                              onPressed: () => _showRelapseDialog(context, model), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                                        ]),
                                      ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleCheckIn(BuildContext ctx, GroveModel model, HabitTree habit) {
    HapticFeedback.mediumImpact();
    model.toggleCheckIn(habit.id);
  }

  void _goDetail(BuildContext ctx) => Navigator.push(ctx,
  PageRouteBuilder(
    pageBuilder: (_, anim, _) => FadeTransition(opacity: anim, child: HabitDetailScreen(habitId: widget.habit.id)),
    transitionDuration: const Duration(milliseconds: 400),
  ),
  );

  void _showRelapseDialog(BuildContext ctx, GroveModel model) => showDialog(
    context: ctx,
    builder: (_) => RelapseDialog(
      habitName: widget.habit.name,
      onCustomRelapseConfirm: (reason, date) {
        model.recordCustomRelapse(widget.habit.id, reason, date);
        HapticFeedback.mediumImpact();
      },
    ),
  );

  void _showRenameDialog(BuildContext ctx, HabitTree habit, GroveTheme theme, AppLocalizations l10n) {
    final ctrl = TextEditingController(text: habit.name);
    showDialog(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: theme.surfaceHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.renameHabit, style: TextStyle(color: theme.textPrimary, fontWeight: FontWeight.w700)),
        content: TextField(
          controller:         ctrl,
          autofocus:          true,
          textCapitalization: TextCapitalization.words,
          style:              TextStyle(color: theme.textPrimary),
          decoration: InputDecoration(
            labelText:  l10n.habitName,
            prefixIcon: Icon(Icons.edit_outlined, size: 18, color: theme.textMuted),
          ),
          onSubmitted: (val) {
            final trimmed = val.trim();
            if (trimmed.isNotEmpty) {
              ctx.read<GroveModel>().renameHabit(habit.id, trimmed);
              HapticFeedback.lightImpact();
            }
            Navigator.pop(dialogCtx);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(l10n.cancel, style: TextStyle(color: theme.textSecondary)),
          ),
          FilledButton(
            onPressed: () {
              final trimmed = ctrl.text.trim();
              if (trimmed.isNotEmpty) {
                ctx.read<GroveModel>().renameHabit(habit.id, trimmed);
                HapticFeedback.lightImpact();
              }
              Navigator.pop(dialogCtx);
            },
            style: FilledButton.styleFrom(
              backgroundColor: habit.color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showColorPickerSheet(BuildContext ctx, HabitTree habit, GroveTheme theme, AppLocalizations l10n) async {
    final picked = await showModalBottomSheet<Color>(
      context: ctx,
      backgroundColor: theme.surfaceHigh,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => ColorPickerSheet(initialColor: habit.color, title: l10n.changeColor),
    );
    if (picked != null) {
      ctx.read<GroveModel>().updateHabitColor(habit.id, picked);
      HapticFeedback.lightImpact();
    }
  }

  void _showDeleteDialog(BuildContext ctx, HabitTree habit, GroveTheme theme, AppLocalizations l10n) {
    showDialog(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: theme.surfaceHigh,
        shape:   RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title:   Text(l10n.deleteHabit, style: TextStyle(color: theme.textPrimary, fontWeight: FontWeight.w700)),
        content: Text(l10n.deleteHabitConfirm(habit.name), style: TextStyle(color: theme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogCtx),
          child: Text(l10n.cancel, style: TextStyle(color: theme.textSecondary))),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              ctx.read<GroveModel>().deleteHabit(habit.id);
              HapticFeedback.heavyImpact();
            },
            style: FilledButton.styleFrom(backgroundColor: GroveTheme.clayRed),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}

class _OptionsMenuButton extends StatelessWidget {
  final HabitTree habit; final GroveTheme theme; final AppLocalizations l10n;
  final VoidCallback onRename; final VoidCallback onChangeColor; final VoidCallback onDelete; final double iconSize;
  const _OptionsMenuButton({
    required this.habit, required this.theme, required this.l10n,
    required this.onRename, required this.onChangeColor, required this.onDelete, this.iconSize = 20,
  });

  Future<void> _openMenu(BuildContext context) async {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset topLeft = button.localToGlobal(Offset.zero, ancestor: overlay);
    final RelativeRect position = RelativeRect.fromLTRB(
      topLeft.dx, topLeft.dy + button.size.height,
      overlay.size.width - topLeft.dx - button.size.width,
      0,
    );
    final value = await showMenu<String>(
      context: context,
      position: position,
      color: theme.surfaceHigh,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      items: [
        PopupMenuItem(
          value: 'rename',
          child: Row(children: [
            Icon(Icons.edit_outlined, size: 18, color: theme.textPrimary),
            const SizedBox(width: 10),
            Text(l10n.renameHabit, style: TextStyle(color: theme.textPrimary)),
          ]),
        ),
        PopupMenuItem(
          value: 'color',
          child: Row(children: [
            Container(width: 18, height: 18, decoration: BoxDecoration(color: habit.color, shape: BoxShape.circle)),
            const SizedBox(width: 10),
            Text(l10n.changeColor, style: TextStyle(color: theme.textPrimary)),
          ]),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(children: [
            const Icon(Icons.delete_outline, size: 18, color: GroveTheme.clayRed),
            const SizedBox(width: 10),
            Text(l10n.deleteHabitPermanently, style: const TextStyle(color: GroveTheme.clayRed)),
          ]),
        ),
      ],
    );
    if (value == null) return;
    HapticFeedback.selectionClick();
    switch (value) {
      case 'rename': onRename(); break;
      case 'color': onChangeColor(); break;
      case 'delete': onDelete(); break;
    }
  }

  @override
  Widget build(BuildContext context) => Builder(
    builder: (ctx) => GestureDetector(
      onTap: () => _openMenu(ctx),
      child: Icon(Icons.more_vert_rounded, size: iconSize, color: theme.textSecondary),
    ),
  );
}

class _OutlineAction extends StatelessWidget {
  final IconData icon; final String label; final Color color; final VoidCallback onTap;
  const _OutlineAction({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(border: Border.all(color: color.withValues(alpha: 0.35)), borderRadius: BorderRadius.circular(22)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: color), const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
      ]),
    ),
  );
}
