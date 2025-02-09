import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reader/reader/provider/battery.dart';
import 'package:reader/reader/provider/extra.dart';
import 'package:reader/reader/provider/time.dart';

class ReaderPage extends HookConsumerWidget {
  final PagePainter pagePainter;
  final BuildContext context;

  double get titleIndicatorHeight => pagePainter.painters.first.height * .64;

  double get titleIndicatorPosX => pagePainter.painters.first.posX;

  double get titleIndicatorPosY => pagePainter.painters.first.posY + titleIndicatorHeight * .36;

  const ReaderPage({super.key, required this.pagePainter, required this.context});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extraConfig = ref.watch(readerExtraConfigProvider);
    final batteryInfo = ref.watch(readerBatteryProvider);
    final timeInfo = ref.watch(readerTimeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final infoTextStyle = pagePainter.infoTextStyle.copyWith(color: colorScheme.onSurface.withOpacity(.5));
    return Stack(
      key: ObjectKey({
        "cIndex": pagePainter.chapterIndex,
        "vIndex": pagePainter.volumeIndex,
      }),
      children: [
        ...pagePainter.painters.mapIndexed((index, painter) {
          double posY = painter.posY;
          double posX = painter.posX;
          if (index > 0) {
            if (painter.pageIndex > 0) {
              posY += pagePainter.extraParaPadding * index;
            } else {
              if (index > 1) {
                posY += pagePainter.extraParaPadding * (index - 1);
              }
            }
          }
          if (pagePainter.pageIndex == 0) {
            if (index == 0) {
              posX += 8.0;
            }
          }
          return Positioned(
            left: posX,
            top: posY,
            child: Text.rich(
              // painter.textSpan,
              TextSpan(
                text: painter.text,
                style: painter.renderStyle.copyWith(color: colorScheme.onSurface),
              ),
              textAlign: TextAlign.start,
            ),
          );
        }),
        if (pagePainter.pageIndex == 0)
          Positioned(
            left: titleIndicatorPosX,
            top: titleIndicatorPosY,
            child: Container(
              width: 5,
              height: titleIndicatorHeight,
              color: colorScheme.primary,
            ),
          ),
        Positioned(
            left: pagePainter.topInfoPadding.left,
            top: pagePainter.topInfoPadding.top,
            right: pagePainter.topInfoPadding.right,
            child: Row(
              children: [
                Text(pagePainter.pageIndex == 0 ? pagePainter.bookName : pagePainter.chapterName, style: infoTextStyle),
              ],
            )),
        Positioned(
            left: pagePainter.bottomInfoPadding.left,
            bottom: pagePainter.bottomInfoPadding.bottom,
            right: pagePainter.bottomInfoPadding.right,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (extraConfig.showTimeBattery)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(timeInfo, style: infoTextStyle),
                  ),
                if (extraConfig.showTimeBattery)
                  Transform.rotate(
                    angle: 3.14 / 2,
                    child: Icon(batteryInfo.value!.icon, size: 22, color: infoTextStyle.color),
                  ),
                const Spacer(),
                Text("${pagePainter.pageIndex + 1}/${pagePainter.totalPages}", style: infoTextStyle),
              ],
            ))
      ],
    );
  }
}

class PagePainter {
  final String chapterId;
  final TextStyle infoTextStyle;
  final EdgeInsets topInfoPadding;
  final EdgeInsets bottomInfoPadding;
  final List<TextSpanPainter> painters;
  final String bookName;
  final String chapterName;
  final String? volumeName;
  final int volumeIndex;
  final int chapterIndex;
  final int pageIndex;
  final double extraParaPadding;
  final double width;
  final double height;
  final bool withBookMark;
  int totalPages;
  int? flatIndex;

  PagePainter(
      {required this.chapterId,
      required this.infoTextStyle,
      required this.topInfoPadding,
      required this.bottomInfoPadding,
      required this.painters,
      required this.bookName,
      required this.chapterName,
      required this.volumeName,
      required this.volumeIndex,
      required this.chapterIndex,
      required this.pageIndex,
      required this.extraParaPadding,
      required this.width,
      required this.height,
      this.flatIndex,
      this.totalPages = 0,
      this.withBookMark = false});

  double get titleIndicatorHeight => painters.first.height * .8;

  double get titleIndicatorPosX => painters.first.posX;

  double get titleIndicatorPosY => painters.first.posY + titleIndicatorHeight * .1;

  @override
  toString() {
    return "PagePainter: $chapterId,pageIndex:$pageIndex,bookName:$bookName,chapterName:$chapterName,volumeName:$volumeName,volumeIndex:$volumeIndex,chapterIndex:$chapterIndex,flatIndex:$flatIndex";
  }

