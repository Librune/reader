import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SvgBtn extends HookConsumerWidget {
  const SvgBtn({super.key, required this.svgName, this.size = 18});
  final String svgName;
  final double size;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: () {},
      icon: SvgPicture.asset(
        "assets/svg/$svgName.svg",
        colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
        width: size,
      ),
    );
  }
}
