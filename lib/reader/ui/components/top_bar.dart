import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/reader/provider/menu.dart';

class TopBar extends HookConsumerWidget {
  const TopBar({super.key, required this.book});
  final BookModel book;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).padding.top + 56;
    final visible = ref.watch(menuProvider.select((value) => value.top));
    return AnimatedPositioned(
      duration: Duration(milliseconds: 200),
      top: visible ? 0 : -height - 24,
      left: 0,
      right: 0,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(15), // 原 20 → 15
              blurRadius: 20,
              spreadRadius: -2,
              offset: Offset(0, 6),
            ),
            BoxShadow(
              color: colorScheme.shadow.withAlpha(25), // 原 31 → 25
              blurRadius: 12,
              offset: Offset(0, 3),
            ),
            BoxShadow(
              color: colorScheme.shadow.withAlpha(8), // 原 10 → 8
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 12),
              height: 38,
              width: 38,
              child: SvgBtn(
                svgName: 'ic_btn_back',
                size: 22,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(colorScheme.surfaceContainerHighest),
                  padding: WidgetStateProperty.all(EdgeInsets.all(5)),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
