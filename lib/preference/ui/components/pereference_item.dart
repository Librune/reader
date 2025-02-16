import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nil/nil.dart';

abstract class PereferenceItem extends HookConsumerWidget {
  const PereferenceItem(
      {super.key,
      required this.title,
      required this.subtitle,
      this.onTap,
      this.titleStyle,
      this.subtitleStyle,
      this.iconData,
      this.backgroundColor,
      this.suffixIconData,
      this.iconWidget,
      this.suffixIconWidget})
      : assert(
          iconData == null || iconWidget == null,
          "You can only provide either an icon or an iconWidget",
        ),
        assert(
          suffixIconData == null || suffixIconWidget == null,
          "You can only provide either an suffixIcon or an suffixIconWidget",
        );

  final String title;
  final TextStyle? titleStyle;
  final String subtitle;
  final TextStyle? subtitleStyle;
  final VoidCallback? onTap;
  final IconData? iconData;
  final Widget? iconWidget;
  final IconData? suffixIconData;
  final Widget? suffixIconWidget;
  final Color? backgroundColor;
}

class PreferenceTap extends PereferenceItem {
  const PreferenceTap(
      {super.key,
      required super.title,
      required super.subtitle,
      required super.onTap,
      super.titleStyle,
      super.subtitleStyle,
      super.iconData,
      super.backgroundColor,
      super.suffixIconData,
      super.iconWidget,
      super.suffixIconWidget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;
    final bgColor = backgroundColor ?? const Color(0x00000000);
    final titleStyle = this.titleStyle ??
        const TextStyle(fontWeight: FontWeight.w600, fontSize: 14);
    final subtitleStyle = this.subtitleStyle ??
        typography.bodySmall
            ?.copyWith(color: colorScheme.onSurface.withOpacity(.6));
    final icon = iconWidget ??
        (iconData != null
            ? Icon(
                iconData,
                size: 18,
                color: colorScheme.onSurface.withAlpha(153),
              )
            : nil);
    final suffixIcon = suffixIconWidget ??
        (Icon(
          suffixIconData ?? CupertinoIcons.right_chevron,
          size: 18,
          color: colorScheme.onSurface.withAlpha(153),
        ));
    return ListTile(
        tileColor: bgColor,
        horizontalTitleGap: 6,
        minTileHeight: 42,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: icon,
        title: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            title,
            style: titleStyle,
          ),
        ),
        subtitle: Padding(
            padding: const EdgeInsets.only(top: 4, right: 8),
            child: Text(subtitle, style: subtitleStyle)),
        onTap: onTap,
        trailing: suffixIcon);
  }
}

class PreferenceSwitch extends PereferenceItem {
  const PreferenceSwitch(
      {super.key,
      required super.title,
      required super.subtitle,
      super.onTap,
      super.titleStyle,
      super.subtitleStyle,
      super.iconData,
      super.backgroundColor,
      super.suffixIconData,
      super.iconWidget,
      super.suffixIconWidget,
      required this.value,
      required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;
    final bgColor = backgroundColor ?? const Color(0x00000000);
    final titleStyle = this.titleStyle ??
        const TextStyle(fontWeight: FontWeight.w600, fontSize: 14);
    final subtitleStyle = this.subtitleStyle ??
        typography.bodySmall
            ?.copyWith(color: colorScheme.onSurface.withOpacity(.6));
    final icon = iconWidget ??
        (iconData != null
            ? Icon(
                iconData,
                size: 18,
                color: colorScheme.onSurface.withOpacity(.6),
              )
            : nil);

    return ListTile(
      tileColor: bgColor,
      horizontalTitleGap: 6,
      minTileHeight: 42,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: icon,
      title: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Text(
          title,
          style: titleStyle,
        ),
      ),
      subtitle: Padding(
          padding: const EdgeInsets.only(top: 4, right: 8),
          child: Text(subtitle, style: subtitleStyle)),
      onTap: () {
        onChanged(!value);
      },
      trailing: Transform.scale(
        scale: 0.68,
        alignment: Alignment.centerRight,
        child: Switch(
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
