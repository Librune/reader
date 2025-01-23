import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/book_detail/ui/components/book_tag.dart';
import 'package:reader/search/data/model/search_book_item.dart';

class BookDetailScreen extends HookConsumerWidget {
  const BookDetailScreen({super.key, this.book, required this.uuid, required this.bid});
  final String uuid;
  final String bid;
  final SearchBookItemModel? book;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final coverUrl = book!.cover;
    final bookSource = BookSourceService().bookSourceList.firstWhere((element) => element.uuid == uuid);
    // final coverScheme = useCoverColor(context, coverUrl: coverUrl);
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
        color: Color.alphaBlend(
          colorScheme.surfaceContainerLow.withAlpha(160),
          colorScheme.surfaceContainerLowest,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: coverUrl,
                  width: maxWidth,
                  height: maxHeight / 3,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24, left: 24, right: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book!.name,
                          style: TextStyle(
                              fontSize: 17, color: colorScheme.primary, fontWeight: FontWeight.bold, height: 1.4)),
                      Text(book!.author, style: TextStyle(fontSize: 14, color: colorScheme.secondary, height: 1.8)),
                    ],
                  ),
                  // Spacer(),
                  // SvgBtn(
                  //   svgName: 'ic_btn_book_open',
                  //   size: 22,
                  //   color: colorScheme.primary,
                  // )
                ),
                Padding(
                    padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 8),
                    child: Row(
                      spacing: 12,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 3),
                          child: Text(
                            "简介",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 20),
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: colorScheme.secondary.withAlpha(20),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text("免费",
                                          style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary)),
                                    );
                                  },
                                  separatorBuilder: (context, index) => SizedBox(width: 8),
                                  itemCount: 24)),
                        )
                      ],
                    )
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       flex: 1,
                    //       child: Center(
                    //         child: BookTag(
                    //           value: bookSource.name,
                    //           label: "来源",
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //         flex: 1,
                    //         child: Center(
                    //           child: BookTag(
                    //             value: "共${book!.chapterNum}章",
                    //             label: "篇幅",
                    //           ),
                    //         )),
                    //     Expanded(
                    //         flex: 1,
                    //         child: Center(
                    //           child: BookTag(
                    //             value: "1天前",
                    //             label: "上次更新",
                    //           ),
                    //         )),
                    //   ],
                    // ),
                    ),
                Container(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                    ),
                    padding: EdgeInsets.only(left: 24, right: 24, top: 0),
                    child: Text(book!.description!,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: colorScheme.onSurface.withAlpha(180), fontSize: 14))),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 24, right: 4),
                    title: Text(
                      "查看目录",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "共1234章，上次更新于18小时前",
                      style: TextStyle(fontSize: 15, color: colorScheme.secondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: SvgBtn(
                      svgName: "ic_card_right",
                      size: 13,
                    ),
                    onTap: () {},
                  ),
                ),
                //  Divider(
                //   indent: 24,
                //   endIndent: 24,
                //   thickness: 1,
                //   height: 36,
                // ),

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
            );
          },
        ));
  }
}
