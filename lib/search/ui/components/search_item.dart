import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/theme/text.dart';

class BookSearchItem extends HookConsumerWidget {
  const BookSearchItem({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        spacing: 14,
        children: [
          CachedNetworkImage(
            imageUrl:
                "https://s3proxy.cdn-zlib.sk/covers400/collections/userbooks/e16fa36143dbe6a456b3d00bc17a18bb8f85dffa01fba1e4ed4335519049fb78.jpg",
            width: 64,
            height: 86,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 76),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "杀死一只知更鸟",
                          style: textTheme.titleSmall,
                        ),
                        Spacer(),
                        Text(
                          "🌟 8.7",
                          style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Text(
                            "Harper Lee",
                            style: textTheme.bodyMedium?.copyWith(color: colorScheme.secondary),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text("九九藏书网 · 严肃文学", style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary)),
                        VerticalDivider(),
                        Text("共 12 万字", style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary))
                      ],
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
