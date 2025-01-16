import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BookTag extends HookConsumerWidget {
  const BookTag({
    super.key,
    required this.value,
    required this.label,
    this.unit,
    this.colorScheme,
    this.valueFontSize = 16,
    this.labelFontSize = 12,
    this.unitFontSize = 12,
  });
  final String value;
  final String label;
  final String? unit;
  final ColorScheme? colorScheme;
  final double valueFontSize;
  final double labelFontSize;
  final double unitFontSize;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colorScheme = colorScheme ?? Theme.of(context).colorScheme;
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: value,
              style: TextStyle(
                  fontSize: valueFontSize, color: _colorScheme.onSurface.withAlpha(180), fontWeight: FontWeight.bold)),
          if (unit != null)
            TextSpan(
                text: unit, style: TextStyle(fontSize: unitFontSize, color: _colorScheme.onSurface.withAlpha(180))),
          TextSpan(text: "\n \n", style: TextStyle(height: 1, fontSize: 6)),
          TextSpan(
              text: label, style: TextStyle(fontSize: labelFontSize, color: _colorScheme.onSurface.withAlpha(100))),
        ]));
  }
}