  PagePainter copyWith({
    String? chapterId,
    TextStyle? infoTextStyle,
    EdgeInsets? topInfoPadding,
    EdgeInsets? bottomInfoPadding,
    List<TextSpanPainter>? painters,
    String? bookName,
    String? chapterName,
    String? volumeName,
    int? volumeIndex,
    int? chapterIndex,
    int? pageIndex,
    int? flatIndex,
    double? extraParaPadding,
    double? width,
    double? height,
    int? totalPages,
    bool? withBookMark,
  }) {
    return PagePainter(
        chapterId: chapterId ?? this.chapterId,
        infoTextStyle: infoTextStyle ?? this.infoTextStyle,
        topInfoPadding: topInfoPadding ?? this.topInfoPadding,
        bottomInfoPadding: bottomInfoPadding ?? this.bottomInfoPadding,
        painters: painters ?? this.painters,
        bookName: bookName ?? this.bookName,
        chapterName: chapterName ?? this.chapterName,
        volumeName: volumeName ?? this.volumeName,
        volumeIndex: volumeIndex ?? this.volumeIndex,
        chapterIndex: chapterIndex ?? this.chapterIndex,
        flatIndex: flatIndex ?? this.flatIndex,
        pageIndex: pageIndex ?? this.pageIndex,
        extraParaPadding: extraParaPadding ?? this.extraParaPadding,
        width: width ?? this.width,
        height: height ?? this.height,
        totalPages: totalPages ?? this.totalPages,
        withBookMark: withBookMark ?? this.withBookMark);
  }
}

class TextSpanPainter {
  final String text;
  final TextStyle style;
  bool indent = true;
  double letterPadding = 0.0;
  bool justify = true;

  final double posX;
  double posY;
  final double height;
  final double width;

  final int paraIndex;
  final int paraLineIndex;
  int pageIndex = 0;
  final int chapterIndex;
  final int volumeIndex;

  TextSpanPainter({
    required this.text,
    required this.style,
    required this.posX,
    required this.posY,
    required this.width,
    required this.height,
    required this.paraIndex,
    required this.paraLineIndex,
    required this.chapterIndex,
    required this.volumeIndex,
    this.justify = true,
    this.pageIndex = 0,
    this.indent = true,
    this.letterPadding = 0.0,
  });

  TextStyle get renderStyle => style.copyWith(
        letterSpacing: justify ? letterPadding : null,
      );

  TextSpan get textSpan => TextSpan(text: text, style: renderStyle);

  String get linePos => "$volumeIndex,$chapterIndex,$paraIndex,$paraLineIndex";

  String get paraPos => "$volumeIndex,$chapterIndex,$paraIndex";

  @override
  toString() {
    return "TextSpanPainter: $text,posX:$posX,posY:$posY,width:$width,height:$height,paraIndex:$paraIndex,paraLineIndex:$paraLineIndex,pageIndex:$pageIndex,chapterIndex:$chapterIndex,volumeIndex:$volumeIndex";
  }
}

class TextRender {
  String bookName;
  EdgeInsets edgePadding;
  TextStyle bodyTextStyle;
  TextStyle titleVolumeTextStyle;
  TextStyle titleChapterTextStyle;
  double titlePaddingTop;
  double titlePaddingBottom;
  double titleVolumeChapterPadding;
  double paragraphPadding;
  double layoutWidth;
  double layoutHeight;
  bool indent;

  late EdgeInsets topInfoPadding;
  late EdgeInsets bottomInfoPadding;
  late TextStyle infoTextStyle;

  double _currentPosY = 0.0;
  double get _restHeight => layoutHeight - _currentPosY - edgePadding.bottom;

  late double _singleTextWidth;

  cleanPosY() {
    _currentPosY = titlePaddingTop;
  }

