import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:reader/app/architecture/service/path.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/data/model/menu.dart';
import 'package:reader/reader/data/model/theme.dart';
import 'package:reader/reader/ui/components/bottom_bar.dart';
import 'package:reader/reader/ui/components/bottom_sheet.dart';
import 'package:reader/reader/ui/components/pages/slider/page_slider.dart';
import 'package:reader/reader/ui/components/sheets/catalog.dart';
import 'package:reader/reader/ui/components/sheets/config.dart';
import 'package:reader/reader/ui/components/sheets/font.dart';
import 'package:reader/reader/ui/components/sheets/theme.dart';
import 'package:reader/reader/ui/components/top_bar.dart';
import 'package:reader/reader/usecase/menu_sheet_usecase.dart';
import 'package:reader/reader/usecase/progress_usecase.dart';
import 'package:reader/reader/usecase/provider_usecase.dart';

import 'components/render.dart';

class ReaderScreen extends StatefulHookConsumerWidget {
  const ReaderScreen({super.key, required this.book});
  final BookModel book;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      ProviderUsecase().init(book: widget.book, context: context);
      return null;
    }, []);
    // final provider = readerProvider(book, context: context);
    final reader = ref.watch(ProviderUsecase().reader);
    // final colorScheme = ColorScheme.fromSeed(seedColor: Color(0xFFFFDE3F));
    final themeId = ref.watch(ProviderUsecase().config.select((value) => value.theme));
    final themeModel = ReaderThemeModel.fromJson(
        jsonDecode(File(join(PathService().readerThemesPath, themeId, 'index.json')).readAsStringSync()));
    final colorScheme =
        Theme.of(context).brightness == Brightness.dark ? themeModel.darkColorScheme : themeModel.colorScheme;
    final backgroundPngFile = File(join(PathService().readerThemesPath, themeId, 'image.png'));
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (ref.read(ProviderUsecase().menu.select((value) => value.sub))) {
            // MenuSheetUsecase().close();
            MenuSheetUsecase().toggleMenu(ref);
          } else if (ref.read(ProviderUsecase().menu.select((value) => value.bottom))) {
            ref.read(ProviderUsecase().menu.notifier).closeBottom();
            ref.read(ProviderUsecase().menu.notifier).closeTop();
          } else {
            context.pop();
          }
        },
        child: Theme(
          data: ThemeData(colorScheme: colorScheme),
          child: Material(
              color: colorScheme.surfaceContainerHigh,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    top: 0,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        Log.f('constraints: $constraints');
                        return reader.when(
                          data: (value) {
                            return Container(
                                decoration: BoxDecoration(
                                  image: backgroundPngFile.existsSync()
                                      ? DecorationImage(
                                          image: FileImage(backgroundPngFile),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  color: colorScheme.surfaceContainer.withAlpha(180),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: PageSlider(
                                  itemBuilder: (context, index) {
                                    return ReaderPage(pagePainter: value[index], context: context);
                                  },
                                  controller: ref.read(ProviderUsecase().reader.notifier).pageSliderController,
                                  itemCount: value.length,
                                  onPageChanged: (index) {
                                    ref.read(ProviderUsecase().reader.notifier).onPageChange(index);
                                  },
                                  toggleMenu: () {
                                    MenuSheetUsecase().toggleMenu(ref);
                                  },
                                ));
                          },
                          error: (error, stackTrace) {
                            return Center(
                              child: Text(
                                error.toString(),
                                style: TextStyle(color: colorScheme.onSurface.withAlpha(150), fontSize: 16),
                              ),
                            );
                          },
                          loading: () {
                            return Center(
                              child: Text(
                                "正在加载……",
                                style: TextStyle(color: colorScheme.onSurface.withAlpha(150), fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // Consumer(
                  //   builder: (context, ref, child) {
                  //     final subVisible = ref.watch(ProviderUsecase().menu.select((value) => value.sub));
                  //     return IgnorePointer(
                  //       ignoring: !subVisible,
                  //       child: Scaffold(
                  //         backgroundColor: Colors.transparent,
                  //         key: MenuSheetUsecase().sheetCtx,
                  //         body: GestureDetector(
                  //           onTap: () {
                  //             MenuSheetUsecase().close();
                  //           },
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  TopBar(book: widget.book),
                  PersistentBottomSheet(
                      type: ReaderBottomSheet.catalog,
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 64),
                      key: MenuSheetUsecase().catalogSheetKey,
                      maxHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 48,
                      onHide: (triggeredByDrag) {
                        MenuSheetUsecase().onSheetDragHide(MenuSheetUsecase().catalogSheetKey,
                            ref: ref, triggeredByDrag: triggeredByDrag);
                      },
                      child: CatalogSheetContent()),
                  PersistentBottomSheet(
                      type: ReaderBottomSheet.font,
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 50, left: 4, right: 4),
                      key: MenuSheetUsecase().fontSheetKey,
                      maxHeight: 360,
                      onHide: (triggeredByDrag) {
                        MenuSheetUsecase().onSheetDragHide(MenuSheetUsecase().fontSheetKey,
                            ref: ref, triggeredByDrag: triggeredByDrag);
                      },
                      child: FontSheetContent()),
                  PersistentBottomSheet(
                      type: ReaderBottomSheet.theme,
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 72),
                      key: MenuSheetUsecase().themeSheetKey,
                      maxHeight: 600,
                      onHide: (triggeredByDrag) {
                        MenuSheetUsecase().onSheetDragHide(MenuSheetUsecase().themeSheetKey,
                            ref: ref, triggeredByDrag: triggeredByDrag);
                      },
                      child: ThemeSheetContent()),
                  PersistentBottomSheet(
                      type: ReaderBottomSheet.config,
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 72),
                      key: MenuSheetUsecase().configSheetKey,
                      maxHeight: MediaQuery.of(context).size.height / 2,
                      onHide: (triggeredByDrag) {
                        MenuSheetUsecase().onSheetDragHide(MenuSheetUsecase().configSheetKey,
                            ref: ref, triggeredByDrag: triggeredByDrag);
                      },
                      child: ConfigSheetContent()),
                  BottomBar(),
                ],
              )),
        ));
  }
}
