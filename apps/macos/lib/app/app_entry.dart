import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:reader/app/transparent_app.dart';

class AppEntry extends StatefulHookConsumerWidget {
  const AppEntry(this.navigationShell, {super.key, required this.items});

  final StatefulNavigationShell navigationShell;
  final List<MacosSidebarItem> items;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppEntryState();
}

class _AppEntryState extends ConsumerState<AppEntry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 1), backgroundBlendMode: BlendMode.clear),
      child: Stack(
        children: [
          Positioned(
            left: 12,
            top: 20,
            bottom: 12,
            child: LayoutBuilder(
              builder: (context, constraints) {
                int i = -1;
                return Column(
                  children: [
                    for (final item in widget.items)
                      (() {
                        if (!item.section) i++;
                        int index = i;
                        return GestureDetector(
                          child: Container(
                            width: 176,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            margin: item.section ? EdgeInsets.only(top: 16, bottom: 2) : null,
                            height: item.section ? 24 : 36,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color:
                                  (i == widget.navigationShell.currentIndex && item.section != true)
                                      ? MacosColors.systemGrayColor.withValues(alpha: .16)
                                      : null,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                if (item.icon != null)
                                  RepaintBoundary(
                                    child: SvgPicture.asset(
                                      "assets/svg/${item.icon}.svg",
                                      width: 18,
                                      colorFilter: ColorFilter.mode(
                                        MacosColors.black.withValues(alpha: .4),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                if (item.icon != null) SizedBox(width: 8),
                                Text(
                                  item.label,
                                  style:
                                      item.section
                                          ? TextStyle(fontSize: 12, color: MacosColors.systemGrayColor)
                                          : TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            widget.navigationShell.goBranch(
                              index,
                              initialLocation: index == widget.navigationShell.currentIndex,
                            );
                          },
                        );
                      })(),
                  ],
                );
              },
            ),
          ),

          Positioned.fill(
            left: 206,
            top: 12,
            right: 12,
            bottom: 12,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .1),
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(10.0),
                child: widget.navigationShell,
              ),
            ),
          ),
        ],
      ),

      // MacosWindow(
      //   backgroundColor: MacosColors.transparent,
      //   sidebar: Sidebar(
      //     minWidth: 200,
      //     topOffset: 46,
      //     isResizable: false,
      //     // decoration: const BoxDecoration(color: Color(0xffebebea)),
      //     top: MacosSearchField(
      //       decoration: BoxDecoration(
      //         color: MacosColors.secondaryLabelColor.darkColor,
      //         borderRadius: BorderRadius.circular(7.0),
      //       ),
      //       focusedDecoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(7.0))),
      //     ),
      //     builder: (context, scrollController) {
      //       return SidebarItems(
      //         currentIndex: widget.navigationShell.currentIndex,
      //         onChanged: (index) {
      //           widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);
      //         },
      //         items: _getItems(widget.navigationShell.currentIndex),
      //       );
      //     },
      //   ),
      //   // endSidebar: Sidebar(
      //   //   startWidth: 200,
      //   //   minWidth: 200,
      //   //   maxWidth: 300,
      //   //   shownByDefault: false,
      //   //   builder: (context, _) {
      //   //     return const Center(child: Text('End Sidebar'));
      //   //   },
      //   // ),
      //   // child: widget.navigationShell,
      //   child: Container(),
      // ),
    );
  }

  // _getItems(int index) {
  //   int start = 0;
  //   List<SidebarItem> items = [];
  //   for (var item in widget.items) {
  //     if (item.section == true) {
  //       items.add(SidebarItem(label: Text(item.label), section: true));
  //     } else {
  //       items.add(
  //         SidebarItem(
  //           selectedColor: MacosColors.gridColor.withValues(alpha: .8),
  //           leading: SvgPicture.asset(
  //             "assets/svg/${item.icon}.svg",
  //             width: 18,
  //             colorFilter: ColorFilter.mode(
  //               start == index ? MacosColors.white.withValues(alpha: .8) : MacosColors.black.withValues(alpha: .4),
  //               BlendMode.srcIn,
  //             ),
  //           ),
  //           label: Text(item.label, style: TextStyle(fontSize: 12)),
  //         ),
  //       );
  //       start++;
  //     }
  //   }
  //   return items;
  // }
}

// class MacosSidebarItem {
//   final String label;
//   final String? icon;
//   final bool section;
//   const MacosSidebarItem({required this.label, this.icon, this.section = false});
// }

class MacosSidebarItem {
  final String label;
  final String? icon;
  final bool section;
  const MacosSidebarItem({required this.label, this.icon, this.section = false});
}
