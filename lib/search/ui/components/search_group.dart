import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/book_source/data/model/book_source.dart';
import 'package:reader/search/data/model/search_book_item.dart';

import 'search_item.dart';

class SearchGroup extends HookConsumerWidget {
  const SearchGroup({
    super.key,
    required this.bookSource,
    required this.bookList,
  });
  final BookSourceModel bookSource;
  final List<SearchBookItemModel> bookList;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 16),
          child: Text(
            bookSource.name,
            style: textTheme.titleSmall,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return BookSearchItem(book: bookList[index]);
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
          itemCount: bookList.length,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          addSemanticIndexes: true,
        ),
      ],
    );
  }
}
