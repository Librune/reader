import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:reader/home/components/sidebar.dart';

class HomeScreen extends StatefulHookConsumerWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      sidebar: Sidebar(
        minWidth: 200,
        topOffset: 46,
        top: MacosSearchField(
          decoration: BoxDecoration(
            color: MacosColors.secondaryLabelColor.darkColor,
            borderRadius: BorderRadius.circular(7.0),
          ),
          focusedDecoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(7.0))),
        ),
        builder: (context, scrollController) {
          return SidebarItems(
            currentIndex: 0,
            onChanged: (index) {},
            items: [
              SidebarItem(label: Text('图书'), section: true),
              MacosSidebarItem(labelText: '全部', iconName: 'ic_books'),
              SidebarItem(label: Text('探索'), section: true),
              MacosSidebarItem(labelText: "刺猬猫", iconName: 'ic_discover'),
              MacosSidebarItem(labelText: "起点", iconName: 'ic_discover'),
              MacosSidebarItem(labelText: "红袖添香", iconName: 'ic_discover'),
              MacosSidebarItem(labelText: "微信读书", iconName: 'ic_discover'),
            ],
          );
        },
      ),
      child: const Center(child: Text('Hello World')),
    );
  }
}
