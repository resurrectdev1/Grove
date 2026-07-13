import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:grove/l10n/app_localizations.dart';
import 'package:grove/models/grove_models.dart';
import 'package:grove/painters/fractal_tree_painter.dart';
import 'package:grove/providers/grove_model.dart';
import 'package:grove/providers/grove_settings.dart';
import 'package:grove/theme/grove_theme.dart';

class AddHabitSheet extends StatefulWidget {
  const AddHabitSheet({super.key});
  @override
  State<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet> {
  final _nameCtrl = TextEditingController();
  final _hexCtrl = TextEditingController();
  Color _color = GroveTheme.treePalette[6];
  bool _validHex = true;
  HabitMode _mode = HabitMode.abstain;

  @override
  void initState() {
    super.initState();
    _hexCtrl.text = _colorToHex(_color);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _hexCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<GroveSettings>().theme;
    final l10n = AppLocalizations.of(context);
    final bottomPad = math.max(
      MediaQuery.of(context).viewInsets.bottom,
      MediaQuery.of(context).padding.bottom,
    );

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
            Center(
              child: SizedBox(
                width: 90,
                height: 90,
                child: CustomPaint(
                  painter: FractalTreePainter(
                    stage: GrowthStage.sprout,
                    baseColor: _color,
                    progress: 0.75,
                    windPhase: 0,
                    geneticSeed: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              l10n.plantANewTree,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameCtrl,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(color: theme.textPrimary),
              decoration: InputDecoration(
                labelText: l10n.habitName,
                hintText: l10n.habitNameHint,
                prefixIcon: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: theme.textMuted,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.trackingMode,
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
                  child: GestureDetector(
                    onTap: () => setState(() => _mode = HabitMode.abstain),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _mode == HabitMode.abstain
                            ? theme.primary.withValues(alpha: 0.12)
                            : theme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _mode == HabitMode.abstain
                              ? theme.primary
                              : theme.textMuted.withValues(alpha: 0.3),
                          width: _mode == HabitMode.abstain ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            size: 22,
                            color: _mode == HabitMode.abstain
                                ? theme.primary
                                : theme.textMuted,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.abstain,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _mode == HabitMode.abstain
                                  ? theme.primary
                                  : theme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.abstainSubtitle1,
                            style: TextStyle(
                              fontSize: 9,
                              color: theme.textMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.abstainSubtitle2,
                            style: TextStyle(
                              fontSize: 9,
                              color: theme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _mode = HabitMode.checkIn),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _mode == HabitMode.checkIn
                            ? theme.primary.withValues(alpha: 0.12)
                            : theme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _mode == HabitMode.checkIn
                              ? theme.primary
                              : theme.textMuted.withValues(alpha: 0.3),
                          width: _mode == HabitMode.checkIn ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 22,
                            color: _mode == HabitMode.checkIn
                                ? theme.primary
                                : theme.textMuted,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.checkIn,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _mode == HabitMode.checkIn
                                  ? theme.primary
                                  : theme.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.checkInSubtitle1,
                            style: TextStyle(
                              fontSize: 9,
                              color: theme.textMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.checkInSubtitle2,
                            style: TextStyle(
                              fontSize: 9,
                              color: theme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                final sel = c == _color;
                return GestureDetector(
                  onTap: () => setState(() {
                    _color = c;
                    _hexCtrl.text = _colorToHex(c);
                    _validHex = true;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: sel ? GroveTheme.dewWhite : Colors.transparent,
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
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
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
                    controller: _hexCtrl,
                    textCapitalization: TextCapitalization.characters,
                    style: TextStyle(color: theme.textPrimary),
                    onChanged: _updateFromHexInput,
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
                      errorText: _validHex ? null : l10n.invalidHex,
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
                    color: _color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.textMuted.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _color.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _plant(l10n),
              icon: const Icon(Icons.forest_rounded, size: 18),
              label: Text(
                l10n.plantTree,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: _color,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateFromHexInput(String value) {
    if (value.isEmpty) return;
    try {
      final hex = value.replaceFirst('#', '');
      if (hex.length != 6) {
        setState(() => _validHex = false);
        return;
      }
      final color = Color(int.parse('FF$hex', radix: 16));
      setState(() {
        _validHex = true;
        _color = color;
      });
    } catch (_) {
      setState(() => _validHex = false);
    }
  }

  String _colorToHex(Color color) {
    final argb = color.toARGB32();
    return argb.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase();
  }

  void _plant(AppLocalizations l10n) {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.giveHabitName)));
      return;
    }
    context.read<GroveModel>().addHabit(name: name, color: _color, mode: _mode);
    HapticFeedback.lightImpact();
    Navigator.pop(context);
  }
}
