import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RankCardGrid extends HookConsumerWidget {
  const RankCardGrid(
      {super.key, required this.favIcon, required this.name, required this.rankNum, required this.subRankNum});
  final String favIcon;
  final String name;
  final int rankNum;
  final int subRankNum;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final cachedNetWorkImageProvider = CachedNetworkImageProvider(favIcon);
    final coverScheme = useFuture(useMemoized(
        () => ColorScheme.fromImageProvider(provider: cachedNetWorkImageProvider, brightness: brightness),
        [favIcon, brightness]));
    return SizedBox(
      height: 84,
      child: Card.filled(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: switch (coverScheme) {
          AsyncSnapshot(:final data?) => data.secondaryContainer.withAlpha(80),
          _ => colorScheme.surfaceContainerHigh.withAlpha(50),
        },
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Text(name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: coverScheme.data?.primary ?? colorScheme.primary)),
                  ],
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          spacing: 6,
                          children: [
                            Text("$rankNum",
                                style: TextStyle(
                                    fontSize: 26, color: coverScheme.data?.secondary ?? colorScheme.secondary)),
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                "总榜",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: coverScheme.data?.onSurface.withAlpha(180) ?? colorScheme.secondary),
                              ),
                            )
                          ],
                        ),
                        Row(
                          spacing: 6,
                          children: [
                            Text("$subRankNum",
                                style: TextStyle(
                                    fontSize: 28, color: coverScheme.data?.secondary ?? colorScheme.secondary)),
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                "子榜",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: coverScheme.data?.onSurface.withAlpha(180) ?? colorScheme.secondary),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 4),
                      width: 32,
                      height: 32,
                      child: ClipOval(
                        child: CachedNetworkImage(imageUrl: favIcon),
                      ),
                    ),
                  ],
                ))
              ],
            )),
      ),
    );
  }
}
