import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/theme/text.dart';

class ShelfGrid extends HookConsumerWidget {
  const ShelfGrid({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = [
      {
        "cover":
            "https://s3proxy.cdn-zlib.sk/covers400/collections/userbooks/b16ddb6d947f0a09b1559906acee65c7242b41a328826d0fafc0e9ef6d93d3ca.jpg",
        "name": "蛙",
        "author": "莫言"
      },
      {
        "cover":
            "https://s3proxy.cdn-zlib.sk/covers400/collections/genesis/0ba15d62a2c0913f175d6afb8513c0f3cfcf576befd3f52cd0010b754a1eafc5.jpg",
        "name": "悲惨世界",
        "author": "雨果"
      },
      {
        "cover":
            "https://s3proxy.cdn-zlib.sk/covers400/collections/userbooks/13f04140430b0218a3bb1b08f8104c6dc6cb56d17e096c31df767442cac1ec84.jpg",
        "name": "我与地坛",
        "author": "史铁生"
      },
      {
        "cover":
            "https://s3proxy.cdn-zlib.sk/covers400/collections/userbooks/191d6353def0e77dc46397273292afa8009c0730ce8fd307a38f6b26fa624208.jpg",
        "name": "恶意",
        "author": "东野圭吾"
      },
      {
        "cover":
            "https://s3proxy.cdn-zlib.sk/covers400/collections/userbooks/e16fa36143dbe6a456b3d00bc17a18bb8f85dffa01fba1e4ed4335519049fb78.jpg",
        "name": "杀死一只知更鸟",
        "author": "Harper Lee"
      }
    ];
    return Material(
        child: GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100, crossAxisSpacing: 20, mainAxisSpacing: 10, childAspectRatio: .58),
      itemBuilder: (context, index) {
        return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      books[index]["cover"]!,
                      width: constraints.maxWidth,
                      height: constraints.maxHeight - 32,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      books[index]["name"]!,
                      style: TextStyle(fontSize: 13, height: 2),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                );
              },
            ));
      },
      itemCount: books.length,
    ));
  }
}
