import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RankCard extends HookConsumerWidget {
  const RankCard(
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
          AsyncSnapshot(:final data?) => data.secondaryContainer.withAlpha(125),
          _ => colorScheme.surfaceContainerHigh.withAlpha(50),
        },
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                CachedNetworkImage(imageUrl: favIcon),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: coverScheme.data?.primary ?? colorScheme.primary)),
                    Row(
                      spacing: 10,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: coverScheme.data?.secondaryContainer.withAlpha(255)),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          child: Text("$rankNum个总榜",
                              style:
                                  TextStyle(fontSize: 14, color: coverScheme.data?.secondary ?? colorScheme.secondary)),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: coverScheme.data?.secondaryContainer.withAlpha(255)),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          child: Text("$subRankNum个子榜",
                              style:
                                  TextStyle(fontSize: 14, color: coverScheme.data?.secondary ?? colorScheme.secondary)),
                        )
                      ],
                    )
                  ],
                ),
                Spacer(),
                Center(
                  child: SvgPicture.asset("assets/svg/ic_card_right.svg",
                      colorFilter: ColorFilter.mode(coverScheme.data?.primary ?? colorScheme.primary, BlendMode.srcIn),
                      width: 14),
                )
              ],
            )),
      ),
    );
  }
}
