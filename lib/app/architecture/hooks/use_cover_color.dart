import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

AsyncSnapshot<ColorScheme> useCoverColor(
  BuildContext context, {
  required String coverUrl,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final brightness = Theme.of(context).brightness;
  final cachedNetWorkImageProvider = CachedNetworkImageProvider(coverUrl);
  return useFuture(
      useMemoized(() => ColorScheme.fromImageProvider(provider: cachedNetWorkImageProvider, brightness: brightness),
          [coverUrl, brightness]),
      initialData: colorScheme);
}
