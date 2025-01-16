import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/search/ui/components/search_bar.dart';
import 'package:reader/search/ui/components/search_item.dart';

class SearchResultScreen extends HookConsumerWidget {
  const SearchResultScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: BookSearchBar(),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                "搜索结果",
                style: textTheme.titleSmall,
              ),
            ),
          ),
          SliverList.separated(
            itemBuilder: (context, index) {
              return BookSearchItem();
            },
            separatorBuilder: (context, index) {
              return Divider(
                indent: 96,
                endIndent: 20,
                height: 32,
                thickness: .3,
                color: colorScheme.secondaryContainer,
              );
            },
            itemCount: 10,
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            addSemanticIndexes: true,
          )
        ],
      ),
    );
  }
}
