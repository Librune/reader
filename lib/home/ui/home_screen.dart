import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/shelf/ui/shelf_screen.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
        body: ShelfScreen(),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 0), // 负值使阴影向上
                ),
              ],
            ),
            child: NavigationBar(
                backgroundColor: scaffoldBackgroundColor,
                indicatorColor: scaffoldBackgroundColor,
                height: 60,
                destinations: [
                  NavigationDestination(
                    icon: Transform.translate(
                      offset: Offset(0, 4),
                      child: SvgPicture.asset(
                        "assets/svg/ic_bottom_book.svg",
                        colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
                      ),
                    ),
                    label: '书架',
                  ),
                  NavigationDestination(
                    icon: Transform.translate(
                        offset: Offset(0, 4),
                        child: SvgPicture.asset(
                          "assets/svg/ic_bottom_compass.svg",
                          colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
                        )),
                    label: '排行',
                  ),
                  NavigationDestination(
                    icon: Transform.translate(
                        offset: Offset(0, 4),
                        child: SvgPicture.asset(
                          "assets/svg/ic_bottom_preference.svg",
                          colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
                        )),
                    label: '设置',
                  ),
                ])));
  }
}
