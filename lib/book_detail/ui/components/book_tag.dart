import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BookTag extends HookConsumerWidget {
  const BookTag({
    super.key,
    required this.value,
    required this.label,
    this.unit,
    this.colorScheme,
  });
  final String value;
  final String label;
  final String? unit;
  final ColorScheme? colorScheme;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _colorScheme = colorScheme ?? Theme.of(context).colorScheme;
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: value,
              style:
                  TextStyle(fontSize: 14, color: _colorScheme.onSurface.withAlpha(180), fontWeight: FontWeight.bold)),
          TextSpan(text: "\n \n", style: TextStyle(height: 1, fontSize: 6)),
          TextSpan(text: label, style: TextStyle(fontSize: 12, color: _colorScheme.onSurface.withAlpha(100))),
        ]));
  }
}
