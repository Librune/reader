import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/theme/text.dart';
import 'package:reader/shelf/ui/shelf_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final currentIndex = useState(0);
    return Scaffold(
        body: ShelfScreen(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex.value,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.secondary,
          selectedLabelStyle: TextStyle(fontSize: 10),
          unselectedLabelStyle: TextStyle(fontSize: 10),
          onTap: (value) {
            currentIndex.value = value;
          },
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/svg/ic_bottom_books.svg",
                  colorFilter: ColorFilter.mode(
                      currentIndex.value == 0 ? colorScheme.primary : colorScheme.secondary, BlendMode.srcIn),
                  width: 22,
                ),
                label: "书架"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/svg/ic_bottom_discover.svg",
                  colorFilter: ColorFilter.mode(
                      currentIndex.value == 1 ? colorScheme.primary : colorScheme.secondary, BlendMode.srcIn),
                  width: 22,
                ),
                label: "搜索"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/svg/ic_bottom_ext.svg",
                  colorFilter: ColorFilter.mode(
                      currentIndex.value == 2 ? colorScheme.primary : colorScheme.secondary, BlendMode.srcIn),
                  width: 22,
                ),
                label: "设置"),
          ],
        ));
  }
}
