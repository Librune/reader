import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SvgBtn extends HookConsumerWidget {
  const SvgBtn(
      {super.key,
      required this.svgName,
      this.size = 18,
      this.color,
      this.style,
      this.onPressed});
  final String svgName;
  final double size;
  final Color? color;
  final ButtonStyle? style;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final _color = color ?? colorScheme.onSurface;
    return IconButton(
      onPressed: onPressed,
      style: style,
      icon: SvgPicture.asset(
        "assets/svg/$svgName.svg",
        colorFilter: ColorFilter.mode(_color, BlendMode.srcIn),
        width: size,
      ),
    );
  }
}
