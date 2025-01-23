import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/hooks/use_cover_color.dart';
import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/book_detail/ui/components/book_tag.dart';
import 'package:reader/search/data/model/search_book_item.dart';

import 'components/cover_background.dart';

class BookDetailScreen extends HookConsumerWidget {
  const BookDetailScreen({super.key, this.book, required this.uuid, required this.bid});
  final String uuid;
  final String bid;
  final SearchBookItemModel? book;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final coverUrl = book!.cover;
    final darkColorScheme = Theme.of(context).colorScheme.copyWith(brightness: Brightness.dark);
    final bookSource = BookSourceService().bookSourceList.firstWhere((element) => element.uuid == uuid);
    // final coverScheme = useCoverColor(context, coverUrl: coverUrl);
    final colorScheme = Theme.of(context).colorScheme;
    final coverColorScheme = useCoverColor(context, coverUrl: coverUrl);
    return Material(
        color: Color.alphaBlend(coverColorScheme.data!.primary.withAlpha(50), Colors.black),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;
            return Stack(
              children: [
                ShaderBackground(
                  cover: coverUrl,
                  colorScheme: coverColorScheme.data!,
                ),
                // 毛玻璃效果
                Positioned(
                  top: maxHeight / 2,
                  left: 0,
                  right: 0, // 确保覆盖整个宽度
                  bottom: 0, // 确保延伸到底部
                  child: ClipRect(
                    // 添加 ClipRect 来限制模糊范围
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                      child: Container(color: Colors.black.withAlpha(10)),
                    ),
                  ),
                ),
                Positioned(
                    top: maxHeight * 1 / 3,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(book!.name,
                            style: TextStyle(
                                fontSize: 22, color: colorScheme.onPrimary, fontWeight: FontWeight.bold, height: 1.4)),
                        Text(book!.author, style: TextStyle(fontSize: 16, color: colorScheme.onSecondary, height: 2.4)),
                        Container(
                          margin: EdgeInsets.only(top: 24, bottom: 24),
                          child: Row(
                            children: [
                              TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(colorScheme.onSecondary.withAlpha(50)),
                                    foregroundColor: WidgetStateProperty.all(colorScheme.onSecondary),
                                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 42, vertical: 8)),
                                    shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(32))),
                                  ),
                                  onPressed: () {},
                                  child: Text("开始阅读"))
                            ],
                          ),
                        ),
                        Container(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width,
                            ),
                            padding: EdgeInsets.only(top: 8),
                            child: Text(book!.description!,
                                maxLines: 8,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                                style: TextStyle(color: colorScheme.onSecondary.withAlpha(200), fontSize: 14))),
                        Container(
                          margin: EdgeInsets.only(top: 24, bottom: 16),
                          child: Wrap(
                            spacing: 14,
                            children: ["免费", "连载中", "热门"].map((e) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: colorScheme.onSecondary.withAlpha(20),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(e, style: TextStyle(color: colorScheme.onSecondary.withAlpha(200))),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    )),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     // Container(
                //     //   height: 240,
                //     //   width: maxWidth,
                //     //   child: ShaderBackground(
                //     //     cover: coverUrl,
                //     //   ),
                //     // ),
                //     // CachedNetworkImage(
                //     //   imageUrl: coverUrl,
                //     //   width: maxWidth,
                //     //   height: maxHeight / 3,
                //     //   fit: BoxFit.cover,
                //     // ),
                //     // Padding(
                //     //   padding: EdgeInsets.only(top: 24, left: 24, right: 14),
                //     //   child: Column(
                //     //     crossAxisAlignment: CrossAxisAlignment.start,
                //     //     children: [
                //     //       Text(book!.name,
                //     //           style: TextStyle(
                //     //               fontSize: 17,
                //     //               color: colorScheme.onPrimary,
                //     //               fontWeight: FontWeight.bold,
                //     //               height: 1.4)),
                //     //       Text(book!.author,
                //     //           style: TextStyle(fontSize: 14, color: colorScheme.onSecondary, height: 1.8)),
                //     //     ],
                //     //   ),
                //     //   // Spacer(),
                //     //   // SvgBtn(
                //     //   //   svgName: 'ic_btn_book_open',
                //     //   //   size: 22,
                //     //   //   color: colorScheme.primary,
                //     //   // )
                //     // ),
                //     Padding(
                //         padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 8),
                //         child: Row(
                //           spacing: 12,
                //           children: [
                //             Padding(
                //               padding: EdgeInsets.only(bottom: 3),
                //               child: Text(
                //                 "简介",
                //                 style:
                //                     TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
                //               ),
                //             ),
                //             Expanded(
                //               child: ConstrainedBox(
                //                   constraints: BoxConstraints(maxHeight: 20),
                //                   child: ListView.separated(
                //                       scrollDirection: Axis.horizontal,
                //                       shrinkWrap: true,
                //                       itemBuilder: (context, index) {
                //                         return Container(
                //                           padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                //                           decoration: BoxDecoration(
                //                             color: colorScheme.secondary.withAlpha(20),
                //                             borderRadius: BorderRadius.circular(2),
                //                           ),
                //                           child: Text("免费",
                //                               style: textTheme.bodySmall?.copyWith(color: colorScheme.secondary)),
                //                         );
                //                       },
                //                       separatorBuilder: (context, index) => SizedBox(width: 8),
                //                       itemCount: 24)),
                //             )
                //           ],
                //         )
                //         // Row(
                //         //   children: [
                //         //     Expanded(
                //         //       flex: 1,
                //         //       child: Center(
                //         //         child: BookTag(
                //         //           value: bookSource.name,
                //         //           label: "来源",
                //         //         ),
                //         //       ),
                //         //     ),
                //         //     Expanded(
                //         //         flex: 1,
                //         //         child: Center(
                //         //           child: BookTag(
                //         //             value: "共${book!.chapterNum}章",
                //         //             label: "篇幅",
                //         //           ),
                //         //         )),
                //         //     Expanded(
                //         //         flex: 1,
                //         //         child: Center(
                //         //           child: BookTag(
                //         //             value: "1天前",
                //         //             label: "上次更新",
                //         //           ),
                //         //         )),
                //         //   ],
                //         // ),
                //         ),
                //     Container(
                //         constraints: BoxConstraints(
                //           minWidth: MediaQuery.of(context).size.width,
                //         ),
                //         padding: EdgeInsets.only(left: 24, right: 24, top: 0),
                //         child: Text(book!.description!,
                //             maxLines: 4,
                //             overflow: TextOverflow.ellipsis,
                //             textAlign: TextAlign.justify,
                //             style: TextStyle(color: colorScheme.onPrimary.withAlpha(180), fontSize: 14))),
                //     Padding(
                //       padding: EdgeInsets.only(top: 16),
                //       child: ListTile(
                //         contentPadding: EdgeInsets.only(left: 24, right: 4),
                //         title: Text(
                //           "查看目录",
                //           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                //         ),
                //         subtitle: Text(
                //           "共1234章，上次更新于18小时前",
                //           style: TextStyle(fontSize: 15, color: colorScheme.secondary),
                //           maxLines: 1,
                //           overflow: TextOverflow.ellipsis,
                //         ),
                //         trailing: SvgBtn(
                //           svgName: "ic_card_right",
                //           size: 13,
                //         ),
                //         onTap: () {},
                //       ),
                //     ),
                //     //  Divider(
                //     //   indent: 24,
                //     //   endIndent: 24,
                //     //   thickness: 1,
                //     //   height: 36,
                //     // ),

                //     Spacer(),
                //     Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         SvgPicture.asset(
                //           "assets/svg/ic_chevron_left.svg",
                //           colorFilter: ColorFilter.mode(colorScheme.secondary.withAlpha(180), BlendMode.srcIn),
                //           width: 20,
                //         ),
                //         Padding(
                //           padding: EdgeInsets.only(bottom: 2, left: 3),
                //           child: Text(
                //             "向左滑动开始阅读",
                //             style: TextStyle(color: colorScheme.secondary.withAlpha(180), height: 1),
                //           ),
                //         )
                //       ],
                //     ),
                //     SizedBox(
                //       height: 12 + MediaQuery.of(context).padding.bottom,
                //     )
                //   ],
                // )
              ],
            );
          },
        ));
  }
}
