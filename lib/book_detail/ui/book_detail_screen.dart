import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/book_detail/ui/components/book_tag.dart';

class BookDetailScreen extends HookConsumerWidget {
  const BookDetailScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coverUrl =
        'https://p3-reading-sign.fqnovelpic.com/novel-pic/c947e7567fa8646dace2755ec6f436b1~tplv-resize:225:0.image?lk3s=5b7047ff&x-expires=1737620073&x-signature=h8Pu5vTa4AFgz5lk8PfYXKrNV7g%3D';
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
                      "北派盗墓笔记",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text("云峰", style: TextStyle(fontSize: 16, color: colorScheme.secondary.withAlpha(180), height: 2)),
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
                      value: "番茄小说",
                      label: "来源",
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Center(
                      child: BookTag(
                        value: "共728章",
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
              child: Text(
                  "【已实体出版，线上平台有售】【盗墓+悬疑+鉴宝】我是一个东北山村的穷小子，二十世一纪初，为了出人头地，我加入了一个北方派盗墓团伙。从南到北，江湖百态，三教九流，这么多年从少年混到了中年，酒量见长，岁月蹉跎，我曾接触过许许多多的奇人异事，各位如有兴趣，不妨搬来小板凳，听一听，一位盗墓贼的江湖见闻。",
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
