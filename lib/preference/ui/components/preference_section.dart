import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'pereference_item.dart';

class PreferenceSection extends HookConsumerWidget {
  const PreferenceSection({
    super.key,
    this.padding,
    required this.title,
    required this.children,
  });
  final String title;
  final List<PereferenceItem> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;
    final _padding = padding ?? EdgeInsets.only(top: 16, left: 16, right: 16);
    return Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 8),
            child: Text(
              title,
              style: typography.labelMedium
                  ?.copyWith(color: colorScheme.secondary),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
              color: colorScheme.surface,
              child: Column(
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
