import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/data/model/catalog.dart';
import 'package:reader/reader/provider/catalog.dart';
import 'package:reader/reader/provider/config.dart';
import 'package:reader/reader/ui/components/render.dart';

class TextRenderUsecase {
  // static TextRenderUsecase? _instance;
  final BuildContext context;
  final BookModel book;

  TextRenderUsecase(this.context, {required this.book});

  // TextRenderUsecase._internal(this.context, this.book);
  // factory TextRenderUsecase(BuildContext context, {required BookModel book}) {
  //   _instance ??= TextRenderUsecase._internal(context, book);
  //   return _instance!;
  // }

  late TextRender render;

  // ignore: deprecated_member_use
  TextRenderUsecase init(AutoDisposeAsyncNotifierProviderRef<List<PagePainter>> ref, {required BookModel book}) {
    final readerConfig = ref.read(readerConfigProvider(context));
    render = TextRender(
        bookName: book.name,
        titlePaddingTop: readerConfig.titlePaddingTop,
        titlePaddingBottom: readerConfig.titlePaddingBottom,
        titleVolumeTextStyle:
            TextStyle(fontSize: 14, color: colorScheme.onSurface.withOpacity(0.5), fontFamily: readerConfig.fontFamily),
        titleChapterTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface.withOpacity(1),
            fontFamily: readerConfig.fontFamily),
        bodyTextStyle: readerConfig.bodyTextStyle.copyWith(color: colorScheme.onSurface),
        layoutWidth: MediaQuery.of(context).size.width,
        layoutHeight: MediaQuery.of(context).size.height,
        edgePadding: readerConfig.edgePadding,
        topInfoPadding: readerConfig.topInfoPadding,
        bottomInfoPadding: readerConfig.bottomInfoPadding);
    return this;
  }

  Future _getContent(ChapterModel chapter) async {
    return BookSourceService().action(uuid: book.bookSourceId!, act: "chapter", args: {"chapter_id": chapter.cid});
  }

  Future<List<PagePainter>> _getPagePainters(
    int vIndex,
    int cIndex, {
    // ignore: deprecated_member_use
    required AutoDisposeAsyncNotifierProviderRef<List<PagePainter>> ref,
    String? cid,
    bool useCache = true,
  }) async {
    final catalog = ref.read(catalogProvider(book)).asData!.value;
    final chapter = cid == null
        ? catalog.volumes[vIndex].chapters[cIndex]
        : catalog.flatChapterList.firstWhere((element) => element.cid == cid);
    final txt = await _getContent(chapter);
    return render.measure(
        text: txt['content'],
        chapterName: chapter.title,
        volumeIndex: vIndex,
        chapterIndex: cIndex,
        chapterId: chapter.cid,
        volumeName: catalog.volumes[vIndex].title);
  }

  // ignore: deprecated_member_use
  Future<List<PagePainter>> getPagePainters(int vIndex, int cIndex,
      {String? cid, int delay = 300, required AutoDisposeAsyncNotifierProviderRef<List<PagePainter>> ref}) async {
    return (await Future.wait(
            [_getPagePainters(vIndex, cIndex, ref: ref), Future.delayed(Duration(milliseconds: delay))]))
        .first as List<PagePainter>;
  }

  ColorScheme get colorScheme => Theme.of(context).colorScheme;
}
