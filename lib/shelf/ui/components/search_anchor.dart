import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppBarSearchAnchor extends HookConsumerWidget {
  const AppBarSearchAnchor({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return IconButton(
          onPressed: () {
            controller.openView();
          },
          icon: SvgPicture.asset(
            "assets/svg/ic_topbar_search.svg",
            colorFilter: ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
            width: 18,
          ),
        );
      },
      viewElevation: 0,
      dividerColor: Colors.transparent,
      viewBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
      viewBuilder: (Iterable<Widget> suggestions) {
        return Scaffold(
          // 使用 Scaffold 提供全屏布局
          body: Container(
            // 内容区域占满剩余空间
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (BuildContext context, int index) {
                return suggestions.elementAt(index);
              },
            ),
          ),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(5, (int index) {
          return ListTile(
            title: Text('Suggestion $index'),
            onTap: () {
              controller.closeView(null);
            },
          );
        });
      },
    );
  }
}
