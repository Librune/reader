import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

AsyncSnapshot<ColorScheme> useCoverColor(BuildContext context, {required String coverUrl, int time = 0}) {
  final colorScheme = Theme.of(context).colorScheme;
  final brightness = Theme.of(context).brightness;
  final cachedNetWorkImageProvider = CachedNetworkImageProvider(coverUrl);

  return useFuture(
      useMemoized(() async {
        final futures = await Future.wait([
          ColorScheme.fromImageProvider(provider: cachedNetWorkImageProvider, brightness: brightness),
          Future.delayed(Duration(milliseconds: time))
        ]);
        return futures[0] as ColorScheme;
      }, [coverUrl, brightness, time]),
      initialData: colorScheme);
}
