import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/search/provider/search_provider.dart';
import 'package:reader/search/ui/components/search_bar.dart';
import 'package:reader/search/ui/components/search_item.dart';
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
    final searchBooks = ref.watch(provider);
    return Scaffold(
        appBar: BookSearchBar(
            autoFocus: false,
            keyword: keyword,
            onTap: () {
              context.replace("/search", extra: keyword);
            }),
        body: EasyRefresh(
          controller: controller,
          refreshOnStart: true,
          onRefresh: () => SearchKeywordUsecase.searchBooksFromAll(ref, keyword: keyword),
          // onLoad: ref.read(provider.notifier).loadMore,
          child: CustomScrollView(
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
                  return BookSearchItem(book: searchBooks[index]);
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
                itemCount: searchBooks.length,
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                addSemanticIndexes: true,
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              )
            ],
          ),
        ));
  }
}
