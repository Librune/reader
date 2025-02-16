import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/components/app_top_bar.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/search/provider/history_provider.dart';

class SearchScreen extends HookConsumerWidget {
  const SearchScreen({super.key, this.keyword});
  final String? keyword;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final searchController = useTextEditingController(text: keyword);
    final history = ref.watch(searchHistoryProvider);
    return Scaffold(
      appBar: AppTopBar(
          title: Row(
        children: [
          Expanded(
              child: SearchBar(
            autoFocus: true,
            controller: searchController,
            elevation: WidgetStatePropertyAll(0),
            backgroundColor: WidgetStateProperty.all(
                colorScheme.inverseSurface.withAlpha(20)),
            constraints: BoxConstraints(minHeight: 38),
            textStyle: WidgetStatePropertyAll(textTheme.bodyMedium),
            padding:
                WidgetStatePropertyAll(EdgeInsets.only(right: 0, left: 10)),
            leading: Padding(
              padding: EdgeInsets.only(left: 4),
              child: SvgPicture.asset("assets/svg/ic_topbar_search.svg",
                  colorFilter:
                      ColorFilter.mode(colorScheme.onSurface, BlendMode.srcIn),
                  width: 16),
            ),
            onSubmitted: (value) {
              ref.read(searchHistoryProvider.notifier).push(value);
              context.replace('/book_search_result/$value');
            },
            trailing: [
              ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 36),
                  child: IconButton(
                      onPressed: () {
                        searchController.clear();
                      },
                      icon: SvgPicture.asset(
                        "assets/svg/ic_btn_close.svg",
                        width: 16,
                      ))),
              SizedBox(
                width: 0,
                height: 20,
                child: VerticalDivider(
                  color: colorScheme.secondaryContainer,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 36),
                child: TextButton(
                    onPressed: () {
                      context.replace(
                          '/book_search_result/${searchController.text}');
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          WidgetStateProperty.all(colorScheme.onSurface),
                    ),
                    child: Text(
                      "搜索",
                      style: TextStyle(fontSize: 14, height: 1),
                    )),
              )
            ],
          )),
          SizedBox(width: 16)
          // TextButton(onPressed: () {}, child: Text("搜索"))
        ],
      )),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 16, right: 4, top: 0),
              child: Row(
                children: [
                  Text(
                    "搜索历史",
                    style: textTheme.titleSmall,
                  ),
                  Spacer(),
                  SvgBtn(
                    svgName: "ic_btn_clean",
                    onPressed: () {
                      ref.read(searchHistoryProvider.notifier).clear();
                    },
                  )
                ],
              )),
          Expanded(
              child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              final str = history[index];
              return ListTile(
                dense: false,
                contentPadding: EdgeInsets.only(left: 20, right: 4),
                horizontalTitleGap: 12,
                // leading: SvgPicture.asset(
                //   "assets/svg/ic_leading_star.svg",
                //   width: 16,
                // ),
                title: Text(
                  str,
                  style: textTheme.bodyMedium,
                ),
                onTap: () {
                  context.replace('/book_search_result/$str');
                },
                trailing: SvgBtn(
                  svgName: "ic_btn_close",
                  size: 15,
                  onPressed: () {
                    ref.read(searchHistoryProvider.notifier).remove(str);
                  },
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 1,
                thickness: .7,
                indent: 56,
                endIndent: 18,
                color: colorScheme.surfaceContainerHighest,
              );
            },
            itemCount: history.length,
          )),
        ],
      ),
    );
  }
}
