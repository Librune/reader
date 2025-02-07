import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:reader/app/architecture/service/path.dart';

class ThemeSheetCard extends StatefulHookConsumerWidget {
  final ColorScheme colorScheme;
  final String name;
  final String author;
  final String id;
  final bool isSelected;
  final ValueChanged<String> onSelect;

  const ThemeSheetCard({
    super.key,
    required this.colorScheme,
    required this.name,
    required this.author,
    required this.id,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ThemeSheetCardState();
}

class _ThemeSheetCardState extends ConsumerState<ThemeSheetCard> {
  ui.Image? _backgroundImage;

  @override
  void initState() {
    super.initState();
    _resolveImage();
  }

  void _resolveImage() {
    final ImageProvider image = FileImage(File(join(PathService().readerThemesPath, widget.id, 'image.png')));
    final ImageStream stream = image.resolve(const ImageConfiguration());
    stream.addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _backgroundImage = info.image;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelect(widget.id);
      },
      child: CustomPaint(
        painter: _ThemeCardPainter(
          backgroundImage: _backgroundImage,
          colorScheme: widget.colorScheme,
          name: widget.name,
          author: widget.author,
          isSelected: widget.isSelected,
        ),
        // 外部 grid 组件会约束尺寸
        child: Container(),
      ),
    );
  }
}

class _ThemeCardPainter extends CustomPainter {
  final ui.Image? backgroundImage;
  final ColorScheme colorScheme;
  final String name;
  final String author;
  final bool isSelected;

  _ThemeCardPainter({
    required this.backgroundImage,
    required this.colorScheme,
    required this.name,
    required this.author,
    required this.isSelected,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    const double padding = 12.0;
    final RRect rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8.0));

    // 使用圆角裁剪背景内容
    canvas.save();
    canvas.clipRRect(rrect);
    // 绘制背景图（自动剪裁填充），若图片未加载则使用占位色
    if (backgroundImage != null) {
      paintImage(
        canvas: canvas,
        rect: rect,
        image: backgroundImage!,
        fit: BoxFit.cover,
      );
    } else {
      canvas.drawRect(rect, Paint()..color = colorScheme.surfaceVariant);
    }
    canvas.restore();

    // 绘制前景遮罩，不影响背景图片展示
    final maskPaint = Paint()..color = colorScheme.surfaceContainer.withOpacity(0.15);
    canvas.drawRect(rect, maskPaint);

    // 绘制三个嵌套圆（圆环效果），圆心设置在左上角，
    // 使用 clipRRect 裁切溢出部分
    canvas.save();
    canvas.clipRRect(rrect);
    final Offset circleCenter = const Offset(0, 0);
    final double outerRadius = size.height;
    final double midRadius = outerRadius * 0.66;
    final double innerRadius = outerRadius * 0.33;
    final Paint outerPaint = Paint()..color = colorScheme.secondaryContainer.withOpacity(0.1);
    final Paint midPaint = Paint()..color = colorScheme.primaryContainer.withOpacity(0.1);
    final Paint innerPaint = Paint()..color = colorScheme.primary.withOpacity(0.1);
    canvas.drawCircle(circleCenter, outerRadius, outerPaint);
    canvas.drawCircle(circleCenter, midRadius, midPaint);
    canvas.drawCircle(circleCenter, innerRadius, innerPaint);
    canvas.restore();

    // 重新设计边框：使用圆角矩形和较柔和的颜色，让边框存在但不过分割裂整体感
    // final Paint borderPaint = Paint()
    //   ..color = colorScheme.outline.withOpacity(0.5)
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 1;
    // canvas.drawRRect(rrect, borderPaint);

    // 绘制标题与作者文字 (底部左侧) 并附加内边距
    final TextStyle nameStyle = TextStyle(
      color: colorScheme.onPrimaryContainer,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    final TextStyle authorStyle = TextStyle(
      color: colorScheme.onPrimaryContainer.withAlpha(200),
      fontSize: 14,
    );
    final TextPainter namePainter = TextPainter(
      text: TextSpan(text: name, style: nameStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '...',
    );
    final TextPainter authorPainter = TextPainter(
      text: TextSpan(text: author, style: authorStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '...',
    );
    namePainter.layout(maxWidth: size.width - 2 * padding);
    authorPainter.layout(maxWidth: size.width - 2 * padding);
    final double textTotalHeight = namePainter.height + 4 + authorPainter.height;
    final double textY = size.height - textTotalHeight - padding;
    namePainter.paint(canvas, Offset(padding, textY));
    authorPainter.paint(canvas, Offset(padding, textY + namePainter.height + 4));

    // 重新设计 radio 样式，使其颜色和尺寸更加和谐精致
    const double radioOuterRadius = 8.0;
    const double radioInnerRadius = 4.0;
    final Offset radioCenter = Offset(
      size.width - radioOuterRadius - padding,
      radioOuterRadius + padding,
    );
    final Paint radioOuterPaint = Paint()
      ..color = colorScheme.onSurface.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(radioCenter, radioOuterRadius, radioOuterPaint);
    if (isSelected) {
      final Paint radioFillPaint = Paint()
        ..color = colorScheme.primary
        ..style = PaintingStyle.fill;
      canvas.drawCircle(radioCenter, radioInnerRadius, radioFillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ThemeCardPainter oldDelegate) {
    return oldDelegate.backgroundImage != backgroundImage ||
        oldDelegate.name != name ||
        oldDelegate.author != author ||
        oldDelegate.isSelected != isSelected ||
        oldDelegate.colorScheme != colorScheme;
  }
}
