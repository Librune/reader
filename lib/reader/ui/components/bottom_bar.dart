import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/data/model/catalog.dart';
import 'package:reader/reader/provider/menu.dart';
import 'package:reader/reader/ui/components/sheets/config.dart';
import 'package:reader/reader/ui/components/sheets/font.dart';
import 'package:reader/reader/ui/components/sheets/theme.dart';

import 'sheets/catalog.dart';

class BottomBar extends HookConsumerWidget {
  const BottomBar({super.key, required this.book, required this.onChapterTap});
  final BookModel book;
  final void Function(ChapterModel chapter) onChapterTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).padding.bottom + 68;
    final visible = ref.watch(menuProvider.select((value) => value.bottom));
    final subVisible = ref.watch(menuProvider.select((value) => value.sub));
    return AnimatedPositioned(
      duration: Duration(milliseconds: 200),
      bottom: visible ? 0 : -height - 24,
      left: 0,
      right: 0,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          boxShadow: subVisible
              ? null
              : [
                  BoxShadow(
                    color: colorScheme.shadow.withAlpha(15), // 原 20 → 15
                    blurRadius: 20,
                    spreadRadius: -2,
                    offset: Offset(0, -6),
                  ),
                  BoxShadow(
                    color: colorScheme.shadow.withAlpha(25), // 原 31 → 25
                    blurRadius: 12,
                    offset: Offset(0, -3),
                  ),
                  BoxShadow(
                    color: colorScheme.shadow.withAlpha(8), // 原 10 → 8
                    blurRadius: 4,
                    offset: Offset(0, -1),
                  ),
                ],
        ),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Row(
          children: [
            CatalogSheet(
              book: book,
              onChapterTap: (chapter) {
                onChapterTap(chapter);
              },
            ),
            FontSheet(),
            ThemeSheet(),
            ConfigSheet()
          ],
        ),
      ),
    );
  }
}
