import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/book_detail/ui/components/book_tag.dart';
import 'package:reader/search/data/model/search_book_item.dart';

class BookDetailScreen extends HookConsumerWidget {
  const BookDetailScreen({super.key, this.book, required this.uuid, required this.bid});
  final String uuid;
  final String bid;
  final SearchBookItemModel? book;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coverUrl = book!.cover;
    final bookSource = BookSourceService().bookSourceList.firstWhere((element) => element.uuid == uuid);
    // final coverScheme = useCoverColor(context, coverUrl: coverUrl);
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Color.alphaBlend(
        colorScheme.surfaceContainerLow.withAlpha(160),
        colorScheme.surfaceContainerLowest,
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 9,
          ),
          CachedNetworkImage(
            imageUrl: coverUrl,
            width: min(MediaQuery.of(context).size.width * 8 / 24, 132),
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.only(top: 48, left: 32, right: 14),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book!.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(book!.author,
                        style: TextStyle(fontSize: 16, color: colorScheme.secondary.withAlpha(180), height: 2)),
                  ],
                ),
                Spacer(),
                // SvgBtn(
                //   svgName: 'ic_btn_book_open',
                //   size: 22,
                //   color: colorScheme.primary,
                // )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 0, right: 0, top: 32, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: BookTag(
                      value: bookSource.name,
                      label: "来源",
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Center(
                      child: BookTag(
                        value: "共${book!.chapterNum}章",
                        label: "篇幅",
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Center(
                      child: BookTag(
                        value: "1天前",
                        label: "上次更新",
                      ),
                    )),
              ],
            ),
          ),
          Divider(
            indent: 24,
            endIndent: 24,
            thickness: .5,
          ),
          Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
              ),
              padding: EdgeInsets.only(left: 24, right: 24, top: 20),
              child: Text(book!.description!,
                  style: TextStyle(color: colorScheme.onSurface.withAlpha(180), fontSize: 14))),
          Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "assets/svg/ic_chevron_left.svg",
                colorFilter: ColorFilter.mode(colorScheme.secondary.withAlpha(180), BlendMode.srcIn),
                width: 20,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 2, left: 3),
                child: Text(
                  "向左滑动开始阅读",
                  style: TextStyle(color: colorScheme.secondary.withAlpha(180), height: 1),
                ),
              )
            ],
          ),
          SizedBox(
            height: 12 + MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }
}
