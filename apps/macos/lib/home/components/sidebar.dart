import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosSidebarItem extends SidebarItem {
  MacosSidebarItem()
    : super(
        selectedColor: MacosColors.tickBackgroundColor,
        leading: SvgPicture.asset(
          "assets/svg/ic_bottom_books.svg",
          width: 18,
          colorFilter: ColorFilter.mode(MacosColors.placeholderTextColor, BlendMode.srcIn),
        ),
        label: Text('书架', style: TextStyle(fontSize: 13)),
      );
}
