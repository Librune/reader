import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/hooks/use_cover_color.dart';
import 'package:reader/app/architecture/utils/enum.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/book_detail/provider/book_detail.dart';
import 'package:reader/book_detail/usecase/book_toggle_shelf_usecase.dart';

import 'components/cover_background.dart';

class BookDetailScreen extends HookConsumerWidget {
  const BookDetailScreen({super.key, required this.book, required this.uuid, required this.bid});
  final String uuid;
  final String bid;
  final BookModel book;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coverUrl = book.cover;
    final colorScheme = Theme.of(context).colorScheme;
    final coverColorScheme = useCoverColor(context, coverUrl: coverUrl, time: 400);
    final _book = book.copyWith(bookSourceId: uuid);
    final isInShelf = ref.watch(bookInShelfProvider(_book));
    return switch (coverColorScheme) {
      AsyncSnapshot(:final data?) => Material(
          color: Color.alphaBlend(coverColorScheme.data!.primary.withAlpha(50), Colors.black),
          child: LayoutBuilder(builder: (context, constraints) {
            final maxHeight = constraints.maxHeight;
            return Stack(
              children: [
                ShaderBackground(
                  cover: coverUrl,
                  colorScheme: data,
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
                    top: 0,
                    bottom: 0,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Spacer(
                          flex: 6,
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 4),
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text(
                                "连载中",
                                style: TextStyle(color: colorScheme.secondaryContainer),
                              ),
                            ),
                            SizedBox(
                              height: 14,
                              child: VerticalDivider(
                                color: colorScheme.secondaryContainer,
                                width: 24,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 4),
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text(
                                formatReadableNumber(book.wordNum, "字"),
                                style: TextStyle(color: colorScheme.secondaryContainer),
                              ),
                            ),
                          ],
                        ),
                        Text(_book.name,
                            style: TextStyle(
                                fontSize: 22, color: colorScheme.onPrimary, fontWeight: FontWeight.bold, height: 1.4)),
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text("作者：${_book.author}",
                              style: TextStyle(
                                fontSize: 15,
                                color: colorScheme.onSecondary.withAlpha(200),
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16, bottom: 12),
                          child: Row(
                            children: [
                              TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(colorScheme.primaryContainer),
                                    foregroundColor: WidgetStateProperty.all(colorScheme.onPrimaryContainer),
                                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 42, vertical: 8)),
                                    shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(32))),
                                  ),
                                  onPressed: () {},
                                  child: Text("开始阅读")),
                              Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: SvgBtn(
                                  svgName: (isInShelf.value ?? false) ? "ic_btn_heart_fill" : "ic_btn_heart",
                                  size: 22,
                                  color: colorScheme.onPrimary,
                                  onPressed: () {
                                    bookToggleShelfUsecase(ref, _book);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width,
                            ),
                            padding: EdgeInsets.only(top: 8),
                            child: Text(_book.description!,
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    color: colorScheme.onSecondary.withAlpha(200), height: 1.7, fontSize: 14))),
                        Container(
                          margin: EdgeInsets.only(top: 24, bottom: 16),
                          child: Wrap(
                            spacing: 14,
                            runSpacing: 14,
                            children: (_book.tags ?? []).map((e) {
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
                        Spacer(flex: 6),
                      ],
                    )),
              ],
            );
          })),
      _ => Material(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
    };
  }
}