  /// 文本渲染器
  /// * [bookName] 书名
  /// * [layoutWidth] 渲染宽度
  /// * [layoutHeight] 渲染高度
  /// * [edgePadding] 外边距
  /// * [infoTextStyle] 信息文本样式
  /// * [bodyTextStyle]  正文文本样式
  /// * [titleVolumeTextStyle] 卷标题文本样式
  /// * [titlePaddingTop] 标题上边距
  /// * [titlePaddingBottom] 标题下边距
  /// * [titleChapterTextStyle] 标题文本样式
  /// * [titleVolumeChapterPadding] 卷标题与章节标题间距
  /// * [paragraphPadding] 段落间距
  /// * [indent] 是否首行缩进
  /// * [topInfoPadding] 顶部信息内边距(bottom 属性会被忽略)
  /// * [bottomInfoPadding] 底部信息内边距(top 属性会被忽略)
  TextRender({
    required this.bookName,
    required this.layoutHeight,
    required this.layoutWidth,
    this.edgePadding = EdgeInsets.zero,
    this.titleChapterTextStyle = const TextStyle(fontSize: 24, color: Colors.black, height: 1.7),
    this.titleVolumeTextStyle = const TextStyle(fontSize: 28, color: Colors.black, height: 1.7),
    this.titlePaddingTop = 16.0,
    this.titlePaddingBottom = 24.0,
    this.bodyTextStyle = const TextStyle(fontSize: 20, color: Colors.black, height: 1.7),
    this.titleVolumeChapterPadding = 0.0,
    this.paragraphPadding = 24.0,
    this.indent = true,
    EdgeInsets? topInfoPadding,
    EdgeInsets? bottomInfoPadding,
  }) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: "国", style: bodyTextStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    _singleTextWidth = textPainter.width;
    this.topInfoPadding =
        topInfoPadding ?? EdgeInsets.only(left: edgePadding.left, top: 0, right: edgePadding.right, bottom: 0);
    this.bottomInfoPadding =
        bottomInfoPadding ?? EdgeInsets.only(left: edgePadding.left, top: 0, right: edgePadding.right, bottom: 0);
    infoTextStyle = TextStyle(
        fontSize: 13,
        color: (bodyTextStyle.color ?? Colors.black).withOpacity(0.4),
        fontFamily: bodyTextStyle.fontFamily);
  }

  double get renderWidth => layoutWidth - edgePadding.left - edgePadding.right;
  double get renderHeight => layoutHeight - edgePadding.bottom;

  List<PagePainter> measure({
    required String chapterName,
    required int volumeIndex,
    required int chapterIndex,
    required String chapterId,
    int? flatIndex,
    String? volumeName,
    String? text,
    List<String>? textArr,
  }) {
    assert(
      text != null || textArr != null,
      "text 和 textArr 不能同时为空",
    );
    _currentPosY = titlePaddingTop;
    textArr ??= text?.split("\n") ?? [];
    final List<TextSpanPainter> pageSpanBuffer = [];
    final List<PagePainter> pages = [];
    int page = 0;

    // 绘制卷名（如果存在的话）
    if (volumeName != null) {
      final volumePainter = _drawVolumeName(volumeName, volumeIndex, chapterIndex);
      pageSpanBuffer.add(volumePainter);
      _currentPosY += volumePainter.height + titleVolumeChapterPadding;
    }

    // 绘制章节名
    final chapterPainter = _drawChapterName(chapterName, volumeIndex, chapterIndex);
    pageSpanBuffer.add(chapterPainter);
    _currentPosY += chapterPainter.height + titlePaddingBottom;

    // 标定是否是段落新的段落（在换页时可能把上一段剩余的内容推送到数组的首位，这时候新页面第一段不应该缩进）
    bool firstLineIsPara = true;
    int _paraIndex = 0;
    int _paraLineIndex = 0;
    // 绘制正文内容
    while (textArr.isNotEmpty) {
      String textPara = textArr.first.trim();
      if (textPara.isEmpty) {
        textArr.removeAt(0);
        continue;
      }
      bool indent = this.indent && firstLineIsPara;
      final textPainter = TextPainter(
        text: TextSpan(text: (indent ? "国国" : "") + textPara, style: bodyTextStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(maxWidth: renderWidth);
      final textLines = textPainter.computeLineMetrics();
      bool _justifyLine = true;
      int _startIndex = 0;
      int _endIndex = 0;
      if (_restHeight >= textPainter.height) {
        // 如果当前页面剩余空间可以容纳当前段落
        for (int i = 0; i < textLines.length; i++) {
          final line = textLines[i];
          final lineEndOffset = textPainter.getPositionForOffset(Offset(line.width, line.baseline)).offset;
          _endIndex = lineEndOffset;
          if (indent) _endIndex -= 2;
          final lineText = textPara.substring(_startIndex, _endIndex);
          if (i == textLines.length - 1) {
            _justifyLine = false;
          }
          pageSpanBuffer.add(TextSpanPainter(
              text: lineText,
              style: bodyTextStyle,
              posX: edgePadding.left + ((indent && i == 0) ? 2 * _singleTextWidth : 0),
              posY: _currentPosY,
              width: renderWidth,
              height: line.height,
              letterPadding: (renderWidth - line.width) / (lineText.length),
              justify: _justifyLine,
              paraIndex: _paraIndex,
              paraLineIndex: _paraLineIndex + i,
              chapterIndex: chapterIndex,
              volumeIndex: volumeIndex,
              pageIndex: page));
          _currentPosY += line.height;
          _startIndex = _endIndex;
        }
        _currentPosY += paragraphPadding;
        textArr.removeAt(0);
        _paraIndex++;
        _paraLineIndex = 0;
        firstLineIsPara = true;
      } else {
        // 放不下，只能尽可能多放入当前页面
        for (int i = 0; i < textLines.length; i++) {
          final line = textLines[i];
          final lineEndOffset = textPainter.getPositionForOffset(Offset(line.width, line.baseline)).offset;
          _endIndex = lineEndOffset;
          if (indent) _endIndex -= 2;
          final lineText = textPara.substring(_startIndex, _endIndex);
          if (_restHeight > line.height) {
            pageSpanBuffer.add(TextSpanPainter(
                text: lineText,
                style: bodyTextStyle,
                posX: edgePadding.left + ((indent && i == 0) ? 2 * _singleTextWidth : 0),
                posY: _currentPosY,
                width: renderWidth,
                height: line.height,
                letterPadding: (renderWidth - line.width) / (lineText.length),
                justify: true,
                paraIndex: _paraIndex,
                paraLineIndex: (_paraLineIndex),
                chapterIndex: chapterIndex,
                volumeIndex: volumeIndex,
                pageIndex: page));
            _currentPosY += line.height;
            _startIndex = _endIndex;
            _paraLineIndex++;
          } else {
            // 本页已结束，把剩余的文本放到下一页
            textArr[0] = textPara.substring(_startIndex);
            final lastPainter = pageSpanBuffer.last;
            final restHeight = renderHeight - lastPainter.posY - lastPainter.height;
            pages.add(PagePainter(
                chapterId: chapterId,
                topInfoPadding: topInfoPadding,
                bottomInfoPadding: bottomInfoPadding,
                painters: [...pageSpanBuffer],
                bookName: bookName,
                chapterName: chapterName,
                volumeIndex: volumeIndex,
                chapterIndex: chapterIndex,
                pageIndex: page,
                volumeName: volumeName,
                width: renderWidth,
                height: renderHeight,
                infoTextStyle: infoTextStyle,
                extraParaPadding: restHeight / (pageSpanBuffer.length - 1)));
            pageSpanBuffer.clear();
            _currentPosY = edgePadding.top;
            firstLineIsPara = i == 0;
            page++;
            break;
          }
        }
      }
    }

    if (pageSpanBuffer.isNotEmpty) {
      pages.add(PagePainter(
          chapterId: chapterId,
          topInfoPadding: topInfoPadding,
          bottomInfoPadding: bottomInfoPadding,
          painters: [...pageSpanBuffer],
          bookName: bookName,
          chapterName: chapterName,
          volumeIndex: volumeIndex,
          chapterIndex: chapterIndex,
          pageIndex: page,
          volumeName: volumeName,
          width: renderWidth,
          height: renderHeight,
          infoTextStyle: infoTextStyle,
          extraParaPadding: 0));
      pageSpanBuffer.clear();
    }

    return pages
        .map((page) => page
          ..totalPages = pages.length
          ..flatIndex = flatIndex)
        .toList();
  }

  /// 绘制卷名
  _drawVolumeName(String volumeName, int volumeIndex, int chapterIndex) {
    final TextPainter volumePainter = TextPainter(
      text: TextSpan(text: volumeName, style: titleVolumeTextStyle),
      textDirection: TextDirection.ltr,
    );
    volumePainter.layout(maxWidth: renderWidth);
    // _currentPosY += titlePaddingTop;
    return TextSpanPainter(
        text: volumeName,
        style: titleVolumeTextStyle,
        posX: edgePadding.left,
        posY: _currentPosY,
        width: volumePainter.width,
        height: volumePainter.height,
        paraIndex: -1,
        paraLineIndex: -1,
        chapterIndex: chapterIndex,
        volumeIndex: volumeIndex,
        pageIndex: 0);
  }

  /// 绘制章节名
  _drawChapterName(String chapterName, int volumeIndex, int chapterIndex) {
    final TextPainter chapterPainter = TextPainter(
      text: TextSpan(text: chapterName, style: titleChapterTextStyle),
      textDirection: TextDirection.ltr,
    );
    chapterPainter.layout(maxWidth: renderWidth);
    return TextSpanPainter(
        text: chapterName,
        style: titleChapterTextStyle,
        posX: edgePadding.left,
        posY: _currentPosY,
        width: chapterPainter.width,
        height: chapterPainter.height,
        paraIndex: -1,
        paraLineIndex: -1,
        chapterIndex: chapterIndex,
        volumeIndex: volumeIndex,
        pageIndex: 0);
  }
}
