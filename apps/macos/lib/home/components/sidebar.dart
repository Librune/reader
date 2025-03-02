import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosSidebarItem extends SidebarItem {
  MacosSidebarItem({required this.labelText, required this.iconName})
    : super(
        selectedColor: MacosColors.tickBackgroundColor,
        leading: SvgPicture.asset(
          "assets/svg/$iconName.svg",
          width: 18,
          colorFilter: ColorFilter.mode(MacosColors.systemGrayColor, BlendMode.srcIn),
        ),
        label: Text(labelText, style: TextStyle(fontSize: 12)),
      );

  final String labelText;
  final String iconName;
}
