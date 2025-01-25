import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/data/model/catalog.dart';
import 'package:reader/reader/provider/reader.dart';
import 'package:reader/reader/ui/components/bottom_bar.dart';
import 'package:reader/reader/ui/components/catalog.dart';
import 'package:reader/reader/ui/components/gesture_wrapper.dart';
import 'package:reader/reader/usecase/menu_sheet_usecase.dart';

class ReaderScreen extends HookConsumerWidget {
  const ReaderScreen({super.key, required this.book});
  final BookModel book;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reader = ref.watch(readerProvider(book));
    final colorScheme = ColorScheme.fromSeed(seedColor: Color(0xFFFFDE3F));
    return Theme(
        data: ThemeData(colorScheme: colorScheme),
        child: Material(
            color: colorScheme.surfaceContainerHigh,
            child: switch (reader) {
              AsyncValue(:final value?) => Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      top: 0,
                      child: GestureWrapper(
                          child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: colorScheme.surfaceContainerHigh,
                      )),
                    ),
                    Navigator(
                      key: MenuSheetUsecase().sheetCtx, // 全局 Key 用于获取子导航器上下文
                    ),
                    BottomBar(book: book),
                  ],
                ),
              _ => Center(
                  child: CircularProgressIndicator(),
                ),
            }));
  }
}
