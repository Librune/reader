import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShelfPreference extends HookConsumerWidget {
  const ShelfPreference({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: Row(
        children: [
          Text(
            "刺猬猫阅读",
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
