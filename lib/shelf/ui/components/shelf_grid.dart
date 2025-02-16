import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/data/model/book.dart';

class ShelfGrid extends StatefulHookConsumerWidget {
  const ShelfGrid({super.key, required this.books});
  final List<BookModel> books;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShelfGridState();
}

class _ShelfGridState extends ConsumerState<ShelfGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 112,
          crossAxisSpacing: 32,
          mainAxisSpacing: 10,
          childAspectRatio: .58),
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
                        imageUrl: widget.books[index].cover,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight - 32,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        widget.books[index].name,
                        style: TextStyle(fontSize: 13, height: 2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  onTap: () {
                    context.push("/reader", extra: widget.books[index]);
                  },
                );
              },
            ));
      },
      itemCount: widget.books.length,
    );
  }
}
