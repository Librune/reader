import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/reader/provider/menu.dart';

import 'catalog.dart';

class BottomBar extends HookConsumerWidget {
  const BottomBar({super.key, required this.book});
  final BookModel book;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).padding.bottom + 68;
    final visible = ref.watch(menuProvider.select((value) => value.bottom));
    final currentIndex = useState<int?>(null);
    useEffect(() {
      if (!visible) {
        currentIndex.value = null;
      }
      return null;
    }, [visible]);
    return AnimatedPositioned(
      duration: Duration(milliseconds: 200),
      bottom: visible ? 0 : -height - 24,
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
              currentIndex: currentIndex,
              book: book,
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: SvgBtn(
                  svgName: 'ic_bottom_font',
                  size: 26,
                  color: currentIndex.value == 1 ? colorScheme.primary : null,
                  onPressed: () {
                    currentIndex.value = 1;
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: SvgBtn(
                  svgName: 'ic_bottom_sun',
                  size: 26,
                  color: currentIndex.value == 2 ? colorScheme.primary : null,
                  onPressed: () {
                    currentIndex.value = 2;
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: SvgBtn(
                  svgName: 'ic_bottom_settings',
                  size: 26,
                  color: currentIndex.value == 3 ? colorScheme.primary : null,
                  onPressed: () {
                    currentIndex.value = 3;
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
