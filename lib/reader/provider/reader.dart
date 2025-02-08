import 'package:flutter/material.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/data/model/catalog.dart';
import 'package:reader/reader/data/model/config.dart';
import 'package:reader/reader/data/model/extra.dart';
import 'package:reader/reader/ui/components/pages/slider/page_slider.dart';
import 'package:reader/reader/ui/components/render.dart';
import 'package:reader/reader/usecase/menu_sheet_usecase.dart';
import 'package:reader/reader/usecase/progress_usecase.dart';
import 'package:reader/reader/usecase/provider_usecase.dart';
import 'package:reader/reader/usecase/text_render_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reader.g.dart';

@riverpod
class Reader extends _$Reader {
  late double screenWidth;
  late double screenHeight;

  late CatalogModel catalog;

  late final TextRenderUsecase textRenderUsecase;

  bool isLoadingNextChapter = false;
  bool isLoadingPrevChapter = false;

  late final PageSliderController pageSliderController;

  late ReaderExtraModal extra;

  @override
  Future<List<PagePainter>> build(
    BookModel book, {
    required BuildContext context,
  }) async {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    await ref.read(ProviderUsecase().theme.future);
    catalog = await ref.read(ProviderUsecase().catalog.future);
    // 初始化进度管理
    await ProgressUsecase().init(catalog);
    // 额外设置
    extra = ref.read(ProviderUsecase().extra);
    // ignore: use_build_context_synchronously
    textRenderUsecase = TextRenderUsecase(context, book: book).init(ref);
    final res = await textRenderUsecase.getPagePainters(ref: ref);
    ref.listen(ProviderUsecase().config, _configListener);
    final page = ProgressUsecase().detectPage(res);
    pageSliderController = PageSliderController(initialPage: page);
    return res;
  }

  onPageChange(int page) async {
    final pagePainter = state.value![page];
    ProgressUsecase().update(page: pagePainter);
    ref.read(cidProvider.notifier).update(pagePainter.chapterId);
    // 判断是否需要加载下一章
    if (page == state.value!.length - 1) {
      final lastPage = state.value!.last;
      final cachedLastPageFlatIndex = lastPage.flatIndex!;
      if (catalog.flatChapterList.length > cachedLastPageFlatIndex + 1) {
        isLoadingNextChapter = true;
        try {
          final nextPage = await textRenderUsecase.getNextPagePainters(ref: ref);
          appendPages(nextPage);
        } finally {
          isLoadingNextChapter = false;
        }
      }
    } else if (page == 0) {
      final firstPage = state.value!.first;
      final cachedFirstPageFlatIndex = firstPage.flatIndex!;
      if (cachedFirstPageFlatIndex > 0) {
        isLoadingPrevChapter = true;
        try {
          final prevPage = await textRenderUsecase.getPrevPagePainters(ref: ref);
          prependPages(prevPage);
        } finally {
          isLoadingPrevChapter = false;
        }
      }
    }
  }

  jumpToChapter(ChapterModel chapter) async {
    ProgressUsecase().jumpChapter(chapter: chapter);
    // state = AsyncValue.loading();
    MenuSheetUsecase().closeAll(ref);
    final pages = await textRenderUsecase.getPagePainters(ref: ref);
    state = AsyncData(pages);
    Future.microtask(() {
      pageSliderController.jumpToPage(0);
    });
  }

  appendPages(List<PagePainter> pages) {
    state = AsyncValue.data([...state.value!, ...pages]);
  }

  prependPages(List<PagePainter> pages) {
    state = AsyncValue.data([...pages, ...state.value!]);
    pageSliderController.jumpToPage(pages.length);
  }

  _configListener(ReaderConfigModel? oldValue, ReaderConfigModel newValue) {
    if (oldValue != null) {
      textRenderUsecase.updateConfig(newValue);
      textRenderUsecase.getPagePainters(ref: ref, useCache: true).then((value) {
        state = AsyncData(value);
        pageSliderController.jumpToPage(ProgressUsecase().detectPage(value));
      });
    }
  }
}
