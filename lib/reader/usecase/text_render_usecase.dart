import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/app/data/model/book.dart';
import 'package:reader/reader/provider/config.dart';
import 'package:reader/reader/ui/components/render.dart';

class TextRenderUsecase {
  static TextRenderUsecase? _instance;
  final BuildContext context;

  TextRenderUsecase._internal(this.context);
  factory TextRenderUsecase(BuildContext context) {
    _instance ??= TextRenderUsecase._internal(context);
    return _instance!;
  }

  late TextRender render;

  void init(AutoDisposeAsyncNotifierProviderRef<List<PagePainter>> ref, {required BookModel book}) {
    final readerConfig = ref.read(readerConfigProvider);
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
  }

  ColorScheme get colorScheme => Theme.of(context).colorScheme;
}
