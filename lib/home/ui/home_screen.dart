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
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: currentIndex.value,
          onTap: (p0) => currentIndex.value = p0,
          margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          selectedItemColor: colorScheme.onSurface,
          items: [
            /// Home
            SalomonBottomBarItem(
                icon: SvgPicture.asset("assets/svg/ic_bottom_book.svg",
                    colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn), width: 22),
                title: Text(
                  "书架",
                  style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
                ),
                selectedColor: colorScheme.scrim),

            SalomonBottomBarItem(
                icon: SvgPicture.asset("assets/svg/ic_bottom_compass.svg",
                    colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn), width: 22),
                title: Text(
                  "探索",
                  style: textTheme.bodySmall,
                ),
                selectedColor: colorScheme.scrim),
            SalomonBottomBarItem(
                icon: SvgPicture.asset("assets/svg/ic_bottom_ghost.svg",
                    colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn), width: 22),
                title: Text(
                  "书源",
                  style: textTheme.bodySmall,
                ),
                selectedColor: colorScheme.scrim),
            SalomonBottomBarItem(
                icon: SvgPicture.asset("assets/svg/ic_bottom_preference.svg",
                    colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn), width: 22),
                title: Text(
                  "设置",
                  style: textTheme.bodySmall,
                ),
                selectedColor: colorScheme.scrim),
          ],
        ));
  }
}
