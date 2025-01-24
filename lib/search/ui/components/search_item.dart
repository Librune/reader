import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nil/nil.dart';
import 'package:reader/app/architecture/utils/enum.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/app/data/model/book.dart';

class BookSearchItem extends HookConsumerWidget {
  const BookSearchItem({super.key, required this.book, required this.uuid});
  final BookModel book;
  final String uuid;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      child: Container(
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
                  constraints: BoxConstraints(maxHeight: 86),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            book.name,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                          // Text(
                          //   "🌟 8.7",
                          //   style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary),
                          // )
                        ],
                      ),
                      // Spacer(),
                      // Row(
                      //   children: [
                      //     Text(
                      //       book.author,
                      //       maxLines: 1,
                      //       overflow: TextOverflow.ellipsis,
                      //       style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary),
                      //     ),
                      //     Text("共${book.chapterNum}章", style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary))
                      //   ],
                      // ),
                      // Spacer(),
                      Expanded(
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "作者：${book.author}${book.description != null ? "\t\t|\t\t${book.description?.trim()}" : ""}",
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, height: 1.2, color: colorScheme.secondary),
                        ),
                      )),
                      Row(
                        spacing: 6,
                        children: [
                          if (book.wordNum != null)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.secondary.withAlpha(20),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(formatReadableNumber(book.wordNum!, "字"),
                                  style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary)),
                            ),
                          if (book.creationStatus != null)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.secondary.withAlpha(20),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(getBookCreationStatus(book.creationStatus!),
                                  style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary)),
                            ),
                          if (book.tags != null && book.tags!.isNotEmpty && book.tags!.first != null)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.secondary.withAlpha(20),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(book.tags!.first!,
                                  style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary)),
                            )
                        ],
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
      onTap: () {
        Log.d(book);
        context.push("/book_detail/$uuid/${book.bookId}", extra: book);
      },
    );
  }
}
