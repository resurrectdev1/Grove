import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:grove/l10n/app_localizations.dart';
import 'package:grove/providers/grove_settings.dart';
import 'package:grove/theme/grove_theme.dart';

class ColorPickerSheet extends StatefulWidget {
  final Color initialColor;
  final String? title;

  const ColorPickerSheet({super.key, required this.initialColor, this.title});

  @override
  State<ColorPickerSheet> createState() => _ColorPickerSheetState();
}

class _ColorPickerSheetState extends State<ColorPickerSheet> {
  final _hexCtrl = TextEditingController();
  late Color _color;
  bool _validHex = true;

  @override
  void initState() {
    super.initState();
    _color = widget.initialColor;
    _hexCtrl.text = _colorToHex(_color);
  }

  @override
  void dispose() {
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
            Text(
              widget.title ?? l10n.changeColor,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.textPrimary,
              ),
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
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(color: theme.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _validHex
                        ? () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context, _color);
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: _color,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      l10n.save,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
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
}
