import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/theme/text.dart';
import 'package:reader/search/data/model/search_book_item.dart';

class BookSearchItem extends HookConsumerWidget {
  const BookSearchItem({super.key, required this.book});
  final SearchBookItemModel book;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        spacing: 14,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(80),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: book.cover,
                width: 64,
                height: 86,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 76),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          book.name,
                          style: textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                        Text(
                          "🌟 8.7",
                          style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          Text(
                            book.author,
                            style: textTheme.bodyMedium?.copyWith(color: colorScheme.secondary),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        // Text("九九藏书网 · 严肃文学", style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary)),
                        // VerticalDivider(),
                        Text("共 ${book.chapterNum} 章",
                            style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary))
                      ],
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
