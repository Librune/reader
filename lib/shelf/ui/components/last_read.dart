import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LastRead extends HookConsumerWidget {
  const LastRead({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final textTheme = Theme.of(context).textTheme;
    final coverUrl =
        "https://s3proxy.cdn-zlib.sk/covers400/collections/userbooks/191d6353def0e77dc46397273292afa8009c0730ce8fd307a38f6b26fa624208.jpg";
    final cachedNetWorkImageProvider = CachedNetworkImageProvider(coverUrl);
    final colorSchemeFuture = useMemoized(
        () => ColorScheme.fromImageProvider(
            provider: cachedNetWorkImageProvider, brightness: brightness),
        [coverUrl, brightness]);
    final coverScheme = useFuture(colorSchemeFuture);
    return Card.filled(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 0),
      color: switch (coverScheme) {
        AsyncSnapshot(:final data?) => data.tertiary.withAlpha(50),
        _ => colorScheme.tertiary.withAlpha(50),
      },
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(12),
      // ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.only(top: 4, bottom: 4),
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("恶意",
                      style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Text("东野圭吾\t\t双叶社",
                        style: textTheme.bodySmall?.copyWith(
                            color: switch (coverScheme) {
                          AsyncSnapshot(:final data?) =>
                            data.onSurface.withAlpha(180),
                          _ => colorScheme.onSurface.withAlpha(180),
                        })),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: Text("最近阅读：第 1 章",
                        style: textTheme.bodySmall?.copyWith(
                            color: switch (coverScheme) {
                          AsyncSnapshot(:final data?) =>
                            data.onSurface.withAlpha(180),
                          _ => colorScheme.onSurface.withAlpha(180),
                        })),
                  ),
                  LinearProgressIndicator(
                    value: 0.1,
                    borderRadius: BorderRadius.circular(12),
                    backgroundColor: switch (coverScheme) {
                      AsyncSnapshot(:final data?) =>
                        data.tertiary.withAlpha(100),
                      _ => colorScheme.tertiary.withAlpha(50),
                    },
                    valueColor: AlwaysStoppedAnimation(switch (coverScheme) {
                      AsyncSnapshot(:final data?) =>
                        data.tertiary.withAlpha(250),
                      _ => colorScheme.tertiary.withAlpha(50),
                    }),
                  )
                ],
              ),
            )),
            Padding(
              padding: EdgeInsets.only(left: 24),
              child:
                  // image from provider
                  Image(
                image: cachedNetWorkImageProvider,
                width: 60,
                height: 82,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}
