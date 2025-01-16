import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GradualLabel extends HookConsumerWidget {
  const GradualLabel(
      {super.key,
      required this.label,
      required this.decorationColors,
      this.labelStyle,
      this.decorationHeight = 8,
      this.decorationWidth = 42});
  final String label;
  final TextStyle? labelStyle;
  final List<Color> decorationColors;
  final double decorationHeight;
  final double decorationWidth;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: labelStyle ?? Theme.of(context).textTheme.bodyLarge!,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // 计算总高度：文字高度 + 2像素间距 + 装饰高度
    final totalHeight = textPainter.height + 2 + decorationHeight;
    return CustomPaint(
      size: Size(textPainter.width, totalHeight), // 设置具体大小
      painter: _GradualLabelPainter(
        label: label,
        labelStyle: labelStyle ?? Theme.of(context).textTheme.bodyLarge!,
        decorationColors: decorationColors,
        decorationHeight: decorationHeight,
        decorationWidth: decorationWidth,
      ),
    );
  }
}

class _GradualLabelPainter extends CustomPainter {
  final String label;
  final TextStyle labelStyle;
  final List<Color> decorationColors;
  final double decorationHeight;
  final double decorationWidth;

  _GradualLabelPainter({
    required this.label,
    required this.labelStyle,
    required this.decorationColors,
    required this.decorationHeight,
    required this.decorationWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 先预计算文字尺寸
    final textPainter = TextPainter(
      text: TextSpan(text: label, style: labelStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    // 1. 先绘制渐变色装饰
    final gradient = LinearGradient(
      colors: decorationColors,
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(
          0,
          textPainter.height - 6, // 调整装饰位置
          textPainter.width,
          decorationHeight,
        ),
      );

    canvas.drawRect(
      Rect.fromLTWH(
        0,
        textPainter.height - decorationHeight,
        decorationWidth,
        decorationHeight,
      ),
      paint,
    );

    // 2. 然后绘制文字
    textPainter.paint(canvas, Offset.zero);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
