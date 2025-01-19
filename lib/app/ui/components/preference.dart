import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nil/nil.dart';

class PreferenceSection extends HookConsumerWidget {
  const PreferenceSection({
    super.key,
    this.padding,
    required this.title,
    required this.children,
  });
  final String title;
  final List<PereferenceItem> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;
    final _padding = padding ?? EdgeInsets.only(top: 16, left: 16, right: 16);
    return Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 8),
            child: Text(
              title,
              style: typography.labelMedium?.copyWith(color: colorScheme.secondary),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
              color: colorScheme.surface,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: children,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

  Color get _backgroundColor => backgroundColor ?? const Color(0x00000000);
  TextStyle get _titleStyle => titleStyle ?? const TextStyle(fontWeight: FontWeight.w600, fontSize: 14);
  TextStyle _subtitleStyle(ColorScheme colorScheme) =>
      subtitleStyle ?? TextStyle(fontSize: 12, color: colorScheme.onSurface.withAlpha(150));
  //  final subtitleStyle =
  //       this.subtitleStyle ?? typography.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(.6));
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
    final titleStyle = this.titleStyle ?? const TextStyle(fontWeight: FontWeight.w600, fontSize: 14);
    final subtitleStyle =
        this.subtitleStyle ?? typography.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(.6));
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
        subtitle:
            Padding(padding: const EdgeInsets.only(top: 4, right: 8), child: Text(subtitle, style: subtitleStyle)),
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
    final titleStyle = this.titleStyle ?? const TextStyle(fontWeight: FontWeight.w600, fontSize: 14);
    final subtitleStyle =
        this.subtitleStyle ?? typography.bodySmall?.copyWith(color: colorScheme.onSurface.withOpacity(.6));
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
      subtitle: Padding(padding: const EdgeInsets.only(top: 4, right: 8), child: Text(subtitle, style: subtitleStyle)),
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

class PreferenceInput extends PereferenceItem {
  const PreferenceInput({
    super.key,
    required super.title,
    required super.subtitle,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
        tileColor: _backgroundColor,
        title: Text(title, style: _titleStyle),
        subtitle: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 42),
          child: FormBuilderTextField(
            cursorHeight: 18,
            name: name,
            style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
            decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: 14, color: colorScheme.onSurface.withAlpha(150)),
              hintMaxLines: 1,
              isDense: false,
              contentPadding: EdgeInsets.only(left: 2, right: 2, bottom: 2),
              fillColor: Colors.transparent,
              hintText: subtitle,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorScheme.onSurface.withAlpha(50)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorScheme.onSurface.withAlpha(50)),
              ),
            ),
          ),
        ));
  }
}
