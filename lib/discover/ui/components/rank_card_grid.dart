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
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: colorScheme.surfaceContainerLowest,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset("assets/svg/ic_card_discover.svg", width: 24, height: 24),
                    Spacer(),
                    SvgPicture.asset(
                      "assets/svg/ic_card_right.svg",
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(colorScheme.secondary, BlendMode.srcIn),
                    ),
                  ],
                ),
                Spacer(),
                Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colorScheme.primary)),
                SizedBox(height: 6),
                Text("20 RANKS", style: TextStyle(fontSize: 11, color: colorScheme.secondary, height: 1)),
              ],
            )),
      ),
    );
  }
}
