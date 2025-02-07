import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/data/model/book.dart';

class ShelfGrid extends HookConsumerWidget {
  const ShelfGrid({super.key, required this.books});
  final List<BookModel> books;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 112, crossAxisSpacing: 32, mainAxisSpacing: 10, childAspectRatio: .58),
      itemBuilder: (context, index) {
        return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: books[index].cover,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight - 32,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        books[index].name,
                        style: TextStyle(fontSize: 13, height: 2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  onTap: () {
                    context.push("/reader", extra: books[index]);
                  },
                );
              },
            ));
      },
      itemCount: books.length,
    );
  }
}
