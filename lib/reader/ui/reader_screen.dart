import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/ui/components/bottom_bar.dart';
import 'package:reader/reader/ui/components/pages/slider/page_slider.dart';
import 'package:reader/reader/ui/components/top_bar.dart';
import 'package:reader/reader/usecase/gesture_usecase.dart';
import 'package:reader/reader/usecase/menu_sheet_usecase.dart';
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
    final colorScheme = ColorScheme.fromSeed(seedColor: Color(0xFFFFDE3F));
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (ref.read(ProviderUsecase().menu.select((value) => value.sub))) {
          MenuSheetUsecase().close();
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
              child: switch (reader) {
                AsyncValue(:final value?) => Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        top: 0,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            Log.f('constraints: $constraints');
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                color: colorScheme.surfaceContainerHigh,
                                child: PageSlider(
                                  itemBuilder: (context, index) {
                                    return ReaderPage(pagePainter: value[index], context: context);
                                  },
                                  controller: ref.read(ProviderUsecase().reader.notifier).pageSliderController,
                                  itemCount: value.length,
                                  onPageChanged: (page) {
                                    ref.read(ProviderUsecase().reader.notifier).onPageChange(page);
                                  },
                                  callMenu: () {
                                    GestureUsecase(ref).callMenu();
                                  },
                                ));
                          },
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final subVisible = ref.watch(ProviderUsecase().menu.select((value) => value.sub));
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
                      TopBar(book: widget.book),
                      BottomBar(
                          book: widget.book,
                          onChapterTap: (chapter) {
                            ref.read(ProviderUsecase().reader.notifier).jumpToChapter(chapter);
                          }),
                    ],
                  ),
                _ => Center(
                    child: CircularProgressIndicator(),
                  ),
              })),
    );
  }
}
