import 'package:flutter/material.dart';

class CustomThumbShape extends RoundSliderThumbShape {
  final String text;
  final BuildContext buildContext;

  CustomThumbShape(
      {required this.text,
      required this.buildContext,
      super.enabledThumbRadius});

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    // 调用父类的绘制方法
    super.paint(context, center,
        activationAnimation: activationAnimation,
        enableAnimation: enableAnimation,
        isDiscrete: isDiscrete,
        labelPainter: labelPainter,
        parentBox: parentBox,
        sliderTheme: sliderTheme,
        textDirection: textDirection,
        value: value,
        textScaleFactor: textScaleFactor,
        sizeWithOverflow: sizeWithOverflow);

    // 绘制文本
    final textStyle = TextStyle(
        color: Theme.of(buildContext).colorScheme.onSurface,
        height: 1,
        fontSize: 10,
        fontWeight: FontWeight.normal);
    final TextSpan span = TextSpan(style: textStyle, text: text);
    final TextPainter textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // 计算文本位置
    final Offset textOffset = Offset(center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2 + .3);
    textPainter.paint(context.canvas, textOffset);
  }
}
