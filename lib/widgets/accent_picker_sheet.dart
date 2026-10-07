import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grove/l10n/app_localizations.dart';
import 'package:grove/providers/grove_settings.dart';
import 'package:grove/theme/grove_theme.dart';

class AccentPickerResult {
  final Color? color;
  const AccentPickerResult(this.color);
}

String _hexOf(Color color) => color
    .toARGB32()
    .toRadixString(16)
    .padLeft(8, '0')
    .substring(2)
    .toUpperCase();

class _HexInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text
        .replaceAll(RegExp(r'[^0-9a-fA-F]'), '')
        .toUpperCase();
    if (text.length > 6) text = text.substring(0, 6);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

Color _onColor(Color c) =>
    ThemeData.estimateBrightnessForColor(c) == Brightness.light
    ? Colors.black87
    : Colors.white;

class AccentPickerSheet extends StatefulWidget {
  final GroveSettings settings;
  const AccentPickerSheet({super.key, required this.settings});

  @override
  State<AccentPickerSheet> createState() => _AccentPickerSheetState();
}

class _AccentPickerSheetState extends State<AccentPickerSheet> {
  late final TextEditingController _hexCtrl;
  late Color _color;
  bool _hexComplete = true;

  @override
  void initState() {
    super.initState();
    _color = widget.settings.customAccent ?? widget.settings.theme.primary;
    _hexCtrl = TextEditingController(text: _hexOf(_color));
  }

  @override
  void dispose() {
    _hexCtrl.dispose();
    super.dispose();
  }

  void _onHexChanged(String value) {
    final complete = value.length == 6;
    setState(() {
      _hexComplete = complete;
      if (complete) _color = Color(int.parse('FF$value', radix: 16));
    });
  }

  void _selectPreset(Color c) {
    HapticFeedback.selectionClick();
    setState(() {
      _color = c;
      _hexCtrl.text = _hexOf(c);
      _hexComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.settings.theme;
    final l10n = AppLocalizations.of(context);
    final mq = MediaQuery.of(context);
    final bottomPad = math.max(mq.viewInsets.bottom, mq.viewPadding.bottom);
    final showError = !_hexComplete && _hexCtrl.text.isNotEmpty;

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
                final sel = c.toARGB32() == _color.toARGB32();
                return GestureDetector(
                  onTap: () => _selectPreset(c),
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
                        ? Icon(Icons.check, color: _onColor(c), size: 18)
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _hexCtrl,
                    textCapitalization: TextCapitalization.characters,
                    autocorrect: false,
                    enableSuggestions: false,
                    keyboardType: TextInputType.visiblePassword,
                    style: TextStyle(color: theme.textPrimary),
                    inputFormatters: [_HexInputFormatter()],
                    onChanged: _onHexChanged,
                    decoration: InputDecoration(
                      labelText: l10n.hexCode,
                      prefixText: '#',
                      prefixStyle: TextStyle(color: theme.textSecondary),
                      hintText: _hexOf(GroveTheme.mossGreen),
                      prefixIcon: Icon(
                        Icons.palette_outlined,
                        size: 18,
                        color: theme.textMuted,
                      ),
                      errorText: showError ? l10n.invalidHex : null,
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
            FilledButton(
              onPressed: _hexComplete
                  ? () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context, AccentPickerResult(_color));
                    }
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: _color,
                foregroundColor: _onColor(_color),
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
            if (widget.settings.customAccent != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context, const AccentPickerResult(null));
                },
                child: Text(
                  l10n.resetAccentDefault,
                  style: TextStyle(color: theme.textMuted, fontSize: 13),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Future<AccentPickerResult?> showAccentPickerSheet(
  BuildContext context,
  GroveSettings settings,
) {
  return showModalBottomSheet<AccentPickerResult>(
    context: context,
    backgroundColor: settings.theme.surfaceHigh,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => AccentPickerSheet(settings: settings),
  );
}
