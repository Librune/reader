import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/provider/menu.dart';
import 'package:reader/reader/provider/reader.dart';
import 'package:reader/reader/ui/components/bottom_bar.dart';
import 'package:reader/reader/ui/components/gesture_wrapper.dart';
import 'package:reader/reader/usecase/menu_sheet_usecase.dart';

import 'components/render.dart';

class ReaderScreen extends HookConsumerWidget {
  const ReaderScreen({super.key, required this.book});
  final BookModel book;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reader = ref.watch(readerProvider(book, context: context));
    final colorScheme = ColorScheme.fromSeed(seedColor: Color(0xFFFFDE3F));
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // ref.invalidate(readerProvider(book, context: context));
          // ref.invalidate(menuProvider);
        }
      },
      child: Theme(
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
                          child: PageView.builder(
                            pageSnapping: true,
                            // physics: HorizontalBlockedScrollPhysics(controller: horizontalBlockedController),
                            allowImplicitScrolling: true,
                            // controller: readerPageController,
                            itemBuilder: (context, index) =>
                                // DecoratedBox(
                                //   decoration: BoxDecoration(color: rdt.colorScheme.surfaceContainer),
                                //   child:
                                ReaderPage(pagePainter: value[index], context: context),
                            // ),
                            itemCount: value.length,
                          ),
                        )),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final subVisible = ref.watch(menuProvider.select((value) => value.sub));
                          return IgnorePointer(
                            ignoring: !subVisible,
                            child: Scaffold(
                              backgroundColor: Colors.transparent,
                              key: MenuSheetUsecase().sheetCtx,
                              body: GestureDetector(
                                onTap: () {
                                  MenuSheetUsecase().close();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      BottomBar(book: book),
                    ],
                  ),
                _ => Center(
                    child: CircularProgressIndicator(),
                  ),
              })),
    );
  }
}
