import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RankCardGrid extends HookConsumerWidget {
  const RankCardGrid({
    super.key,
    required this.name,
  });
  final String name;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 84,
      child: Card.outlined(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colorScheme.surfaceContainerLowest,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colorScheme.primary)),
                  ],
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [],
                ))
              ],
            )),
      ),
    );
  }
}
