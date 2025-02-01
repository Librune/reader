import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/utils/log.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/data/model/catalog.dart';
import 'package:reader/reader/provider/catalog.dart';
import 'package:reader/reader/ui/components/render.dart';
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

  @override
  Future<List<PagePainter>> build(
    BookModel book, {
    required BuildContext context,
  }) async {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    catalog = await ref.read(catalogProvider(book).future);
    // ignore: use_build_context_synchronously
    textRenderUsecase = TextRenderUsecase(context, book: book).init(ref, book: book);
    final res = await textRenderUsecase.getPagePainters(fIndex: 0, ref: ref);
    Log.e(res, "Reader build");
    return res;
  }

  onPageChange(int page) async {
    // 判断是否需要加载下一章
    if (page == state.value!.length - 1) {
      final lastPage = state.value!.last;
      final cachedLastPageFlatIndex = lastPage.flatIndex!;
      if (catalog.flatChapterList.length > cachedLastPageFlatIndex + 1) {
        isLoadingNextChapter = true;
        try {
          final nextPage = await textRenderUsecase.getPagePainters(fIndex: cachedLastPageFlatIndex + 1, ref: ref);
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
          final prevPage = await textRenderUsecase.getPagePainters(fIndex: cachedFirstPageFlatIndex - 1, ref: ref);
          prependPages(prevPage);
        } finally {
          isLoadingPrevChapter = false;
        }
      }
    }
  }

  appendPages(List<PagePainter> pages) {
    state = AsyncValue.data([...state.value!, ...pages]);
  }

  prependPages(List<PagePainter> pages) {
    state = AsyncValue.data([...pages, ...state.value!]);
  }
}
