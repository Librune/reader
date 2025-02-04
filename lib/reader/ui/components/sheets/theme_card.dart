import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ThemeSheetCard extends StatefulHookConsumerWidget {
  final ColorScheme colorScheme;
  final ImageProvider image;
  final String name;
  final String author;
  final bool isSelected;
  final ValueChanged<bool> onSelect;

  const ThemeSheetCard({
    super.key,
    required this.colorScheme,
    required this.image,
    required this.name,
    required this.author,
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
    final ImageStream stream = widget.image.resolve(const ImageConfiguration());
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
        widget.onSelect(!widget.isSelected);
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

    // 绘制前景遮罩，使用 colorScheme.surfaceContainer，单一颜色和固定透明度
    final maskPaint = Paint()..color = colorScheme.surfaceContainer.withOpacity(0.15);
    canvas.drawRect(rect, maskPaint);

    // 裁剪绘图区域，确保超出卡片范围的装饰不被绘制
    canvas.save();
    canvas.clipRect(rect);

    // 绘制多个同心圆环作为装饰，以左上角为圆心
    const int ringCount = 6;
    // 计算左上角到卡片对角线末端的最远距离作为最大半径
    final double maxRadius = sqrt(size.width * size.width + size.height * size.height);
    final double radiusStep = maxRadius / ringCount;
    final Paint ringPaint = Paint()
      ..color = colorScheme.onSurface.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int i = 1; i <= ringCount; i++) {
      canvas.drawCircle(const Offset(0, 0), i * radiusStep, ringPaint);
    }
    canvas.restore();

    // 绘制卡片边框，用以提高区分边界
    final Paint borderPaint = Paint()
      ..color = colorScheme.outline.withAlpha(100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(rect, borderPaint);

    // 绘制标题与作者文字 (底部左侧) 并附加内边距
    final TextStyle nameStyle = TextStyle(
      color: colorScheme.onPrimaryContainer,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    final TextStyle authorStyle = TextStyle(
      color: colorScheme.onPrimaryContainer,
      fontSize: 12,
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

    // 绘制 radio 按钮 (右上角)
    const double radioRadius = 10.0;
    final Offset radioCenter = Offset(size.width - radioRadius - padding, radioRadius + padding);
    final Paint radioOutline = Paint()
      ..color = colorScheme.onSurface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(radioCenter, radioRadius, radioOutline);
    if (isSelected) {
      final Paint fillPaint = Paint()..color = colorScheme.primary;
      canvas.drawCircle(radioCenter, radioRadius - 3, fillPaint);
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
