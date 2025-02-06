import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/ui/components/svg_btn.dart';
import 'package:reader/reader/data/model/menu.dart';
import 'package:reader/reader/provider/menu.dart';
import 'package:reader/reader/ui/components/bottom_sheet.dart';
import 'package:reader/reader/ui/components/sheets/config.dart';
import 'package:reader/reader/ui/components/sheets/font.dart';
import 'package:reader/reader/ui/components/sheets/theme.dart';
import 'package:reader/reader/usecase/menu_sheet_usecase.dart';

class BottomBar extends StatefulHookConsumerWidget {
  const BottomBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomBarState();
}

class _BottomBarState extends ConsumerState<BottomBar> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final height = MediaQuery.of(context).padding.bottom + 68;
    final visible = ref.watch(menuProvider.select((value) => value.bottom));
    final subVisible = ref.watch(menuProvider.select((value) => value.sub));
    final subType = ref.watch(menuProvider.select((value) => value.subType));
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
            Expanded(
              flex: 1,
              child: Center(
                child: SvgBtn(
                  svgName: 'ic_bottom_slider',
                  size: 26,
                  color: ReaderBottomSheet.catalog == subType ? colorScheme.primary : null,
                  onPressed: () {
                    // MenuSheetUsecase().toggle(const CatalogSheetContent(),
                    //     type: ReaderBottomSheet.catalog, ref: ref, maxHeight: MediaQuery.of(context).size.height - 92);
                    // MenuSheetUsecase().catalogSheetKey.currentState?.toggle();
                    MenuSheetUsecase().toggleSheet(MenuSheetUsecase().catalogSheetKey, ref: ref);
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: SvgBtn(
                  svgName: 'ic_bottom_font',
                  size: 26,
                  color: ReaderBottomSheet.font == subType ? colorScheme.primary : null,
                  onPressed: () {
                    MenuSheetUsecase().toggleSheet(MenuSheetUsecase().fontSheetKey, ref: ref);
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
                  color: ReaderBottomSheet.theme == subType ? colorScheme.primary : null,
                  onPressed: () {
                    MenuSheetUsecase().toggleSheet(MenuSheetUsecase().themeSheetKey, ref: ref);
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
                    color: ReaderBottomSheet.config == subType ? colorScheme.primary : null,
                    onPressed: () {
                      MenuSheetUsecase().toggleSheet(MenuSheetUsecase().configSheetKey, ref: ref);
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
