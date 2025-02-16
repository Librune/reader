import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/architecture/service/book_source.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/data/model/catalog.dart';
import 'package:reader/reader/data/model/config.dart';
import 'package:reader/reader/ui/components/render.dart';
import 'package:reader/reader/usecase/progress_usecase.dart';
import 'package:reader/reader/usecase/provider_usecase.dart';

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

  final _cache = SplayTreeMap<String, dynamic>();

  // ignore: deprecated_member_use
  TextRenderUsecase init(AsyncNotifierProviderRef<List<PagePainter>> ref) {
    final readerConfig = ref.read(ProviderUsecase().config);
    render = TextRender(
        bookName: book.name,
        titlePaddingTop: readerConfig.titlePaddingTop,
        titlePaddingBottom: readerConfig.titlePaddingBottom,
        titleVolumeTextStyle: TextStyle(
            fontSize: 14,
            color: colorScheme.onSurface.withOpacity(0.5),
            fontFamily: readerConfig.fontFamily),
        titleChapterTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface.withOpacity(1),
            fontFamily: readerConfig.fontFamily),
        bodyTextStyle:
            readerConfig.bodyTextStyle.copyWith(color: colorScheme.onSurface),
        layoutWidth: MediaQuery.of(context).size.width,
        layoutHeight: MediaQuery.of(context).size.height,
        edgePadding: readerConfig.edgePadding,
        topInfoPadding: readerConfig.topInfoPadding,
        bottomInfoPadding: readerConfig.bottomInfoPadding);
    return this;
  }

  updateConfig(ReaderConfigModel readerConfig) {
    render = TextRender(
        bookName: book.name,
        titlePaddingTop: readerConfig.titlePaddingTop,
        titlePaddingBottom: readerConfig.titlePaddingBottom,
        titleVolumeTextStyle: TextStyle(
            fontSize: 14,
            color: colorScheme.onSurface.withOpacity(0.5),
            fontFamily: readerConfig.fontFamily),
        titleChapterTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface.withOpacity(1),
            fontFamily: readerConfig.fontFamily),
        bodyTextStyle:
            readerConfig.bodyTextStyle.copyWith(color: colorScheme.onSurface),
        layoutWidth: MediaQuery.of(context).size.width,
        layoutHeight: MediaQuery.of(context).size.height,
        edgePadding: readerConfig.edgePadding,
        topInfoPadding: readerConfig.topInfoPadding,
        bottomInfoPadding: readerConfig.bottomInfoPadding);
  }

  Future _getContent(ChapterModel chapter) async {
    return BookSourceService().action(
        uuid: book.bookSourceId!,
        act: "chapter",
        args: {"chapter_id": chapter.cid});
  }

  Future<List<PagePainter>> _getPagePainters({
    // ignore: deprecated_member_use
    required AsyncNotifierProviderRef<List<PagePainter>> ref,
    String? cid,
    int? fIndex,
    // int? vIndex,
    // int? cIndex,
    bool useCache = false,
  }) async {
    final flatCatalog =
        ref.read(ProviderUsecase().catalog).asData!.value.flatChapterList;
    late ChapterModel chapter;
    if (cid != null) {
      chapter = flatCatalog.firstWhere((element) => element.cid == cid);
      fIndex = flatCatalog.indexOf(chapter);
    } else {
      chapter = flatCatalog[fIndex!];
    }
    late final dynamic txt;
    if (useCache) {
      txt = _cache[chapter.cid];
    } else {
      txt = await _getContent(chapter);
      _cache[chapter.cid] = txt;
    }
    return render.measure(
        text: txt['content'],
        chapterName: chapter.title,
        volumeIndex: chapter.volumeIndex!,
        chapterIndex: chapter.chapterIndex!,
        chapterId: chapter.cid,
        flatIndex: fIndex,
        volumeName: chapter.volumeName!);
  }

  // ignore: deprecated_member_use
  Future<List<PagePainter>> getPagePainters(
      {int delay = 300,
      // ignore: deprecated_member_use
      required AsyncNotifierProviderRef<List<PagePainter>> ref,
      bool useCache = false}) async {
    final cid = ProgressUsecase().progress.chapterId;
    return (await Future.wait([
      _getPagePainters(cid: cid, ref: ref, useCache: useCache),
      Future.delayed(Duration(milliseconds: useCache ? 0 : delay))
    ]))
        .first as List<PagePainter>;
  }

  Future<List<PagePainter>> getNextPagePainters(
      {required AsyncNotifierProviderRef<List<PagePainter>> ref}) async {
    final fIndex = ProgressUsecase().progress.flatIndex! + 1;
    return _getPagePainters(fIndex: fIndex, ref: ref);
  }

  Future<List<PagePainter>> getPrevPagePainters(
      {required AsyncNotifierProviderRef<List<PagePainter>> ref}) async {
    final fIndex = ProgressUsecase().progress.flatIndex! - 1;
    return _getPagePainters(fIndex: fIndex, ref: ref);
  }

  ColorScheme get colorScheme => Theme.of(context).colorScheme;
}
