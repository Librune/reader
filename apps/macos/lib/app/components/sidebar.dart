import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosSidebarItem extends StatelessWidget {
  const MacosSidebarItem({super.key, required this.label, this.icon, this.section, this.selected});

  final String? icon;
  final String label;
  final bool? section;
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/svg/$icon.svg",
            width: 18,
            colorFilter: ColorFilter.mode(
              section == true ? MacosColors.white.withValues(alpha: .8) : MacosColors.black.withValues(alpha: .4),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 8),
          Text('Home'),
        ],
      ),
    );
  }
}
