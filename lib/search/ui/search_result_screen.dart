import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/search/provider/search_provider.dart';
import 'package:reader/search/ui/components/search_bar.dart';
import 'package:reader/search/ui/components/search_group.dart';
import 'package:reader/search/usecase/search_usecase.dart';

class SearchResultScreen extends HookConsumerWidget {
  const SearchResultScreen({super.key, required this.keyword});
  final String keyword;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    EasyRefreshController controller = EasyRefreshController();
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final provider = searchBooksProvider(keyword);
    final searchGroups = ref.watch(provider);
    return Scaffold(
        appBar: BookSearchBar(
            autoFocus: false,
            keyword: keyword,
            onTap: () {
              context.replace("/search", extra: keyword);
            }),
        body: EasyRefresh.builder(
          controller: controller,
          refreshOnStart: true,
          onRefresh: () => SearchKeywordUsecase.searchBooksFromAll(ref, keyword: keyword),
          // onLoad: ref.read(provider.notifier).loadMore,
          childBuilder: (context, physics) {
            return CustomScrollView(
              physics: physics,
              slivers: [
                const HeaderLocator.sliver(),
                SliverList.builder(
                  itemBuilder: (context, index) {
                    final group = searchGroups[index];
                    return SearchGroup(
                      bookSource: group["bks"],
                      bookList: group["books"],
                    );
                  },
                  itemCount: searchGroups.length,
                ),
                const FooterLocator.sliver(),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  ),
                ),
              ],
            );
          },
        ));
  }
}
